#!/usr/bin/env bash
# Deterministic release-readiness audits (qa-engineer's mechanical steps).
#
# The prose specs in .claude/agents/qa-engineer.md DEFINE these audits; this
# script implements them, so every qa pass runs the same checks instead of
# re-deriving greps from prose. qa-engineer interprets and tags the output;
# the script never decides severity.
#
# Usage:
#   bash audit.sh [consumer-path] [--base <ref>] [audit ...]
#
# audits: scaffolding | test-contract | rationalization | changelog-cap
#         | surface | all
# Default consumer-path is the current directory; default audit is "all".
# --base <ref> sets the diff base for the `surface` audit (default HEAD, i.e.
# staged + unstaged changes vs the last commit).
# Output: one "== <audit> ==" block per audit, each "clean", "skipped (...)",
# "excluded (...)" (deliberately not run for this consumer), or file:line hits.
# Exit code is always 0 (findings are qa's to interpret, not a build failure);
# a genuinely broken run prints "ERROR:" lines.
#
# The `surface` audit classifies the diff into security-relevant and
# performance-relevant buckets so qa's "must this audit fire?" decision is
# deterministic (it does NOT run any tool — running uv audit / the perf make
# targets stays with qa, which keeps this script consumer-agnostic).

set -u

CONSUMER="."
if [ $# -gt 0 ] && [ -d "$1" ]; then
  CONSUMER="$1"
  shift
fi

BASE="HEAD"
POS=()
while [ $# -gt 0 ]; do
  case "$1" in
    --base) BASE="$2"; shift 2 ;;
    --base=*) BASE="${1#--base=}"; shift ;;
    *) POS+=("$1"); shift ;;
  esac
done
AUDITS=("${POS[@]}")
[ ${#AUDITS[@]} -eq 0 ] && AUDITS=(all)

want() {
  local a
  for a in "${AUDITS[@]}"; do
    if [ "$a" = "$1" ] || [ "$a" = "all" ]; then return 0; fi
  done
  return 1
}

GREP_EXCLUDES=(--exclude-dir=notebooks --exclude-dir=gallery_examples --exclude-dir=.ipynb_checkpoints --exclude-dir=__pycache__)

# The harness repo is itself a consumer, and what it ships is markdown, not a
# Python package. Detect it by layout, so the answer survives a checkout at any
# path: sync.sh and .claude/agents/ at the root, and no Python project file.
harness_self() {
  [ -f "$CONSUMER/sync.sh" ] && [ -d "$CONSUMER/.claude/agents" ] && [ ! -f "$CONSUMER/pyproject.toml" ]
}

# Paths swept by the grep-based audits, when they exist. Auto-generated notebook
# copies are excluded per the qa spec.
SWEEP_TARGETS=()
if harness_self; then
  # The harness's shipped artifacts are .claude/ plus the root markdown. Three
  # exclusions: .claude/plans/ is gitignored working scratch holding append-only
  # adversary and grill records; the expertise files quote the swept patterns
  # on purpose, as records of what went wrong; and a template is a scaffolding
  # generator, so its own workstream headings and log-format examples are
  # definition sites by construction, not survivors (same argument as the
  # expertise exclusion). .claude/specs/ is deliberately NOT excluded, however
  # much it looks symmetric with plans/: plans/ is working scratch, while a spec
  # is signed and maintainer-facing, the most reader-facing artifact the harness
  # has, so a spec carrying plan scaffolding is exactly the defect rule 15
  # exists to catch.
  SWEEP_TARGETS+=("$CONSUMER/.claude")
  GREP_EXCLUDES+=(--exclude-dir=plans --exclude-dir=expertise --exclude-dir=templates)
  for f in CLAUDE.md README.md CHANGELOG.md diagrams.md; do
    [ -f "$CONSUMER/$f" ] && SWEEP_TARGETS+=("$CONSUMER/$f")
  done
else
  for d in src tests examples docs; do
    [ -d "$CONSUMER/$d" ] && SWEEP_TARGETS+=("$CONSUMER/$d")
  done
fi

sweep_grep() {
  # $1: extended regex. Prints file:line hits; silent when none.
  [ ${#SWEEP_TARGETS[@]} -eq 0 ] && return 0
  grep -rnE "${GREP_EXCLUDES[@]}" -e "$1" "${SWEEP_TARGETS[@]}" 2>/dev/null || true
}

report_sweep() {
  # $1: audit name, $2: hits (possibly empty). A sweep with nothing to read
  # reports "skipped", never "clean": a check that read zero files has not passed.
  echo "== $1 =="
  if [ ${#SWEEP_TARGETS[@]} -eq 0 ]; then
    echo "skipped (no sweep dirs)"
  elif [ -z "$2" ]; then
    echo "clean"
  else
    echo "$2"
  fi
}

# --- Plan-scaffolding audit (mental-model rule 15) --------------------------

if want scaffolding; then
  hits=$(sweep_grep 'Workstream [A-Z]|Phase [0-9]|per Workstream|per Phase')
  report_sweep scaffolding "$hits"
fi

# --- Rationalization-marker audit -------------------------------------------

if want rationalization; then
  if harness_self; then
    # Deliberately not run on the harness's own prose, and not an oversight. The
    # markers catch a substitution rationalized in a code comment; in agent and
    # skill definitions "rather than" and "instead of" are ordinary English, and a
    # hand-run over that corpus returned ten hits, all of them legitimate prose. A
    # gate that fires every time teaches its reader to skip it. The scaffolding
    # audit is the opposite case and does run here: "Workstream A" is never
    # legitimate in shipped prose.
    echo "== rationalization =="
    echo "excluded (harness-self: markers are ordinary prose in agent definitions, not a substitution signal)"
  else
    regular=$(sweep_grep 'rather than|instead of|to save|to keep cheap|would be expensive|more efficient than|as a compromise|for efficiency')
    high_fp=$(sweep_grep 'to avoid|to simplify|for simplicity')
    hits=""
    [ -n "$regular" ] && hits=$(echo "$regular" | sed 's/^/[marker] /')
    if [ -n "$high_fp" ]; then
      tagged=$(echo "$high_fp" | sed 's/^/[high-fp] /')
      if [ -n "$hits" ]; then hits="$hits
$tagged"; else hits="$tagged"; fi
    fi
    report_sweep rationalization "$hits"
  fi
fi

# --- Test-name-contract audit (mental-model rule 9 backstop) -----------------

if want test-contract; then
  echo "== test-contract =="
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$CONSUMER" <<'PYEOF'
import ast
import pathlib
import re
import sys

consumer = pathlib.Path(sys.argv[1])
src = consumer / "src"
tests = consumer / "tests"
if not (src.is_dir() and tests.is_dir()):
    print("skipped (no src/ or tests/)")
    sys.exit(0)

names = set()
for p in src.rglob("*.py"):
    try:
        tree = ast.parse(p.read_text(encoding="utf-8"))
    except (SyntaxError, UnicodeDecodeError):
        continue
    for node in ast.walk(tree):
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            if not node.name.startswith("_"):
                names.add(node.name)
# Short names ("plot", "axes") appear in almost every test name by accident;
# require >= 4 chars so containment means something.
names = {n for n in names if len(n) >= 4}

mismatches = []
for p in sorted(tests.rglob("*_test.py")):
    try:
        text = p.read_text(encoding="utf-8")
        tree = ast.parse(text)
    except (SyntaxError, UnicodeDecodeError):
        continue
    for node in ast.walk(tree):
        if not isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            continue
        if not node.name.startswith("test_"):
            continue
        rest = node.name[len("test_"):]
        candidates = [
            n for n in names
            if rest == n
            or rest.startswith(n + "_")
            or rest.endswith("_" + n)
            or ("_" + n + "_") in rest
        ]
        if not candidates:
            continue
        # sort before picking: `names` is a set, so equal-length candidates would
        # otherwise resolve by its run-to-run iteration order and flicker findings
        # in and out between runs on an unchanged tree
        target = max(sorted(candidates), key=len)
        body = ast.get_source_segment(text, node) or ""
        rel = p.relative_to(consumer)
        # Two tiers: [no-ref] means the named entity never appears in the body
        # at all (the real substitution signal); [ref-no-call] means it appears
        # but is never called (often a property access or kwarg reference).
        if target + "(" in body:
            continue
        if re.search(r"\b" + re.escape(target) + r"\b", body):
            mismatches.append(
                f"[ref-no-call] {rel}:{node.lineno}: test '{node.name}' references '{target}' but never calls it"
            )
        else:
            mismatches.append(
                f"[no-ref] {rel}:{node.lineno}: test '{node.name}' names '{target}' but never mentions it"
            )

print("clean" if not mismatches else "\n".join(mismatches))
PYEOF
  else
    echo "ERROR: python3 not found; run the test-name-contract audit manually"
  fi
fi

# --- CHANGELOG cap check (mental-model rule 13) ------------------------------

if want changelog-cap; then
  echo "== changelog-cap =="
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$CONSUMER" <<'PYEOF'
import pathlib
import re
import sys
import textwrap

consumer = pathlib.Path(sys.argv[1])
WRAP = 120
MAX_LINES = 4
hits = []


def unreleased_slice(lines, start_re, next_re):
    """Return (start, end) line indices of the unreleased section, or None."""
    start = None
    for i, line in enumerate(lines):
        if start is None and start_re.search(line):
            start = i + 1
        elif start is not None and next_re.match(line):
            return start, i
    return (start, len(lines)) if start is not None else None


def check_entries(path, lines, start, end):
    entry_text = []
    entry_line = None

    def flush():
        if entry_line is None:
            return
        joined = re.sub(r"\s+", " ", " ".join(entry_text)).strip()
        if len(textwrap.wrap(joined, WRAP)) > MAX_LINES:
            hits.append(f"{path}:{entry_line}: unreleased entry wraps past {MAX_LINES} lines at {WRAP} chars")

    for i in range(start, end):
        line = lines[i]
        if re.match(r"^- ", line):
            flush()
            entry_text, entry_line = [line[2:]], i + 1
        elif re.match(r"^\s+- ", line) and entry_line is not None:
            hits.append(f"{path}:{i + 1}: sub-bullet under an unreleased entry (rule 13 forbids sub-bullets)")
            flush()
            entry_text, entry_line = [], None
        elif entry_line is not None and re.match(r"^\s+\S", line):
            entry_text.append(line.strip())
        elif entry_line is not None:
            flush()
            entry_text, entry_line = [], None
    flush()


md = consumer / "CHANGELOG.md"
if md.is_file():
    lines = md.read_text(encoding="utf-8").splitlines()
    sec = unreleased_slice(lines, re.compile(r"^## (Unreleased|WIP)\b"), re.compile(r"^## "))
    if sec:
        check_entries("CHANGELOG.md", lines, *sec)

rst = consumer / "CHANGELOG.rst"
if rst.is_file():
    lines = rst.read_text(encoding="utf-8").splitlines()
    sec = unreleased_slice(lines, re.compile(r"\(unreleased\)", re.I), re.compile(r"^Version \d"))
    if sec:
        check_entries("CHANGELOG.rst", lines, *sec)

if not (md.is_file() or rst.is_file()):
    print("skipped (no CHANGELOG.md or CHANGELOG.rst)")
else:
    print("clean" if not hits else "\n".join(hits))
PYEOF
  else
    echo "ERROR: python3 not found; run the CHANGELOG cap check manually"
  fi
fi

# --- Surface audit: which qa gates MUST fire (security checklist, perf) ------
#
# Classifies the diff (vs BASE) into security-relevant and perf-relevant
# buckets. This makes the "must this audit fire vs. report n/a?" decision
# deterministic — the exact judgment the security and performance trip-wires
# exist to catch. It reports surfaces and MUST-fire verdicts; it does NOT run
# uv audit or the perf make targets (those stay with qa, per the qa spec, so
# this script has no consumer-specific tool coupling).

if want surface; then
  echo "== surface =="
  if [ ! -d "$CONSUMER/.git" ] && [ ! -f "$CONSUMER/.git" ]; then
    echo "skipped (consumer is not a git repo; cannot diff)"
  else
    # Changed files vs BASE (staged + unstaged). Renames/deletes included.
    changed=$(git -C "$CONSUMER" diff --name-only "$BASE" 2>/dev/null; git -C "$CONSUMER" diff --name-only --cached "$BASE" 2>/dev/null)
    changed=$(printf '%s\n' "$changed" | sort -u | sed '/^$/d')
    if [ -z "$changed" ]; then
      echo "no changes vs $BASE"
      echo "=> no security-relevant surface; no library source touched"
    else
      # Added lines in Python files only, for the content probes (the
      # deserialization / subprocess surfaces are Python-level concerns; scoping
      # to *.py keeps a non-Python file's own text — e.g. this script's grep
      # patterns — from matching itself).
      added_py=$(git -C "$CONSUMER" diff "$BASE" -- '*.py' 2>/dev/null; git -C "$CONSUMER" diff --cached "$BASE" -- '*.py' 2>/dev/null)
      added_py=$(printf '%s\n' "$added_py" | grep '^+' | grep -v '^+++' || true)

      match_files() { printf '%s\n' "$changed" | grep -iE "$1" || true; }

      ci_config=$(match_files '(^|/)\.gitlab-ci\.yml$|(^|/)\.github/workflows/|(^|/)ci/|(^|/)\.circleci/|azure-pipelines')
      publishing=$(match_files '(^|/)pyproject\.toml$|(^|/)setup\.(py|cfg)$|(^|/)MANIFEST\.in$|(^|/)\.pypirc$|publish|release')
      dependencies=$(match_files '(^|/)pyproject\.toml$|(^|/)uv\.lock$|(^|/)poetry\.lock$|requirements.*\.txt$|(^|/)setup\.(py|cfg)$|environment.*\.ya?ml$|(^|/)asv\.conf\.json$')
      data_paths=$(match_files '(^|/)datasets?/|loader')
      data_content=$(printf '%s\n' "$added_py" | grep -nE 'pickle\.(load|loads)|\.read_pickle|joblib\.load|urlopen|requests\.(get|post)|urllib|np\.load|np\.fromfile' || true)
      subprocess=$(printf '%s\n' "$added_py" | grep -nE 'subprocess\.|os\.system|shell\s*=\s*True|Popen\(' || true)
      # Perf figures: added prose lines carrying a measured magnitude or speedup, so a
      # `figure provenance: n/a` is checkable rather than assumed. Prose-scoped, so this
      # script's own patterns cannot match themselves.
      added_prose=$(git -C "$CONSUMER" diff "$BASE" -- '*.md' '*.rst' '*.ipynb' 2>/dev/null; git -C "$CONSUMER" diff --cached "$BASE" -- '*.md' '*.rst' '*.ipynb' 2>/dev/null)
      added_prose=$(printf '%s\n' "$added_prose" | grep '^+' | grep -v '^+++' || true)
      perf_figures=$(printf '%s\n' "$added_prose" | grep -nEi '[0-9]+(\.[0-9]+)? ?[gmk]b\b|[0-9]+(\.[0-9]+)? ?(ms|sec|seconds?)\b|[0-9]+(\.[0-9]+)?x (faster|slower|speedup)' || true)
      # Perf: changed .py under a src package tree (qa makes the docstring-only call from the diff).
      libsrc=$(match_files '(^|/)src/.+\.py$')

      emit() { if [ -n "$2" ]; then echo "$1: $(printf '%s' "$2" | paste -sd',' - | sed 's/,/, /g')"; else echo "$1: none"; fi; }
      emit "security.ci_config" "$ci_config"
      emit "security.publishing" "$publishing"
      emit "security.dependencies" "$dependencies"
      emit "security.data_deser (paths)" "$data_paths"
      emit "security.data_deser (added calls)" "$data_content"
      emit "security.subprocess (added calls)" "$subprocess"
      emit "perf.library_source" "$libsrc"
      emit "perf.figure_candidates" "$perf_figures"

      sec_fire=""
      [ -n "$ci_config$publishing$dependencies$data_paths$data_content$subprocess" ] && sec_fire=1
      if [ -n "$sec_fire" ]; then
        echo "=> security checklist MUST fire (a checklist n/a here is wrong)"
      else
        echo "=> no security-relevant surface touched (checklist n/a is honest)"
      fi
      if [ -n "$libsrc" ]; then
        echo "=> performance check MUST fire unless the src diff is verifiably docstring/comment-only"
      else
        echo "=> no library source touched (perf tool-run n/a (no executable change) is honest)"
      fi
      if [ -n "$perf_figures" ]; then
        echo "=> figure provenance MUST fire (a figure provenance n/a here is wrong)"
      else
        echo "=> no performance figure recorded (figure provenance n/a is honest)"
      fi
    fi
  fi
fi
