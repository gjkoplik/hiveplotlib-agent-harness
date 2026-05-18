# Expertise: Test Engineer

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry earns its line by tracing to a real failure or repeated success.

## Patterns to reach for

- **Empirically verify dedup / identity preconditions before writing the assertion.** When a brief says "these two objects share `id(X)`," run a quick REPL check first. Briefs sometimes assume runtime aliasing behavior that doesn't actually hold (e.g. `Edges.__init__` -> `_validate_edge_data` constructs a fresh dict, so two `HivePlot(nodes, edges)` calls do **not** share `id(hp.edges._data)`). If the precondition is false, surface the gap as an open question and write the test against an artificial scenario that *does* exercise the code path (e.g. `hp_b.edges = hp_a.edges`). Trigger: dedup tests, identity-based caching tests, "metric computed once" tests.
- **Monkey-patch lazy-imported function-local references via the module attribute.** When source code does `def foo(): from mod import func; func(...)`, patching `mod.func` (or `monkeypatch.setattr(mod, "func", wrapper)`) works because `from X import Y` re-resolves on each call. No need to patch the importing module. Pattern: dedup-counter tests, side-effect-counter tests for lazily-imported helpers.

## Anti-patterns

_Specific failure modes seen in this role, each tied to a real incident or repeated mistake. Empty until earned._

## Gotchas

- **Ruff's D205 + E501 collision on docstring summary lines.** Folding a multi-line summary onto one line to satisfy D205 ("blank line between summary and description") often pushes the line over 120 chars and trips E501. Fix both in one pass: pick a summary short enough to fit on one line *and* read as a single sentence. Surfaced when adding tests with `:py:meth:` cross-refs in the summary.
- **`nodes_edges_to_networkx` round-trip tests need disjoint `(from, to)` pairs across tags on non-multigraph targets.** When parametrizing a round-trip test over `(directed, multigraph)`, the `multigraph=False` cases land on `nx.Graph` / `nx.DiGraph`, which silently merge duplicate edges (last write wins; see the converter's `note::`). If two tags share a `(from, to)` pair, the second tag's row erases the first tag's row on the graph side and the round-trip assertion (`recovered_pairs == original_pairs`) fails on the `[graph]` and `[di]` parametrizations only. Pick disjoint `(from, to)` pairs per tag in test fixtures, or restrict the parametrization to multigraph cases. Surfaced when adding `from_tags(graph=...)` round-trip tests for Workstream N (edge-attribute-as-tag).
