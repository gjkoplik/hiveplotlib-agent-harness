# Expertise: Test Engineer

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry comes from a real failure or repeated success (not invented advice), follows the entry shape (lead + body, no originating-plan citation), and stays lean (soft target ~60-90 words) per mental-model rule 11.

## Patterns to reach for

- **Empirically verify dedup / identity preconditions before writing the assertion.** When a brief asserts "these two objects share `id(X)`," REPL-check it first; briefs assume aliasing that may not hold (e.g. `Edges.__init__` -> `_validate_edge_data` builds a fresh dict, so two `HivePlot(nodes, edges)` calls do **not** share `id(hp.edges._data)`). If false, surface the gap and test an artificial scenario that *does* hit the path (e.g. `hp_b.edges = hp_a.edges`). Trigger: dedup tests, identity-based caching tests, "metric computed once" tests.
- **Monkey-patch lazy-imported function-local references via the module attribute.** When source does `def foo(): from mod import func; func(...)`, patch `mod.func` (or `monkeypatch.setattr(mod, "func", wrapper)`), not the importing module: `from X import Y` re-resolves each call. Pattern: dedup-counter and side-effect-counter tests for lazily-imported helpers.
- **On test-deletion / parametrize-pruning briefs, run the full failing suite first, then cross-check the brief's enumeration.** Briefs name the obvious removals but miss siblings that pass the now-removed kwarg via an intermediate helper (e.g. `_call_consolidated("from_tags", graph=g)`). The post-revert `pytest tests/<file>.py -n 7 --no-cov` output is ground truth: every failure not in the brief is a sibling the brief missed; cite each in the Implementation log as targeting the removed surface, don't self-recover or skip. Trigger: any "remove tests for the just-reverted surface" brief, especially parametrize-decorator surgical drops.

## Anti-patterns

- **No bug archaeology or review history in test docstrings.** Mechanism prose rots on refactor and history lives in git blame; state the behavior under test, full stop. Process/role provenance counts too: citing a plan item, critic, or review mode as the reason a test exists leaks plan metadata into a shipped artifact (rule 15). Trigger: "Regression test for X" framing, "failing-before" prose, or a critic/review-mode/plan-item citation.
- **Rendering-only surfaces aren't test targets (mental-model Test discipline).** `__doc__`/`__name__`/`__qualname__` with no library consumer are covered at import and owned by docs review; a unit test on them is orthogonal in a behavior suite.

## Gotchas

- **Ruff's D205 + E501 collision on docstring summary lines.** Folding a multi-line summary onto one line for D205 ("blank line between summary and description") often pushes it over 120 chars and trips E501. Fix both at once: pick a summary short enough to fit on one line *and* read as a single sentence. Trigger: adding a `:py:meth:` cross-ref to a summary line.
- **`nodes_edges_to_networkx` round-trip tests need disjoint `(from, to)` pairs across tags on non-multigraph targets.** Parametrizing over `(directed, multigraph)`, the `multigraph=False` cases land on `nx.Graph` / `nx.DiGraph`, which silently merge duplicate edges (last write wins; see the converter's `note::`). Two tags sharing a `(from, to)` pair fail `recovered_pairs == original_pairs` on the `[graph]` and `[di]` parametrizations only. Fix: disjoint `(from, to)` pairs per tag in fixtures, or restrict the parametrization to multigraph cases.
