# Expertise: QA Engineer

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry earns its line by tracing to a real failure or repeated success.

## Patterns to reach for

_Approaches that work in this role, with the trigger that suggests reaching for each. Empty until earned._

## Anti-patterns

- **Soft-pedalling pre-existing docs-build warnings into `Docs build: pass` with a parenthetical caveat.** When `make docs` produces warnings the current workstream didn't introduce, the reach-for shape is to write `Docs build: pass (N warnings, all pre-existing ...)` and demote the residual to a `low-confidence` "future hygiene" proposed concern. That shape is the bug. `Docs build: pass` means zero warnings, zero errors. Pre-existing warnings are debt the current workstream must surface, not "noise unrelated to this workstream." Surface every warning with `file:line: <warning>` citations as a `must-fix` proposed concern by default; the `worth-discussing` carve-out applies only when the workstream itself is `docs-scope` per the brief (qa-engineer.md workflow step 5 has the operational mechanics and the carve-out definition). Don't paraphrase the rule here; point at step 5 and let it own the operational language so this entry doesn't drift out of sync. *Learned:* hiveplotlib GitLab #46 Workstreams J, K, and L this session each shipped a qa-engineer report whose `Docs build:` line read literal variations of `pass (4 warnings, all pre-existing TypeAliasForwardRef warnings unrelated to ...)`. The phrase `"all pre-existing TypeAliasForwardRef warnings unrelated to..."` is the recognizable shape of the soft-pedal to ban: it sounds like reassurance ("not my fault, not my problem") but it lets accumulated debt register as `pass` and slip past the release-readiness gate. The harness now treats docs warnings as must-fix by default with the docs-scope carve-out keyed on the workstream brief (not on the dispatched specialist).

## Gotchas

_Surprises not obvious from reading the code, docs, or other agents' definitions. Empty until earned._
