# Expertise: Docs Engineer

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry comes from a real failure or repeated success (not invented advice), follows the entry shape (lead + body, no originating-plan citation), and stays lean (soft target ~60-90 words) per mental-model rule 11.

## Patterns to reach for

_Approaches that work in this role, with the trigger that suggests reaching for each._

### Interaction between parameters goes in a `.. note::`, not in each `:param:`

Trigger: the same behavioral model appears in two or more parameter descriptions, or a `:param:` runs past roughly six lines describing what happens when *another* parameter is also set. Replicating it means every future correction has to land in N places and they drift.

**Real incident.** Two datashader render functions each described the `num_steps` / `construct_curves_kwargs` curve-geometry model across three parameter descriptions, so one model was stated in six places. The fix: one dedicated `.. note::` per function carrying the interaction, with each `:param:` cut back to what a reference lookup wants (what the value is, its default) plus a pointer to the note.

**How to apply.** Split on audience need: `:param:` answers "what do I pass here", the note answers "what happens when these combine". Give the interaction its own note rather than appending to an existing one, which turns that note into a grab-bag. A pointer often reads better than a bare deletion in the params you trim.

## Anti-patterns

_Specific failure modes seen in this role, each tied to a real incident or repeated mistake._

### Subtractive edits that answer an objection by deleting the point

When a workstream adds a new dimension to an existing class or function (new input shape, new backend, new factory mode), it's tempting to rewrite the summary around the new thing and prune the original required-content language by reflex. The summary line is what Sphinx autodoc, `help()`, IDE hover, and `pydoc` surface; if it drops the required-content axis, a cold reader doesn't learn what the constructor demands.

**Real incident.** On hiveplotlib's networkx-streamlining branch, the `HivePlot` summary was rewritten from

> Hive plot instantiation from nodes, edges, a provided partition variable, and sorting variable(s).

to

> Hive plot instantiation from either tabular data (``(nodes, edges)``) or a ``networkx`` graph.

The new line captured the new input-shape axis but silently dropped the partition / sorting axis, the conceptual heart of what a `HivePlot` actually requires.

**Second incident, same shape at note level (2026-08-20).** QA objected that `construct_curves`'s note implied geometry a non-persisting `build_hive_plot` never produces. The note was rewritten by removing its persistence framing, which was the whole reason it existed: thirteen notebooks and every "if you need the curves, call this" pointer land a reader there. The maintainer caught it ("what was written there was the whole point, and you took out the key thing"). The correct fix was narrow, since the flaw was in a subordinate contrast clause, not in the framing.

**How to apply.** Name what the text was for before you change it. A new summary line must be a conceptual *superset* of the old line's required-content axes, not a swap; if everything won't fit in 120 chars, compress wording (`tabular or networkx` beats `as either tabular data or a networkx graph`) rather than dropping an axis. When a critic offers two remedies, take the one that keeps the purpose and fixes the flaw, not the one that makes the objection disappear.

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

### Guide and troubleshooting prose inside `:param:` descriptions

A parameter description carries what the value does and what a caller cannot infer. Project status, issue links, hardware caveats, logging recipes, and internal routing mechanism are guide material; they belong in a notebook or a narrative doc page.

**Real incident.** `compute_graph_metrics`'s `graph_metric_backend` param ran fourteen lines carrying CI testing status, a GPU note, a file-an-issue link, and a `logging.basicConfig` recipe. The maintainer flagged it as "conversation for the notebook, not for a parameter description." Its neighbor `node_metric_kwargs` spent most of its words on where the `"backend"` key gets popped and which internal path it shares. Both trimmed, the backend param from fourteen lines to five.

**How to apply.** Keep only what a caller setting this param cannot infer: the default, version floors, registered-name-vs-package-name traps, fallback behavior, opt-out sentinels. Cut mechanism ("popped here and routed through"), project status, and how-to. If a fact is already carried by a `:raises:` entry, it does not need restating in the param.

## Gotchas

_Surprises not obvious from reading the code, docs, or other agents' definitions. Empty until earned._

### A `:param:` naming a parameter the signature doesn't have is silent; only an AST diff finds it

Sphinx renders the phantom parameter, omits the real one, and warns about neither, so a zero-warning build says
nothing about docstring/signature agreement. Detect it with a throwaway AST script diffing `:param X:` names against
each signature across `src/`. Merge the class docstring into `__init__`'s param set first, or every constructor in a
project that documents its parameters on the class reports as undocumented and buries the real hits.

**Real incident.** `HivePlot.update_edges` documented `:param axis_id_2:` for a parameter named `partition_id_2`
across releases. The same sweep found two more public-surface hits: a `sorting_variable` / `sorting_variables` drift,
and a copy-pasted `:param p2cp:` on holoviews' `p2cp_legend`, whose signature never had it (the cross-backend
copy-paste also left "``plotly`` figure" in a holoviews param). Grep the wrong backend's name inside each backend
module to catch that second class cheaply.

### An unresolvable `:py:meth:` often means the target's page never listed it, not that the ref is wrong

An autodoc page that lists members with explicit `.. automethod::` directives drifts silently: a new public method
renders nowhere, and nothing warns, because nothing asked for it. The tell shows up sideways, as a source pass
reporting it fell back to bare ``literals()`` to dodge `ref.meth` warnings under sphinx's `-n` nitpicky flag.

**Real incident.** `HivePlotMatrix.unify_axes` shipped in 0.27.0 and was still absent from the API reference two
releases later, while its own docstring, three builder docstrings, `llms-full.txt`, and two notebooks all pointed at
it. The gap surfaced only because a later workstream tried to cross-reference it and hit four unresolvable refs.

**How to apply.** Read an unresolvable ref as a question about the *target's* page. Then audit the whole page, not
just the one entry: diff the class's public members (`vars(cls)`, minus underscore-prefixed) against the rst, and
check each apparent gap against sibling pages before calling it drift (a dunder absent everywhere is a convention,
not a miss).
