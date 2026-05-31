---
name: mental-model
description: Mental model for working on hiveplotlib (network visualization Python library) — workflow rules including plan-then-execute, replace-and-sweep, naming-at-planning; library invariants including the 2-3 axis rule, NetworkX optional, 100% coverage; viz quality bar (storytelling-with-data, Cole Knaflic-aligned); and prose voice (no em-dashes, no AI filler). Load whenever working on hiveplotlib code, tests, docs, notebooks, or research.
type: skill
---

# Mental model for hiveplotlib work

Shared knowledge every agent in the hiveplotlib harness loads. Source of truth for defaults, names, quality bars, and process choices. If you disagree with a rule, surface to the user before acting.

## Workflow rules

### 1. Plan before execute

Non-trivial work needs a plan. Hiveplotlib (and wiki-structure) plans live at `wiki/wiki/plans/<topic>.md` in the wiki submodule. Harness-self plans live at `agent-harness/.claude/plans/<topic>.md` (gitignored). Template: `agent-harness/.claude/templates/plan-template.md`. The Orchestrator owns plan production; specialists execute against accepted plans. Trivial tasks (one-line fixes, docstring tweaks) skip the plan.

New plans always start in the top-level `plans/` directory. Shipped wiki plans move to `wiki/wiki/plans/archived/<topic>.md` (see rule 10); listing *active* plans means the top-level glob `wiki/wiki/plans/*.md`, which excludes `archived/`. When resolving a referenced plan by name, check `archived/` as a fallback. Harness-self plans stay flat (no `archived/`).

Plans that add or modify user-facing API include an "API usage examples" section with runnable snippets, reviewed by the API Critic at planning time.

### 2. Replace-and-sweep is part of the change

A new API that wraps or replaces an existing pattern ships with all call sites swept in the same plan and PR: notebooks, docstring examples, README, install instructions, autodoc references, tests (some legitimately retain the old API for coverage). The Orchestrator greps during planning and lists hits in "Patterns this replaces". The QA Engineer greps post-execution; survivors fail unless listed in `Holdouts` with a reason.

### 3. Justify defaults from the user's workflow

Each user-facing default gets one sentence in the plan: what is the user trying to do when they reach for this code, and why does the default match? Library-internal symmetry is not a justification.

### 4. Walk the user-intended API against realistic data

Plans show the entry point exercised end-to-end against data the user actually has, not data engineered to satisfy the implementation. If the example requires inventing a convention the library doesn't document, either authorize the convention explicitly in the plan (naming, docstring, tests) or change the entry point. Test fixtures and notebook example data satisfy the same standard.

### 5. Naming follows user vocabulary, decided at planning time

Plans audit new parameter, method, class, and prose names against the vocabulary users would use, often borrowed from the dominant adjacent ecosystem (NetworkX for graphs, ML for embeddings). Internal module/package names stay engineer-flavored. Naming is expensive to change after shipping; settle it before code.

### 6. Plan-as-living-document

After each workstream, the executing agent writes one line to the plan's Implementation log in the same turn. QA Engineer flags missing entries.

### 7. Critics auto-fix deterministic issues, propose taste calls

Auto-fix without asking: lint, format, type, broken links, missing newlines, failing tests (with a real fix attempt, not removal). Propose only, with confidence tag (`must-fix` / `worth-discussing` / `low-confidence`): design choices, ergonomic suggestions, structural preferences, after-the-fact naming. When in doubt, propose.

Critics participate in **both** planning and post-implementation review whenever a workstream touches their domain. Mechanical propagation of an existing surface to a sibling class still requires post-impl review — the propagation framing does not exempt the new surface from a user walkthrough.

### 8. Preserve user-friendly framing in rewrites

A docstring or prose rewrite with more information that's harder to read is a regression. Layer new info on top of the clear lede.

### 9. Halt on confusion; never self-recover or run destructive ops

When state doesn't match expectations, STOP and surface a `STATUS: BLOCKED` report. The first line is `STATUS: BLOCKED`; the routine `Status:` line is absent. Body describes the confusion and proposed recovery options.

**Triggers include:** a file you didn't modify is modified, code doesn't match the brief, an unfamiliar test failure shape, `pytest` output you can't classify, a plan claim that doesn't match source state, an obstacle to the brief (an unexpected cost, a name that doesn't fit, a constraint conflicting with the named entry point), or a sub-agent surface-back trigger.

**Why halt and not normalize:** multiple agents may be active in the same working tree. Unexpected state is the expected operating condition, not broken state to fix.

**Banned anti-actions when the rule fires** — any command that discards uncommitted work the agent did not read first, in any form:

- Working-tree discards: `git checkout -- <path>`, `git restore` without `--source`, `git reset --hard`, `git clean`, `git switch --discard-changes`, any `--force` / `-f` flag on `push`/`branch`/`tag`.
- Stash / history discards: `git stash drop`, `git stash clear`, `git branch -D`, `git reflog expire`, `git filter-branch`/`filter-repo`.
- Non-git: `rm -rf` on tracked files, `>` / `>>` overwriting tracked files, `mv` overwriting a tracked file, `Write` overwriting a file the agent did not just read.
- Silent substitution: when the brief specifies entry point X and X can't be executed, surface back; do not substitute Y and proceed.
- Rationalization prose bridging a substitution in a shipped artifact ("uses X rather than Y because..."). The bridging belongs in the plan or in the surface-back message, not in the artifact.
- Editing a `conftest.py` or modifying inputs to make a test pass.

The ban is absolute. User authorization to ship a workstream is not authorization to run destructive ops while shipping it. The enumeration is non-exhaustive; any command matching the category is banned.

### 10. Promote major plans to wiki ADRs

When a major plan finishes shipping (work complete, tests pass, user has reviewed), Research Liaison distills it into `wiki/wiki/adr/NNNN-topic.md`. Conventions: 4-digit sequential `NNNN`, kebab-case slug naming the decision, `Status: Proposed | Accepted | Superseded by NNNN`, append-only (supersede with a new record, link both directions). Concision per rule 17 (ADR shape).

**Scope:** hiveplotlib consumer-repo plans only. Harness-self plans use `agent-harness/CHANGELOG.md` as their durable record. Trivial plans skip.

**Triggers:** Orchestrator invokes Research Liaison at planning start to surface relevant prior ADRs. QA Engineer flags eligibility at task close as a `worth-discussing` concern; user green-lights; Research Liaison promotes.

**Archiving:** once a wiki plan has fully shipped, it moves to `wiki/wiki/plans/archived/<topic>.md` so the active `plans/` directory shows only in-flight work. Research Liaison *proposes* the move (at ADR promotion for ADR-eligible plans, or in its post-task pass for non-ADR plans); the user confirms and performs it. Agents never move plan files. A technically-done plan still bundled with unshipped work stays active until the bundle ships. Harness-self plans don't archive.

### 11. Agents grow their own expertise

Expertise files live under `agent-harness/.claude/expertise/` — curated playbooks, not logs. They come in two shapes: **per-role files** (`<agent>.md`), each read by that agent at task start, and **one cross-cutting file** (`personal-gotchas.md`) for gotchas owned by no single role (environment, shell, working-style). Every agent, and the dispatching session, reads the cross-cutting file at task start in addition to any role file. Route a new lesson to the most specific home; the cross-cutting file is a fallback, not a default. Expertise is where learned failure modes accumulate; mental-model and agent definitions carry invariants (rules that hold universally), expertise carries lessons (the specific shape that bit us, watch for it). Update by editing existing entries when refined, adding only when truly new ground is covered, removing when the entry no longer earns its place. Ratchet model: add constraints when you've seen a real failure, remove when the underlying issue is genuinely gone. The file should ratchet toward better, not bloat toward longer.

**Entry shape.** Each entry is composed of: (1) a **lead** — one bold sentence stating the rule in imperative voice, or a `### Subhead` when the entry needs a worked example with quoted artifacts; (2) a **body** of 1-3 sentences carrying the lesson, its trigger/test (what to watch for, how to apply it), and where it sharpens the lesson a brief concrete example, not a blow-by-blow incident recap. Ground each entry in a real failure or repeated success you actually hit, not invented advice. Keep the lesson, its specifics (file:line refs, code tokens, predicates, the trigger), and any illuminating example, but do **not** cite the originating plan, workstream, amendment, job, or branch: nobody looks it up, the git log and plan already hold provenance, and the reference is dead weight in a file re-read every task. The test on a draft: every sentence should be doing teaching work (stating the rule, naming the failure shape, or showing the example that demonstrates it). Keep it lean: soft target ~60-90 words per entry; an entry needing materially more is usually two lessons (split) or over-narrated (cut). Per-file headers point back here rather than restating the shape.

### 12. Stay release-ready continuously

Every merge is treated as if it could ship. Tests pass, coverage holds at 100%, warnings-as-errors enforced, docs build cleanly with zero warnings, notebooks run end-to-end, `CHANGELOG.rst` updated for user-visible work, ADRs filed for major design decisions. Pre-existing docs warnings are debt the current workstream surfaces. Release time is mechanical: semver bump, version-string update, git tag.

### 13. Changelog discipline during work

Specialists append CHANGELOG entries in the same workstream that introduces user-visible work. Don't defer; don't reconstruct.

**Routing by plan path:** plan at `wiki/wiki/plans/` → `hiveplotlib/CHANGELOG.rst`. Plan at `agent-harness/.claude/plans/` → `agent-harness/CHANGELOG.md`. Split cross-consumer plans at planning time.

**Sections (Keep a Changelog):** `Added`, `Changed`, `Fixed`, `Removed`, plus `Tooling Changes` for consumer dev-loop work.

**Entry style:** high-level abstraction of what changed, in one or two lines. Not a recitation of mechanism. "Added support for X" beats a paragraph cataloguing every rule edit. Pointers to plan paths are welcome; verbatim restatement of the rule change is not.

**In/out of scope for harness CHANGELOG:** behavioral changes are in scope (new rules, agent-workflow changes, report-format changes, trip-wires, new artifacts, `sync.sh` changes). Expertise updates, wording refinements with no behavior change, plan-file edits, typos, formatting-only changes are out. Heuristic: would this invalidate or introduce a contributor habit?

Per-role authorship: the executing specialist files the entry. QA Engineer verifies presence.

### 14. Route emergent work back through the Orchestrator

Scope-changing decisions surfacing mid-flight route to the Orchestrator in `amend-plan` mode, not directly to the user, not ad-hoc to the dispatching session.

**Triggers:** (a) any post-impl critic finding tagged `must-fix` or `should-fix`; (b) any user ask that would add a new workstream, modify an existing workstream's done-when, or defer an item to a follow-up.

**Chain:** critic writes finding into the plan → dispatching session sees the trigger during routine dispatch → dispatching session invokes Orchestrator in `amend-plan` mode → Orchestrator edits the plan's "Plan amendments" section and returns a dispatch recommendation. QA Engineer's check that post-impl sections are filled is the gate; it is not a hop in the chain.

Routine dispatch decisions (which specialist runs which workstream, sequencing within the plan, retry on transient failures) stay with the dispatching session.

### 15. No plan-internal scaffolding in shipped artifacts

Plan-management metadata belongs in the plan, commit message, and PR description, not in source, tests, notebooks, or docstrings — test docstrings included, which state the behavior under test, not the review history that produced it. Banned in shipped artifacts: workstream identifiers ("Workstream I"), phase numbers, plan-section references, "per Workstream X" provenance, and **process/role provenance** (a harness role, a review mode, a plan item number, a "user resolution"). Name section dividers by topic; the git log captures provenance. QA Engineer greps for survivors; auto-strip (delete or rename to topic) is "objective wrongness", not a taste call.

### 16. Scratch artifacts go to system `/tmp/`, not the project tree

Diagnostic dumps (PNG renderings for side-by-side comparison, intermediate data exports, helper scripts) go to `/tmp/<descriptive-subdir>/`, not under the consumer repo. The working tree is git-tracked space; even untracked artifacts there clutter `git status` and risk accidental commits during a `git add .`. `/tmp/` is OS-managed, outside git's view entirely. Notebook cell PNGs are also reachable in-memory from `cell.outputs[].data['image/png']` (base64) when the agent already has the `.ipynb` open; decoding from the notebook is usually faster than re-rendering anyway. When a working artifact legitimately belongs in the repo (a new test fixture, a new example image, a new dataset), name it under the canonical home (`tests/`, `examples/`, `docs/source/_static/`, `src/hiveplotlib/datasets/`); never under an ad-hoc top-level scratch directory. Applies to any agent with `Bash` or `Write` access — viz-critic, code-engineer, qa-engineer, notebook-author, anyone.

### 17. Long-form authored artifacts are directly readable

Plans, plan amendments, and ADRs are written to be read directly, not skimmed past in favor of a summary. One concision standard, cited from each authoring surface (the define-once-cite-everywhere mechanic of rule 11), with a shape per artifact:

- **Plans:** readable without a summary crutch. Cut narration, hedging, and over-justification; say each thing once (a decision stated in Goal is not restated in Default justifications or the workstream block); each section earns its length; done-whens terse and checkable; lists or tables over prose where clearer.
- **Amendments:** as tight as an expertise entry: delta, rationale, which done-whens it touches, the In-scope / Added / Deferred tag. Not a narration of how the ask arrived.
- **ADRs:** a distilled record, not a narrative. Keep it short, single screen typically.

Binds the Orchestrator (plans, amendments) and Research Liaison (ADRs) at authoring time.

## Library invariants

**Hive plots have 3 axes, almost always.** Default mental model is 3 axes, often with repeat axes (karate club is canonical, 3 axes + repeats = 6 effective halves). 2 axes without repeats is essentially never useful (one toy pedagogical notebook). 4+ axes is a bug; use HivePlotMatrix instead. Partition design uses meaningful binary or ternary cuts, not numbered community-detection labels.

**Edge kwargs follow a configurable hierarchy.** Default order, lowest to highest priority: `all_edge_kwargs` → `clockwise_edge_kwargs` / `counterclockwise_edge_kwargs` / `repeat_edge_kwargs` (equal middle) → `non_repeat_edge_kwargs`. Stored on `HivePlot.edge_kwarg_hierarchy`, user-reorderable. `plot()` kwargs deprioritized below the hierarchy; `Edges` instance kwargs below those. `update_edges()` is the explicit per-pair override and bypasses the hierarchy without warning. Each backend's `rename_edge_kwargs()` handles translation. Canonical reference: `examples/edge_kwarg_hierarchy.ipynb`.

**Lightweight by design, optional extras for everything else.** Core: matplotlib + numpy + pandas. Optional extras: `hiveplotlib[networkx|bokeh|holoviews|plotly|datashader]`. Imports wrapped in try/except with helpful errors. Tests for optional-dep code are marker-gated (`@pytest.mark.networkx` etc.); CI verifies subset installs.

**Test discipline.** 100% coverage (`--cov=src/hiveplotlib`). All warnings as errors. 7 parallel workers. `tests/foo_test.py` mirrors `src/hiveplotlib/foo.py`. Test name = test body contract: `test_<method>_<scenario>` must call `<method>` in its body. If the named entry point can't be tested as-is, halt under rule 9.

**Test the programmatic consumer, not a rendering-only surface.** Before asserting on `__doc__`/`__name__`/`__qualname__`/introspection, ask who reads it. If library code does, test that consumer's output (the surface is covered transitively). If only rendering does (Sphinx, `help()`, tables), it's docs-engineer + human review, not pytest — and import usually already covers the lines, so the test adds nothing. Pinning docstring prose substrings protects nothing and fights rule-8 rewrites.

## Viz quality bar

Loaded as its own skill at `<harness>/.claude/skills/viz-quality-bar/SKILL.md`. Storytelling-with-data, accessibility, data-ink discipline, palette discipline, polish-in-proportion-to-role, hive-plot-specific rules, datashader specifics, empirical patterns from the corpus. Load that skill whenever working on figures, viz cells, viz backend code, or reviewing rendered figures.

## Prose voice

Applies to text the reader sees (notebook markdown, README/docs prose, PR descriptions, commit message bodies). Code comments exempt.

- **No em-dashes.** Use commas, parentheses, semicolons, periods. The em-dash is the biggest AI tell.
- **No AI filler:** "delve", "moreover", "furthermore", "underscore", "in essence", "it's worth noting that", "as we can see", "in the realm of".
- **No throat-clearing.** "First, let's discuss X" before discussing X adds nothing.
- **No hedging meta-commentary.** "It is important to note that X" is just "X".
- **Library helpers are tools, not characters.** Just use `flexitext`, `seaborn`, `numpy.random.default_rng`.
- **Direct, slightly informal.** "Let's look at what happens when we sort by degree" beats "We shall now examine the consequences."
- **Compression is the default.** Match or undershoot the length of sibling entries when adding to CHANGELOG, expertise, agent definitions, or in-place docs. Cut sentences that don't carry load-bearing information. The git log carries provenance, the wiki carries deep context, in-place prose carries only what the reader needs at hand. When in doubt, less. Long-form authored artifacts (plans, amendments, ADRs) follow rule 17's per-shape standard.

## Pointers

- `hiveplotlib/CLAUDE.md` — architecture, commands, entry points
- `<harness>/.claude/skills/hiveplotlib-tutorial-notebook/SKILL.md` — tutorial style
- `<harness>/.claude/skills/hiveplotlib-gallery-notebook/SKILL.md` — gallery style
- `wiki/wiki/` — research, prior thinking, ADRs at `wiki/wiki/adr/`
- `<harness>/.claude/templates/plan-template.md` — the plan template
