# Expertise: Research Liaison

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry comes from a real failure or repeated success (not invented advice), follows the entry shape (lead + body, no originating-plan citation), and stays lean (soft target ~60-90 words) per mental-model rule 11.

## Patterns to reach for

_Approaches that work in this role, with the trigger that suggests reaching for each. Empty until earned._

## Anti-patterns

- **Hold the `wiki/log.md` chronological append until the work is genuinely closed, not just qa-green on a subset.** The post-task trigger is "after qa reports pass," but qa-green isn't done: a plan with a workstream still gated, nothing committed, and the maintainer mid-review means a dated log entry reads as premature. In a 2026-06 post-task pass the `hiveplotlib.md` entity-page update was fine, but the appended `log.md` entry drew "I don't want or need a log entry right now... this feels out of place with how we've been logging," and it was pulled back out. When workstreams remain gated or nothing is committed, do the entity-page update if asked but treat the chronological `log.md` append as opt-in (confirm first, or skip).

## Gotchas

- **Plan prose mixes shipped and planned facts; verify before importing into curated pages.** A plan's naming audit stated "the codebase now carries three backend senses," but one sense (narwhals dataframe dispatch) was a settled decision in an in-flight sibling plan, not shipped code; a grep of `src/` caught it before the claim landed on a concept page (2026-06-11 post-task pass). Plans speak in design-time present tense. Before copying a cross-plan claim into wiki pages, check the referenced code exists, and tag triangle/inventory entries with shipped vs. settled-but-in-flight.
