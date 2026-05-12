# Expertise: Test Engineer

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry earns its line by tracing to a real failure or repeated success.

## Patterns to reach for

- **Empirically verify dedup / identity preconditions before writing the assertion.** When a brief says "these two objects share `id(X)`," run a quick REPL check first. Briefs sometimes assume runtime aliasing behavior that doesn't actually hold (e.g. `Edges.__init__` -> `_validate_edge_data` constructs a fresh dict, so two `HivePlot(nodes, edges)` calls do **not** share `id(hp.edges._data)`). If the precondition is false, surface the gap as an open question and write the test against an artificial scenario that *does* exercise the code path (e.g. `hp_b.edges = hp_a.edges`). Trigger: dedup tests, identity-based caching tests, "metric computed once" tests.
- **Monkey-patch lazy-imported function-local references via the module attribute.** When source code does `def foo(): from mod import func; func(...)`, patching `mod.func` (or `monkeypatch.setattr(mod, "func", wrapper)`) works because `from X import Y` re-resolves on each call. No need to patch the importing module. Pattern: dedup-counter tests, side-effect-counter tests for lazily-imported helpers.

## Anti-patterns

_Specific failure modes seen in this role, each tied to a real incident or repeated mistake. Empty until earned._

## Gotchas

- **Ruff's D205 + E501 collision on docstring summary lines.** Folding a multi-line summary onto one line to satisfy D205 ("blank line between summary and description") often pushes the line over 120 chars and trips E501. Fix both in one pass: pick a summary short enough to fit on one line *and* read as a single sentence. Surfaced when adding tests with `:py:meth:` cross-refs in the summary.
