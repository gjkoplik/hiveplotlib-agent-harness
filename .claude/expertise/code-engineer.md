# Expertise: Code Engineer

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry earns its line by tracing to a real failure or repeated success.

## Patterns to reach for

_Approaches that work in this role, with the trigger that suggests reaching for each. Empty until earned._

## Anti-patterns

_Specific failure modes seen in this role, each tied to a real incident or repeated mistake. Empty until earned._

## Gotchas

- **Widening required params to `Optional` for runtime-validated mutual exclusion needs `assert ... is not None` afterwards.** When a parameter is `Optional[T] = None` and gets resolved to non-`None` via either a validation block (raising `ValueError`) or a derivation step (e.g. extracting `nodes`/`edges` from `graph`), `ty` cannot narrow the type across that control flow. Downstream calls that expect `T` (not `Optional[T]`) will fail type-check. Fix: add `assert nodes is not None` and `assert edges is not None` after the validation/derivation block. Matches the existing `assert sorting_variables is not None` pattern at `hiveplot_matrix.py:1288`. Triggered during Workstream I (consolidated NetworkX entry points).
