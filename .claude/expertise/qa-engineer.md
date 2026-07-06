# Expertise: QA Engineer

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry comes from a real failure or repeated success (not invented advice), follows the entry shape (lead + body, no originating-plan citation), and stays lean (soft target ~60-90 words) per mental-model rule 11.

## Patterns to reach for

- **CI-only segfaults in the dask + pandas 3 stack: prove the mechanism with a stack-filtered constructor counter, not a local repro.** pandas 3's arrow-backed string construction (`ArrowStringArray._from_sequence`) is not thread-safe under dask's threaded scheduler, and a many-core dev box rarely trips what a 2-core runner does. Any list-label `.loc` / `df[[...]]`, dict-keyed `pd.DataFrame(...)`, or dtype-mismatched `Index.equals` in worker-thread code constructs one. Monkeypatch a counter filtered on `apply_and_enforce` in the call stack, run one render, then drive worker-thread constructions to zero (single-label pulls, integer-keyed construction, one shared columns `Index` for partitions and meta).
- **When a deterministic auto-fix target sits in uncommitted co-running work, propose instead of editing.** The CHANGELOG cap check (or any in-place compression) can fire on an entry another in-flight branch just added; that text's only copy is the working tree, so editing it silently rewrites sibling work with no recoverable original. Check provenance with `git diff <file>` first: committed over-cap entries get compressed in place, uncommitted co-running ones get a ready-made compression in the proposed concerns.

## Anti-patterns

- **Don't soft-pedal pre-existing docs-build warnings into `Docs build: pass` with a parenthetical caveat.** `Docs build: pass` means zero warnings, zero errors; pre-existing warnings are debt this workstream must surface, not "noise unrelated to this workstream." Surface every warning with `file:line: <warning>` citations as a `must-fix` proposed concern by default; the `worth-discussing` carve-out applies only when the workstream itself is `docs-scope` per the brief. Operational mechanics live in qa-engineer.md workflow step 5 — point at step 5 rather than paraphrasing, so this entry doesn't drift. The soft-pedal shape to ban reads like "N warnings, all pre-existing, unrelated to this workstream."
- **Process jargon in shipped code is a `must-fix` standing-rule violation, not a low-confidence cosmetic note, and "shipped code" includes in-repo dev tooling.** The maintainer's standing rule bans tying repo code to plans/process that don't live in the repo (grill/WS labels, plan-section names, dates, "the harness"). 2026-07-03: `benchmarks/benchmarks.py` and the perf-regression test-constant module shipped with such jargon; QA had flagged it but downgraded it to "low-confidence cosmetic," it was let slide, and the maintainer caught it with "should I be worried about finding this stuff elsewhere too?" Rate it `must-fix` and grep the *whole* diff, not just `src/`: `benchmarks/`, ASV configs, `tests/` constant modules, `runners/`, and Makefile/CI comments all count as shipped surfaces.

## Gotchas

_Surprises not obvious from reading the code, docs, or other agents' definitions. Empty until earned._
