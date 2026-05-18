# Expertise: Docs Engineer

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry earns its line by tracing to a real failure or repeated success.

## Patterns to reach for

_Approaches that work in this role, with the trigger that suggests reaching for each. Empty until earned._

## Anti-patterns

_Specific failure modes seen in this role, each tied to a real incident or repeated mistake._

### Subtractive summary-line edits when broadening a capability

When a workstream adds a new dimension to an existing class or function (a new input shape, a new backend, a new factory mode), it is tempting to rewrite the summary line around the new thing. The cognitive load is on the new capability, so the original required-content language gets pruned by reflex to make room. The result is a summary that describes what is *new* but no longer describes what is *required*.

The first sentence of a docstring is what Sphinx autodoc, `help()`, IDE hover, and `pydoc` surface. Body paragraphs are not read first. If the summary line drops the required-content axis, a cold reader does not learn what the constructor demands.

**Real incident.** On hiveplotlib's networkx-streamlining branch, the `HivePlot` summary was rewritten from

> Hive plot instantiation from nodes, edges, a provided partition variable, and sorting variable(s).

to

> Hive plot instantiation from either tabular data (``(nodes, edges)``) or a ``networkx`` graph.

The new line captured the new input-shape axis but silently dropped the partition / sorting axis — the conceptual heart of what a `HivePlot` actually requires. Body paragraphs still mentioned them; the lead sentence no longer did. Gary flagged it post-merge.

**How to apply.** When you touch a class- or function-level summary line, diff old vs. new in your head before saving. The new line must be a conceptual *superset* of the old line's required-content axes, not a swap. If everything won't fit in 120 chars, compress wording (`tabular or networkx` beats `as either tabular data or a networkx graph`) rather than dropping an axis. Body paragraphs can carry the new capability's detail; the summary keeps the original required-content language alongside the new dimension.

### Developer-facing meta-commentary leaking into user docstrings

Docstrings are user-facing. They appear in Sphinx autodoc, `help()`, IDE hover, and `pydoc` — read by people trying to use the library. They are not the place for developer-facing meta-commentary about the API as an artifact: naming justifications, "this is cosmetic not semantic" framing, "internally this calls X", "we chose A over B because C", deprecation rationale, taxonomy quibbles. That content belongs in code comments, commit messages, PR descriptions, or ADRs — wherever the audience is another developer reasoning about the design.

**Real incident.** The `HivePlot` docstring carried a lead-section note:

> ``graph`` (the input graph) is distinct from ``graph_directed`` / ``graph_multigraph`` / ``graph_source_attribute_name`` (the internal-graph configuration knobs used when computing graph metrics). The shared ``graph_`` prefix is cosmetic, not semantic.

The first half is borderline (it disambiguates parameters, and is already covered in the `:param graph:` description). The second sentence — "the shared `graph_` prefix is cosmetic, not semantic" — is pure meta-commentary defending the naming choice. A user reading this learns nothing actionable; they learn that the maintainers know the names are confusing. If the names are confusing enough to need that disclaimer, the fix is renaming, not annotating. Gary flagged the note as code-style content that landed in a docs-style place.

**How to apply.** Before saving a docstring edit, run the audience check on each sentence: *would a user attempting a task benefit from this, or is it only meaningful to someone reasoning about the API as an artifact?* Common tells that you've slipped into developer voice:
- The sentence describes the API's naming, structure, or design choice rather than what it does.
- It uses meta-vocabulary like "cosmetic", "semantic", "technically", "for historical reasons", "intentionally".
- It defends or apologizes for a choice ("this is named X because Y", "this is technically a Z but presents as W").
- Removing the sentence would not make any user-task harder.

When you see this pattern in existing docstrings, drop it (or surface to Gary for confirmation if the call is non-obvious). When writing new docstrings, do not introduce it. If the underlying friction is real — e.g., a naming collision that genuinely confuses users — the right fix is usually upstream (rename the parameter) or in a `:param:` line that does real disambiguation work, not a lead-section apology.

## Gotchas

_Surprises not obvious from reading the code, docs, or other agents' definitions. Empty until earned._
