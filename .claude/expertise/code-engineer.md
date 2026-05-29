# Expertise: Code Engineer

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry earns its line by tracing to a real failure or repeated success, and follows the entry shape (lead + body + anchor) and stays lean (soft target ~60-90 words) per mental-model rule 11.

## Patterns to reach for

_Approaches that work in this role, with the trigger that suggests reaching for each. Empty until earned._

## Anti-patterns

_Specific failure modes seen in this role, each tied to a real incident or repeated mistake. Empty until earned._

## Gotchas

- **Widening required params to `Optional` for runtime-validated mutual exclusion needs `assert ... is not None` afterwards.** When a parameter is `Optional[T] = None` and gets resolved to non-`None` via either a validation block (raising `ValueError`) or a derivation step (e.g. extracting `nodes`/`edges` from `graph`), `ty` cannot narrow the type across that control flow. Downstream calls that expect `T` (not `Optional[T]`) will fail type-check. Fix: add `assert nodes is not None` and `assert edges is not None` after the validation/derivation block. Matches the existing `assert sorting_variables is not None` pattern at `hiveplot_matrix.py:1288`. Triggered during Workstream I (consolidated NetworkX entry points).

- **Pass `dtype=object` to `np.array(...)` when the source list mixes element types.** numpy silently promotes mixed-type lists to `<U21` (unicode), turning int `0` and `1` into strings `"0"` and `"1"` with no warning. Downstream code holding the original ints (dict-key lookups, `isinstance` checks) then breaks with `KeyError`/`TypeError`. The rule generalizes to any `np.array([...])` built from a comprehension or list mixing types. Anchor: `HivePlotMatrix.from_partition` int-partition `KeyError` bugfix at `hiveplot.py:2852-2858`; `set_axes_order`'s collapse-replacement branch was stringifying integer partition keys. CI missed it because all `HivePlotMatrix` tests used string partitions.
