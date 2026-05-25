---
name: hiveplotlib-gallery-notebook
description: Create a new gallery example notebook for hiveplotlib (or revise one to match house style). Gallery notebooks are short, focused, reference-style demonstrations of a single feature, class, method, or visualization backend, e.g. "Setting a Partition Variable", "Add Data to Edges", "Bokeh", "Hive Plot Matrix: from_partition", "Changing Edge Keyword Arguments". Use this skill whenever the user wants to add a notebook to the docs gallery, document a new feature with an example notebook, or write a focused how-to for a hiveplotlib API. Trigger any time the user says things like "add a gallery example", "write an example notebook for X", "document the new Y method as a notebook", or asks about hiveplotlib's gallery conventions, even if they don't say the word "gallery" explicitly.
type: skill
---

# Hiveplotlib Gallery Example Notebook

Gallery notebooks are **reference-style demonstrations of one feature** — a class, method, parameter, or backend. Readers land here when they already know they need feature X and want to see how to use it. For longer narrative with motivation and revisited questions, use `hiveplotlib-tutorial-notebook`. Tutorials link from `docs/source/notebooks/index.rst`; gallery from `docs/source/gallery_examples/index.rst`. Section determines link target: HivePlot Class, NodeCollection Class, Edges Class, Visualization, HivePlotMatrix Class, Hive Plots from Different Data Sources.

## Gallery vs. tutorial

Pick gallery if documenting **one** feature/class/method/parameter, the question is "*how do I use X*" (not "*why is X useful*"), the title is a noun phrase (`# Setting a Partition Variable`, `# Bokeh`), or the notebook can lean on `hiveplotlib.datasets.example_*` rather than building data from scratch.

## File layout

Lives in `examples/`. Never edit `docs/source/notebooks/` copies — overwritten by `make docs`.

1. Create `examples/<snake_case_name>.ipynb` (`setting_partition_variable.ipynb`, `add_data_to_edges.ipynb`, `hpm_from_partition.ipynb`).
2. Register in `docs/source/gallery_examples/index.rst` in the right section, in both the `nblinkgallery` block and the hidden `toctree`, same order.
3. If the notebook needs optional extras, surface the install command up front (`pip install hiveplotlib[bokeh]`). See `examples/bokeh.ipynb`.

### Adding a brand-new gallery section header

Match existing section shape: H2 RST header (`Section Title` underlined with hyphens), optional one-line description, `nblinkgallery` block with `../notebooks/<name>` paths, hidden `toctree` with `:caption: Section Title` and `:hidden:`. Same notebooks in both, same order. Reference "Hive Plots from Different Data Sources" (around lines 125-140) as the minimal template.

Create a new section when (a) the new notebook introduces a coherent capability area not represented elsewhere, and (b) you can imagine a second or third notebook joining naturally. Don't create a section for a one-off.

### Lifting content from a tutorial into gallery

Not a copy-paste — voice differs structurally:

- Drop motivation / why-X paragraphs.
- Drop rhetorical questions.
- Re-cast narrative ("Let's see what happens if...") to instructional ("Below, we demonstrate...").
- Drop revisitation / reflection.
- **Move, don't duplicate.** Edit the source tutorial to remove the lifted content and replace with a one-line cross-reference.
- Tighten prose. Cut anything that doesn't directly explain what the next code cell does.

## Structure

### 1. Title (markdown, H1)

`# Title`. **H1, different from tutorials (H3).** Short noun phrase naming the feature. No "Introduction to" or "Quick Start" prefixes.

### 2. Lead-in

1-3 short paragraphs. **What** the notebook covers, not **why** hive plots are useful. Assume the reader knows what a hive plot is.

> Hive plots require a *partition variable* to dictate how the nodes should be split onto multiple axes. When instantiating a new `HivePlot` object, users must therefore provide a `partition_variable` corresponding to a column name in the provided node data. Users can also modify an existing `HivePlot`'s partition by calling the `HivePlot.set_partition()` method. This notebook demonstrates these two methods of setting the partition variable with the `HivePlot` class.

Cross-link freely to longer tutorials when the topic deserves more context.

If the notebook needs an optional extra, install command in a code block.

### 3. Imports (single code cell)

Alphabetical within `from` imports. Typical: `matplotlib.pyplot as plt`, `pandas as pd`, `numpy as np`, sometimes `seaborn as sns`, `flexitext`, `networkx as nx`.

### 4. Body: H2 sections

`## Section Title` for top-level, `### Subsection` for sub. Each section demonstrates one option. Order: default behavior → advanced.

Patterns:

- **Lean on `hiveplotlib.datasets`** so the notebook stays focused on the feature, not data plumbing.
- **Show both ways** when there are two ("set on instantiation" vs. "modify existing"; see `setting_partition_variable.ipynb`, `edge_kwarg_hierarchy.ipynb`).
- **Build incrementally.** If section 2 modifies section 1's plot, `.copy()` so sections are self-contained and reorderable.
- **`plt.show()`** at the end of each plotting cell. Don't `savefig`.

### 5. Closing pointer(s)

End with one or more "for more on X, see [other notebook]" links. Link to adjacent gallery pages and to longer tutorials when the topic has one.

**Prose paragraphs, not `## See Also` + bullets.** Canonical: one paragraph per pointer in the form `For more on X, see the [Y](Y.ipynb) page.` See `computing_graph_metrics.ipynb` and `exporting_hive_plots_to_networkx.ipynb`. A `## See Also` heading + bullets reads as reference-index genre.

**Exception:** topic-specific closing sections (e.g., `setting_partition_variable.ipynb` closes with `## Using Node Graph Metrics as Partition Variables`). Heading earns its place by naming a specific topic with its own depth.

**Link to the single best next-step notebook, not every subordinate reference.** Don't enumerate inline.

**Anchor links:** `[Section Name](other_notebook.ipynb#section-name-slug)` for landing in a specific section.

No tutorial-style "References" citations on gallery pages.

## Voice

Direct, instructional, first-person plural ("we will demonstrate", "below, we..."). No rhetorical questions, no moralizing about why hive plots are valuable.

*Italics* for terms-of-art on first appearance. Backticks for class names, methods, parameters.

When a parameter name collides with an English word (`graph`, `nodes`, `edges`, `backend`, `progress`), write "the `X` parameter" rather than bare `` `X` ``. The explicit "parameter" front-loads the disambiguation so the rest of the sentence reads cleanly. Pure-jargon names (`HivePlotMatrix`, `iter_populated_cells`) don't need this.

### Human voice

Read like Gary wrote it. No em-dashes. No AI filler ("delve", "moreover", "furthermore", "underscore", "in essence", "it's worth noting that", "let us consider", "as we can see"). No throat-clearing. Library helpers are tools, not characters — just use `flexitext`, `seaborn`, `numpy.random.default_rng`.

## Idioms

- **Line length 79** (`examples/ruff.toml`). Run `make format`.
- **`flexitext`** for color-coded titles (`quick_hive_plots.ipynb` canonical). Skip for gallery where plain `ax.set_title(...)` suffices.
- **`hp.copy()`** to start a fresh hive plot for a new section.
- **Custom exceptions** from `hiveplotlib.exceptions.*` when demonstrating error behavior.
- **Prefer pandas DataFrames** over numpy arrays.
- **Cross-references:** markdown links with relative paths (`[Visualizing Edge Metadata](visualizing_edge_metadata.ipynb)`), gallery sections via `../gallery_examples/index.rst#section-name`.

### Use the library; don't reinvent it

- **Derive a partition from a continuous variable:** `NodeCollection.create_partition_variable(...)`. Don't hand-roll `pd.cut` + merge.
- **Build from a `networkx` graph plus computed metrics:** prefer `HivePlot.from_networkx(..., node_graph_metrics=...)` where available over `networkx_to_nodes_edges()` + manual merge.
- **Per-group edge styling:** `update_edges(partition_id_1=..., partition_id_2=...)`. Don't loop.

A gallery page wrapping a feature in 10 lines of pandas plumbing teaches the wrong lesson.

### Figure-quality checks before shipping

- **Title overlap:** `set_title(..., y=1.05)` (or `1.1` multi-line).
- **Single-color or invisible nodes/edges:** check `vmin`/`vmax` against data range.
- **Highlight markers need legends:** a colored dot must be named via title or `flexitext`.

## Workflow

1. Confirm topic and section. Ask if unsure.
2. Pick a snake_case filename matching siblings.
3. Write following the skeleton. Use `hiveplotlib.datasets.example_*` where possible; keep custom data minimal.
4. Register in `docs/source/gallery_examples/index.rst` in both blocks, same order.
5. Run end-to-end (`make test-nb` or local kernel execution).

## Reference notebooks by section

- **The HivePlot Class** → `setting_partition_variable.ipynb`, `setting_sorting_variables.ipynb`, `rotation.ipynb`
- **The NodeCollection Class** → `add_data_to_nodecollection.ipynb`, `create_partition_variable.ipynb`
- **The Edges Class** → `add_data_to_edges.ipynb`, `multiple_tags_of_edge_data.ipynb`
- **Visualization** → `bokeh.ipynb`, `plotly.ipynb`, `matplotlib.ipynb` (each backend: kwargs, node metadata, edge metadata, hover, backend-specific notes)
- **The HivePlotMatrix Class** → `hpm_from_partition.ipynb`, `hpm_from_tags.ipynb`
- **Hive Plots from Different Data Sources** → `creating_hive_plots_from_pandas.ipynb`, `creating_hive_plots_from_networkx.ipynb`

Reading the closest neighbor before drafting is usually faster than working from this skill alone.
