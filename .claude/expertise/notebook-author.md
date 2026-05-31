# Expertise: Notebook Author

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry comes from a real failure or repeated success (not invented advice), follows the entry shape (lead + body, no originating-plan citation), and stays lean (soft target ~60-90 words) per mental-model rule 11.

## Patterns to reach for

_Approaches that work in this role, with the trigger that suggests reaching for each._

- **When a workstream consolidates two API surfaces into one, re-sweep prose in the same pass as the call sites.** Dual-shape framing ("available both when X and Y", "regardless of whether you pass A or B", "If you are starting from a Z rather than a W...") earns its keep only during the dual-surface period; after consolidation it's dead weight, so pick one canonical form per cell and let the API docs handle cross-shape documentation. It slips back in because the easiest local edit during a call-site flip is to swap the API call and keep the surrounding prose scaffolding. Trigger: any consolidation workstream; don't wait for a user to flag it.
- **When the plan's framing of an algorithm's behavior is approximately-but-not-exactly right, bend the prose to match the API behavior, not the API call to match the prose.** Two responses to a mismatch: (a) fudge a kwarg (e.g. `resolution=0.5` to force the plan's promised 2-community story) or (b) keep defaults and recast the markdown around what the algorithm actually produces. Pick (b): default-`resolution` Louvain finds 4 communities on Karate Club (not 2, though each lives mostly within one club), and the cell's pedagogical point ("integer labels go directly into `partition_variable`") survives the honest 4-community story as well as a tidy 2-community one. Only halt under rule 9 if the actual behavior defeats the pedagogical point.

## Anti-patterns

_Specific failure modes seen in this role, each tied to a real incident or repeated mistake. Empty until earned._

## Gotchas

_Surprises not obvious from reading the code, docs, or other agents' definitions._

- **`HivePlotMatrix` doesn't expose `.nodes` / `.edges` at the top level; reach for them through any populated cell.** Every cell carries the same underlying `NodeCollection` and `Edges` (partition slicing happens per-cell at plot time, not at storage time), so when swapping `HivePlot` → `HivePlotMatrix.from_partition`, grep surrounding cells for `<varname>.nodes.data` / `<varname>.edges.data` and reroute each through an arbitrary populated cell (e.g. `hpm[0, 0]`, the canonical diagonal). Add a one-line "every cell carries the same underlying nodes" comment so the reader isn't lost in the indirection. Trigger: any HPM swap with surrounding cells inspecting the source data.
- **A constructive `HivePlot` demo that sorts an axis by a non-numeric column breaks at construction, but the failure hides behind any sibling error-demo that raises first.** Axis sorting coerces the sort variable to float, so `sorting_variables="<string col>"` (e.g. Karate Club's `club`, values `'Mr. Hi'`/`'Officer'`) throws `could not convert string to float` the moment a plot actually builds. `try/except` break-case cells using the same string sort run clean because their `ValueError` (a bad-kwarg or graph-type conflict) fires before sorting is reached, so copying their kwargs into a cell that is *meant to succeed* silently inherits the landmine. Sort the constructive cell by a numeric column on the raw nodes, preferring a metric the cell already computes (e.g. `in_degree`) over `unique_id` when the notebook is metrics-themed, so the axis stays on-topic. Verified examples in a plan may only ever raise, so they won't have exercised this; the trigger is any new cell that constructs and renders/augments rather than catching an error.
