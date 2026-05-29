# Expertise: Code Engineer

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry comes from a real failure or repeated success (not invented advice), follows the entry shape (lead + body, no originating-plan citation), and stays lean (soft target ~60-90 words) per mental-model rule 11.

## Patterns to reach for

_Approaches that work in this role, with the trigger that suggests reaching for each. Empty until earned._

## Anti-patterns

_Specific failure modes seen in this role, each tied to a real incident or repeated mistake. Empty until earned._

## Gotchas

- **Widening required params to `Optional` for runtime-validated mutual exclusion needs `assert ... is not None` afterwards.** When a parameter is `Optional[T] = None` resolved to non-`None` via a validation block (raising `ValueError`) or a derivation step (e.g. extracting `nodes`/`edges` from `graph`), `ty` cannot narrow the type across that control flow, so downstream calls expecting `T` fail type-check. Fix: add `assert nodes is not None` / `assert edges is not None` after the block, matching the `assert sorting_variables is not None` pattern at `hiveplot_matrix.py:1288`.
- **A decorator reading `func.__name__` trips ty (`Callable` has no `__name__`) and breaks for factory-built wrappers.** ty cannot prove an arbitrary `Callable[..., Any]` is a function, so `func.__name__` inside the wrapper fails type-check; and for wrappers built by a factory, `__name__` is the generic inner name at decoration time. Fix both at once: capture `name = getattr(func, "__name__", repr(func))` once in the decorator body (before defining the inner wrapper), and for factory products set `base.__name__` *before* applying the decorator so `functools.wraps` carries the real name through.
- **A set/list comprehension that filters `None` out of `Optional[T]` values still infers element type `Optional[T]` under ty, so `pop()`/return widens past `T`.** ty does not propagate the `if x is not None` guard into the comprehension's element type. Fix: bind the value with a walrus in the guard and yield the bound name (`{v for n in names if (v := f(n)) is not None}`), and annotate the target (`concrete: set[bool] = {...}`); ty then narrows the element to the non-`None` type.
- **Pass `dtype=object` to `np.array(...)` when the source list mixes element types.** numpy silently promotes mixed-type lists to `<U21` (unicode), turning int `0`/`1` into strings `"0"`/`"1"` with no warning; downstream code holding the original ints (dict-key lookups, `isinstance` checks) then breaks with `KeyError`/`TypeError`. Generalizes to any `np.array([...])` from a comprehension or mixed list. CI missed it because all `HivePlotMatrix` tests used string partitions.
