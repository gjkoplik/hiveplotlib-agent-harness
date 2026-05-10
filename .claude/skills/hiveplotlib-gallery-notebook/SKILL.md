---
name: hiveplotlib-gallery-notebook
description: Create a new gallery example notebook for hiveplotlib (or revise one to match house style). Gallery notebooks are short, focused, reference-style demonstrations of a single feature, class, method, or visualization backend, e.g. "Setting a Partition Variable", "Add Data to Edges", "Bokeh", "Hive Plot Matrix: from_partition", "Changing Edge Keyword Arguments". Use this skill whenever the user wants to add a notebook to the docs gallery, document a new feature with an example notebook, or write a focused how-to for a hiveplotlib API. Trigger any time the user says things like "add a gallery example", "write an example notebook for X", "document the new Y method as a notebook", or asks about hiveplotlib's gallery conventions, even if they don't say the word "gallery" explicitly.
type: skill
---

# Hiveplotlib Gallery Example Notebook

This skill produces gallery example notebooks that match hiveplotlib's existing house style. Gallery notebooks live alongside the longer-form tutorials but serve a different purpose: they are **reference-style demonstrations of one specific feature**, a class, a method, a parameter, or a visualization back end. A reader lands on them when they already know they need feature X and want to see how to use it.

If the user wants a **longer narrative tutorial** (motivation, real-world dataset, rhetorical questions, references section), use the `hiveplotlib-tutorial-notebook` skill instead. Tutorials are linked from `docs/source/notebooks/index.rst`; gallery pages are linked from `docs/source/gallery_examples/index.rst`. The gallery section it belongs to (HivePlot Class, NodeCollection Class, Edges Class, Visualization, HivePlotMatrix Class, Hive Plots from Different Data Sources) determines where the link goes.

## When to use this skill vs. the tutorial skill

Pick gallery if any of these are true:

- The notebook is documenting **one** feature, class, method, or parameter.
- The reader's question is "*how do I use X*" rather than "*what is hive plotting and why*".
- The natural title is a noun phrase naming the feature (e.g. `# Setting a Partition Variable`, `# Bokeh`).
- The notebook can lean on a `hiveplotlib.datasets.example_*` helper instead of building a dataset from scratch.

Pick tutorial if the notebook needs a real dataset, a "Why X?" motivation, or rhetorical questions that get revisited at the end.

## File layout and registration

A new gallery notebook lives in `examples/` (the canonical source; *do not* edit the copies in `docs/source/notebooks/`, those are overwritten on each docs build per [CLAUDE.md](../../../CLAUDE.md)).

1. Create `examples/<snake_case_name>.ipynb`. Keep the filename short, lowercase, descriptive, and matching the topic, e.g. `setting_partition_variable.ipynb`, `add_data_to_edges.ipynb`, `hpm_from_partition.ipynb`.
2. Add the notebook to the appropriate section of [docs/source/gallery_examples/index.rst](../../../docs/source/gallery_examples/index.rst). Each section has both an `.. nblinkgallery::` block (for the visual gallery thumbnails) **and** a hidden `.. toctree::` block; add the notebook to **both** in the same order.
3. If the notebook depends on optional extras (`bokeh`, `holoviews`, `plotly`, `datashader`), say so up front in the lead-in with the install command, e.g. `pip install hiveplotlib[bokeh]`. See `examples/bokeh.ipynb` for the exact phrasing.

### Adding a brand-new gallery section header

Sometimes the new notebook doesn't fit any existing section, and the right move is a new top-level section in `docs/source/gallery_examples/index.rst` rather than wedging it into an awkward neighbor. Match the exact shape of the existing sections: each section has an `H2`-level RST header (`Section Title` underlined with hyphens), an optional one-line description, an `.. nblinkgallery::` block listing the notebooks with `../notebooks/<name>` paths, and a hidden `.. toctree::` block with `:caption: Section Title` and `:hidden:` repeating the same list. Notebook entries appear in **both** blocks in the same order. Reference "Hive Plots from Different Data Sources" (around lines 125-140) as the canonical minimal section template.

Create a new section when (a) the new notebook(s) introduce a coherent capability area not represented elsewhere (e.g. exporting, integration with a graph library), and (b) you can imagine a second or third notebook naturally joining the section over time. Don't create a section for a single one-off notebook that fits an existing section.

### Lifting content from a tutorial into a gallery page

A tutorial subsection sometimes graduates into its own gallery page (because the underlying feature has matured enough to deserve standalone reference treatment). The lift is **not** a copy-paste; gallery voice differs structurally from tutorial voice. Specifically:

- **Drop motivation/why-X paragraphs.** Tutorials open with motivation; gallery pages open with "this notebook demonstrates X".
- **Drop rhetorical questions.** Gallery pages are reference material; readers are not in story mode.
- **Re-cast narrative prose into instructional prose.** "Let's see what happens if..." becomes "Below, we demonstrate...".
- **Drop revisitation/reflection sections.** No "let's revisit our questions from earlier".
- **Decide explicitly: move or duplicate.** If lifting, almost always *move*; leaving the same content in two places creates drift. Edit the source tutorial to remove the lifted content and replace with a one-line cross-reference to the new gallery page.
- **Tighten prose.** Tutorials are essays-with-code; gallery pages should be code-with-just-enough-prose. Cut anything that doesn't directly explain what the next code cell does.

## Notebook structure

Gallery notebooks follow a predictable skeleton. Stick to it; readers cross-reference between gallery pages and inconsistent structure makes that harder.

### 1. Title cell (markdown, H1)

Use a single H1 (`# Title`); note this is **different from tutorials, which use H3**. The title is a short noun phrase naming the feature being demonstrated. No "Introduction to" or "Quick Start" prefixes; those belong to tutorials.

Examples from the existing gallery: `# Setting a Partition Variable`, `# Add Data to Edges`, `# Bokeh`, `# Hive Plot Matrix: \`from_partition\``, `# Changing Edge Keyword Arguments`.

### 2. Lead-in (markdown, same cell or immediately after)

One to three short paragraphs. Describe **what the notebook covers**, not why hive plots are useful or background motivation. Assume the reader already knows what hive plots are.

Good lead-in shape:

> Hive plots require a *partition variable* to dictate how the nodes should be split onto multiple axes. When instantiating a new `HivePlot` object, users must therefore provide a `partition_variable` corresponding to a column name in the provided node data. Users can also modify an existing `HivePlot`'s partition by calling the `HivePlot.set_partition()` method. This notebook demonstrates these two methods of setting the partition variable with the `HivePlot` class.

Cross-link freely from the lead-in to longer-form tutorials when the topic deserves more context, e.g. `For a longer-form discussion motivating the use of these HPMs specifically, see the [Hive Plots for More Than Three Groups](hive_plots_more_than_three_groups.ipynb) page.`

If the notebook needs an optional extra (`bokeh`, etc.), call it out here with the install command in a code block.

### 3. Imports (single code cell)

One code cell, all imports at the top. Sort alphabetically within `from` imports. Typical companions: `matplotlib.pyplot as plt`, `pandas as pd`, `numpy as np`, sometimes `seaborn as sns`, `flexitext` (for in-figure color-coded titles), `networkx as nx` when the data setup needs it.

### 4. Body: H2 sections walking through the feature

Use `## Section Title` for top-level sections, `### Subsection` for subsections. Each section demonstrates one option, parameter, or sub-feature. Order from most common / default behavior to more advanced options.

Patterns that work well:

- **Lean on `hiveplotlib.datasets`** for the data setup so the notebook stays focused on the feature, not on data plumbing. `example_hive_plot()`, `example_node_collection()`, `example_hpm_nodes_and_edges()`, etc.
- **Show both ways** when there are two: e.g. "set this on instantiation" vs. "modify on an existing instance"; that's a common dual structure (see `setting_partition_variable.ipynb`, `edge_kwarg_hierarchy.ipynb`).
- **Build incrementally**. If section 2 modifies the plot from section 1, copy the base hive plot with `.copy()` so each section is self-contained and reorderable.
- **Use `plt.show()`** at the end of each plotting cell. Don't `savefig`; the notebook output is the figure.

### 5. Closing pointer(s)

End with one or more "for more on X, see [other notebook]" links. This is how readers navigate the gallery network. Link to:

- Other gallery pages that drill into adjacent options.
- Longer tutorials when the topic has one.

**Format the closing pointers as prose paragraphs, not as a `## See Also` heading with bulleted links.** The canonical shape is one paragraph per pointer in the form `For more on X, see the [Y](Y.ipynb) page.` separated by blank lines. See `computing_graph_metrics.ipynb` and `exporting_hive_plots_to_networkx.ipynb` for the canonical layout. A `## See Also` heading + bullet list reads as a different document genre (reference index) and breaks tone with the surrounding prose.

**Exception — topic-specific closing sections are fine.** The rule against generic `## See Also` + bullets is about the reference-index genre, not about all section headings. When a closing pointer introduces a distinct conceptual topic the reader might want to explore as its own subject (rather than just one of several adjacent options), it's appropriate to use a topic-specific `## Heading` followed by prose paragraphs. Examples done well: `setting_partition_variable.ipynb` closes with `## Using Node Graph Metrics as Partition Variables`, `setting_sorting_variables.ipynb` closes with `## Using Node Graph Metrics as Sorting Variables`. The heading earns its place by naming a specific topic with its own depth, not by being a catch-all bucket.

**Cross-link discipline: link to the single best "next step" notebook, not every subordinate reference.** When a topic has both a focused walkthrough notebook and several supporting references (an API table, a per-method walkthrough, a kwarg reference, a collision-handling example), pick the walkthrough and link to it alone. The reader who lands there finds the subordinate references organized in context. Enumerating each one inline ("see the [X Table](...), the [Y Method](...), and the [Z Walkthrough](...) for the supported keys, the post-hoc method, and the per-metric kwargs respectively") clutters the source notebook and adds nothing the destination notebook doesn't already give the reader.

**Linking to a specific section of another notebook:** use the Sphinx-auto-generated anchor `[Section Name](other_notebook.ipynb#section-name-slug)`, where the slug is the lowercased heading with spaces replaced by hyphens. Example: `[Using a Computed Metric as a Partition Variable](computing_graph_metrics.ipynb#using-a-computed-metric-as-a-partition-variable)`. Use anchored links when the destination notebook has multiple sections and the reader benefits from landing on the specific one (rather than scrolling from the top). Plain `[Notebook Title](notebook.ipynb)` links remain correct for "go read the whole thing" pointers.

Tutorial-style "References" sections (citations) do **not** belong on gallery pages.

## Voice and tone

Direct, instructional, first-person plural ("we will demonstrate", "below, we..."). Do not pose rhetorical questions and do not moralize about why hive plots are valuable; readers found this page because they already know.

Use *italics* for emphasizing terms-of-art the first time they appear (e.g. *partition variable*). Use backticks for class names, methods, parameters: `HivePlot`, `set_partition()`, `repeat_axes`.

### Human voice (and avoiding AI tells)

The notebooks should read like Gary wrote them, not like an AI did. Concrete rules:

- **No em-dashes.** Use commas, parentheses, semicolons, or just shorter sentences. This is the single biggest AI-tell to scrub.
- **No AI filler phrases.** Avoid "delve", "moreover", "furthermore", "underscore", "in essence", "it's worth noting that", "let us consider", "as we can see".
- **No throat-clearing.** "First, let's discuss the parameters" before discussing the parameters adds nothing. Just discuss them.
- **Library helpers are tools, not characters.** Use `flexitext`, `seaborn`, `numpy.random.default_rng`, etc. where they help. Do not introduce them with a paragraph explaining what they are.

## Idioms and conventions

- **Line length 79 in code cells** (per `examples/ruff.toml`). Wrap long calls; the notebooks are formatted with `make format`.
- **`flexitext`** is the standard way to embed color-coded legends inside titles. See `quick_hive_plots.ipynb` for the canonical use. Skip it for gallery pages where a plain `ax.set_title(...)` suffices.
- **`hp.copy()`** to start a fresh hive plot for a new section. Cheap and keeps sections independent.
- **Custom exceptions over generic ones** when demonstrating error behavior; the codebase has `hiveplotlib.exceptions.*` (see `edge_kwarg_hierarchy.ipynb` for an example of catching `InvalidEdgeKwargHierarchyError`).
- **Prefer `pandas` DataFrames** over numpy arrays in any data setup; the library is built around pandas.
- **Cross-references**: use markdown links with relative paths to other notebooks (`[Visualizing Edge Metadata](visualizing_edge_metadata.ipynb)`) and to gallery sections (`../gallery_examples/index.rst#the-hiveplotmatrix-class`). The first form renders correctly inside the docs build because of how Sphinx + nbsphinx resolve relative paths.

### Use the library; don't reinvent it

Gallery pages are reference material. They should showcase the right idiomatic API, not paper around it with manual data plumbing. Specifically:

- For **deriving a partition from a continuous variable**, use `NodeCollection.create_partition_variable(data_column=..., cutoffs=..., labels=...)`. Do not hand-roll `pd.cut` plus a manual column merge.
- For **building from a `networkx` graph plus computed metrics**, check whether the project's current API supports a single-call form (e.g. `HivePlot.from_networkx(..., node_graph_metrics=["degree"], ...)`). If yes, use that. The older idiom of `networkx_to_nodes_edges()` followed by `pd.DataFrame(G.degree, columns=...).merge(...)` still works, but new gallery pages should prefer the streamlined call where available. Read the current state of `src/hiveplotlib/converters.py` and `hiveplot.py` before deciding.
- For **per-group edge styling**, use `update_edges(partition_id_1=..., partition_id_2=..., ...)`. Do not loop over `edges.data` manually.

A gallery page that wraps a feature in 10 lines of pandas plumbing is teaching the wrong lesson. If you find yourself doing that, stop and find the library helper.

### Figure-quality checks before shipping

Gallery pages are the rendered face of the docs, so each figure should not have obvious quality issues:

- **Title overlap.** When using `ax.set_title(...)` on a hive plot, the default position often clips into the top of the plot. Use `y=1.05` (or `1.1` if the title has multiple lines) on `set_title`. The existing notebooks do this routinely.
- **Single-color or invisible nodes/edges.** If demonstrating a feature that adds color or styling, the figure should actually show the change. Check that the chosen `vmin`/`vmax` and the data range produce visible variation.
- **Highlight markers without legends.** If you scatter a single point on top of the hive plot to draw attention to it (e.g. the Mr. Hi node in `karate_club.ipynb`), name the point in the title or with `flexitext` so the reader knows what the dot represents. A random colored dot with no caption is worse than no dot.

## Workflow when creating a new gallery notebook

1. **Confirm the topic and section.** Which gallery section in `docs/source/gallery_examples/index.rst` does this belong to? If unsure, ask the user.
2. **Pick a snake_case filename** matching existing siblings.
3. **Write the notebook** following the skeleton above. If you can use a `hiveplotlib.datasets.example_*` helper, do; if the feature genuinely needs custom data, keep the setup minimal and don't narrate it like a tutorial.
4. **Register the notebook in `docs/source/gallery_examples/index.rst`** in the right section, in *both* the `nblinkgallery` block and the hidden `toctree` block.
5. **Run it end-to-end** before reporting done. `make test-nb` is the official check, but for a quick local verification execute the notebook in the `hiveplotlib` jupyter kernel and confirm no errors.

## Example skeletons by gallery section

When the user picks a section, pattern-match to the closest existing notebook(s) in that section:

- **The HivePlot Class** → `setting_partition_variable.ipynb`, `setting_sorting_variables.ipynb`, `rotation.ipynb`
- **The NodeCollection Class** → `add_data_to_nodecollection.ipynb`, `create_partition_variable.ipynb`
- **The Edges Class** → `add_data_to_edges.ipynb`, `multiple_tags_of_edge_data.ipynb`
- **Visualization** → `bokeh.ipynb`, `plotly.ipynb`, `matplotlib.ipynb` (each backend follows the same beats: kwargs, node metadata, edge metadata, hover, backend-specific notes)
- **The HivePlotMatrix Class** → `hpm_from_partition.ipynb`, `hpm_from_tags.ipynb`
- **Hive Plots from Different Data Sources** → `creating_hive_plots_from_pandas.ipynb`, `creating_hive_plots_from_networkx.ipynb`

Reading the closest neighbor before drafting is usually faster than working from this skill alone.
