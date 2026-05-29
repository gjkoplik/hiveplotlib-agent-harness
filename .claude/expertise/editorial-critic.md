# Expertise: Editorial Critic

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry traces to a real failure or repeated success and follows the entry shape (lead + body + anchor) in mental-model rule 11.

## Gotchas

- **A swap that fixes the axis count can hide a wrong-notebook problem.** When viz-critic flags "too many axes" on a class-scoped page and the fix swaps `HivePlot` for `HivePlotMatrix`, the count resolves but the page's primary subject may have quietly moved to another class. Cross-class content is often fine (HPM pages drill into a single hive plot; tutorials do both); the tell is the swap done to dodge the axis rule. *Learned:* networkx-metric-expansion Workstream E, a 4/6-community Louvain demo flipped to `HivePlotMatrix.from_partition` on the HivePlot-class `computing_graph_metrics` page.
