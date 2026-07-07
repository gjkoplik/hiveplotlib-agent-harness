#!/usr/bin/env bash
# Deterministic release-readiness audits (qa-engineer's mechanical steps).
#
# The prose specs in .claude/agents/qa-engineer.md DEFINE these audits; this
# script implements them, so every qa pass runs the same checks instead of
# re-deriving greps from prose. qa-engineer interprets and tags the output;
# the script never decides severity.
#
# Usage:
#   bash audit.sh [consumer-path] [audit ...]
#
# audits: scaffolding | test-contract | rationalization | changelog-cap | all
# Default consumer-path is the current directory; default audit is "all".
# Output: one "== <audit> ==" block per audit, each "clean", "skipped (...)",
# or file:line hits. Exit code is always 0 (findings are qa's to interpret,
# not a build failure); a genuinely broken run prints "ERROR:" lines.

set -u

CONSUMER="."
if [ $# -gt 0 ] && [ -d "$1" ]; then
  CONSUMER="$1"
  shift
fi
AUDITS=("$@")
[ ${#AUDITS[@]} -eq 0 ] && AUDITS=(all)

want() {
  local a
  for a in "${AUDITS[@]}"; do
    if [ "$a" = "$1" ] || [ "$a" = "all" ]; then return 0; fi
  done
  return 1
}

# Directories swept by the grep-based audits, when they exist. Auto-generated
# notebook copies are excluded per the qa spec.
SWEEP_DIRS=()
for d in src tests examples docs; do
  [ -d "$CONSUMER/$d" ] && SWEEP_DIRS+=("$CONSUMER/$d")
done

GREP_EXCLUDES=(--exclude-dir=notebooks --exclude-dir=gallery_examples --exclude-dir=.ipynb_checkpoints --exclude-dir=__pycache__)

sweep_grep() {
  # $1: extended regex. Prints file:line hits; silent when none.
  [ ${#SWEEP_DIRS[@]} -eq 0 ] && return 0
  grep -rnE "${GREP_EXCLUDES[@]}" -e "$1" "${SWEEP_DIRS[@]}" 2>/dev/null || true
}

report() {
  # $1: audit name, $2: hits (possibly empty)
  echo "== $1 =="
  if [ -z "$2" ]; then
    echo "clean"
  else
    echo "$2"
  fi
}

# --- Plan-scaffolding audit (mental-model rule 15) --------------------------

if want scaffolding; then
  hits=$(sweep_grep 'Workstream [A-Z]|Phase [0-9]|per Workstream|per Phase')
  report scaffolding "$hits"
fi

# --- Rationalization-marker audit -------------------------------------------

if want rationalization; then
  regular=$(sweep_grep 'rather than|instead of|to save|to keep cheap|would be expensive|more efficient than|as a compromise|for efficiency')
  high_fp=$(sweep_grep 'to avoid|to simplify|for simplicity')
  hits=""
  [ -n "$regular" ] && hits=$(echo "$regular" | sed 's/^/[marker] /')
  if [ -n "$high_fp" ]; then
    tagged=$(echo "$high_fp" | sed 's/^/[high-fp] /')
    if [ -n "$hits" ]; then hits="$hits
$tagged"; else hits="$tagged"; fi
  fi
  report rationalization "$hits"
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
        target = max(candidates, key=len)
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
