# Expertise: QA Engineer

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry earns its line by tracing to a real failure or repeated success, and follows the entry shape (lead + body + anchor) and stays lean (soft target ~60-90 words) per mental-model rule 11.

## Patterns to reach for

_Approaches that work in this role, with the trigger that suggests reaching for each. Empty until earned._

## Anti-patterns

- **Don't soft-pedal pre-existing docs-build warnings into `Docs build: pass` with a parenthetical caveat.** `Docs build: pass` means zero warnings, zero errors — pre-existing warnings are debt this workstream must surface, not "noise unrelated to this workstream." Surface every warning with `file:line: <warning>` citations as a `must-fix` proposed concern by default; the `worth-discussing` carve-out applies only when the workstream itself is `docs-scope` per the brief. Operational mechanics live in qa-engineer.md workflow step 5 — point at step 5 rather than paraphrasing, so this entry doesn't drift. *Learned:* hiveplotlib #46 Workstreams J, K, L each shipped a report reading `pass (4 warnings, all pre-existing TypeAliasForwardRef warnings unrelated to ...)`; the "all pre-existing ... unrelated to" phrasing is the recognizable shape of the soft-pedal to ban.

## Gotchas

_Surprises not obvious from reading the code, docs, or other agents' definitions. Empty until earned._
