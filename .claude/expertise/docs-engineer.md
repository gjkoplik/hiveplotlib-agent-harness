# Expertise: Docs Engineer

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry earns its line by tracing to a real failure or repeated success, and follows the entry shape (lead + body + anchor) and stays lean (soft target ~60-90 words) per mental-model rule 11.

## Patterns to reach for

_Approaches that work in this role, with the trigger that suggests reaching for each. Empty until earned._

## Anti-patterns

_Specific failure modes seen in this role, each tied to a real incident or repeated mistake._

### Subtractive summary-line edits when broadening a capability

When a workstream adds a new dimension to an existing class or function (new input shape, new backend, new factory mode), it's tempting to rewrite the summary around the new thing and prune the original required-content language by reflex. The summary line is what Sphinx autodoc, `help()`, IDE hover, and `pydoc` surface; if it drops the required-content axis, a cold reader doesn't learn what the constructor demands.

**Real incident.** On hiveplotlib's networkx-streamlining branch, the `HivePlot` summary was rewritten from

> Hive plot instantiation from nodes, edges, a provided partition variable, and sorting variable(s).

to

> Hive plot instantiation from either tabular data (``(nodes, edges)``) or a ``networkx`` graph.

The new line captured the new input-shape axis but silently dropped the partition / sorting axis — the conceptual heart of what a `HivePlot` actually requires.

**How to apply.** The new summary line must be a conceptual *superset* of the old line's required-content axes, not a swap. If everything won't fit in 120 chars, compress wording (`tabular or networkx` beats `as either tabular data or a networkx graph`) rather than dropping an axis.

### Developer-facing meta-commentary leaking into user docstrings

Docstrings are user-facing (Sphinx autodoc, `help()`, IDE hover, `pydoc`). They're not the place for developer-facing meta-commentary: naming justifications, "this is cosmetic not semantic" framing, "internally this calls X", deprecation rationale, taxonomy quibbles. That content belongs in code comments, commit messages, PR descriptions, or ADRs.

**Real incident.** The `HivePlot` docstring carried a lead-section note:

> ``graph`` (the input graph) is distinct from ``graph_directed`` / ``graph_multigraph`` / ``graph_source_attribute_name`` (the internal-graph configuration knobs used when computing graph metrics). The shared ``graph_`` prefix is cosmetic, not semantic.

The first half is borderline (it disambiguates parameters, already covered in the `:param graph:` description). The second sentence is pure meta-commentary defending the naming choice. A user learns nothing actionable; they learn the maintainers know the names are confusing. If they're confusing enough to need that disclaimer, the fix is renaming, not annotating.

**How to apply.** Audience-check each sentence: *would a user attempting a task benefit from this, or is it only meaningful to someone reasoning about the API as an artifact?* Tells that you've slipped into developer voice:
- The sentence describes the API's naming, structure, or design choice rather than what it does.
- Meta-vocabulary like "cosmetic", "semantic", "technically", "for historical reasons", "intentionally".
- Defends or apologizes for a choice ("this is named X because Y", "this is technically a Z but presents as W").
- Removing the sentence wouldn't make any user-task harder.

If the underlying friction is real (a naming collision that genuinely confuses users), the fix is upstream (rename the parameter) or in a `:param:` line that does real disambiguation, not a lead-section apology.

## Gotchas

_Surprises not obvious from reading the code, docs, or other agents' definitions. Empty until earned._
