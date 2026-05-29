# Expertise: Editorial Critic

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry earns its line by tracing to a real failure or repeated success, and follows the entry shape (lead + body + anchor) and stays lean (soft target ~60-90 words) per mental-model rule 11.

## Patterns to reach for

_Approaches that work in this role, with the trigger that suggests reaching for each. Empty until earned._

## Anti-patterns

_Specific failure modes seen in this role, each tied to a real incident or repeated mistake. Empty until earned._

## Gotchas

- **A swap that fixes the axis count can hide a wrong-notebook problem.** When viz-critic flags "too many axes" on a class-scoped page and the fix swaps `HivePlot` for `HivePlotMatrix`, the count resolves but the page's primary subject may have quietly moved to another class. Cross-class content is often fine (HPM pages drill into a single hive plot; tutorials do both); the tell is the swap done to dodge the axis rule. *Learned:* networkx-metric-expansion Workstream E, a 4/6-community Louvain demo flipped to `HivePlotMatrix.from_partition` on the HivePlot-class `computing_graph_metrics` page.
