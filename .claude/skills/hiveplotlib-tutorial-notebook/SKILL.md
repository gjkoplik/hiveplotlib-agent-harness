---
name: hiveplotlib-tutorial-notebook
description: Create a new tutorial notebook for hiveplotlib (or revise one to match house style). Tutorial notebooks are longer-form, narrative-driven explorations with motivation, a story or dataset, rhetorical questions that get revisited, and (for real-data tutorials) a References section with citations, e.g. "An Introduction to Hive Plots", "Quick Start Hive Plots", "Zachary's Karate Club", "Comparing Network Subgroups", "An Introduction to P2CPs". Use this skill whenever the user wants to add a tutorial, write up a real-dataset example, build a long-form explainer notebook, or document a new high-level concept like a new HivePlotMatrix variant or a new P2CP capability. Trigger when the user says things like "write a tutorial for X", "add a new long-form example", "do a writeup of dataset Y as a hive plot", or anything that calls for the storytelling/motivational mode rather than a feature reference.
type: skill
---

# Hiveplotlib Tutorial Notebook

Tutorials are the **storytelling layer**: motivation, real or contrived dataset, rhetorical questions revisited, build a visualization, reflect on what it shows. Readers come for "what is this concept and when do I use it." For a short feature reference, use `hiveplotlib-gallery-notebook` instead. Tutorials link from `docs/source/notebooks/index.rst`; gallery from `docs/source/gallery_examples/index.rst`.

## Tutorial vs. gallery

Pick tutorial if the notebook needs a "why this technique?" motivation, walks a real or purpose-built dataset, has a sentence-y title (`### An Introduction to Hive Plots`, `### Quick Start Hive Plots`, `### Zachary's Karate Club`), or poses rhetorical questions revisited at the end. Pick gallery for focused "how do I use feature X" reference.

## Subtypes

1. **Concept introductions** (`introduction_to_hive_plots.ipynb`, `introduction_to_p2cps.ipynb`) — heavy motivation, compare against alternatives, synthetic data inline. Title: `### An Introduction to ...`.
2. **Quick starts** (`quick_hive_plots.ipynb`) — practical workflow end-to-end with a contrived dataset. Title: `### Quick Start ...`.
3. **Real-data examples** (`karate_club.ipynb`, `bitcoin_user_ratings.ipynb`, `election_96.ipynb`) — Background section explaining provenance, References section at the end. Title: noun phrase naming the dataset.
4. **Conceptual deep-dives** (`comparing_network_subgroups.ipynb`, `hive_plots_for_large_networks.ipynb`, `hive_plot_matrices.ipynb`) — one big idea with multiple variants. Title: noun phrase naming the concept.

## File layout

Lives in `examples/`. Never edit `docs/source/notebooks/` copies — overwritten by `make docs`.

1. Create `examples/<snake_case_name>.ipynb`.
2. Register in `docs/source/notebooks/index.rst` in the right section (**Hive Plots**, **Hive Plot Examples**, **Polar Parallel Coordinates Plots**, **P2CP Examples**). Each section has both an `nblinkgallery` block AND a hidden `toctree`; register in both in the same order.
3. If the notebook needs optional extras (`bokeh`, `holoviews`, `plotly`, `datashader`), surface the install command up front (`pip install hiveplotlib[datashader]`). See `comparing_network_subgroups.ipynb` for the phrasing.

## Structure

### 1. Title (markdown, H3)

`### Title`. **H3, not H1** — unusual but established. Subsections `####`.

### 2. Imports (single code cell)

`matplotlib.pyplot as plt`, `networkx as nx`, `pandas as pd`, `numpy as np`, `seaborn as sns`, `flexitext` for in-figure color-coded titles, `matplotlib.lines.Line2D` for custom legend handles.

### 3. Motivation / Background (H4)

- **Concept intros:** `#### Motivation: Why X?` walking the problem the technique solves. Compare against alternatives the reader already knows (hairball, circular, 2D-of-3D scatter).
- **Real-data:** `#### Background` on dataset history, who collected it, what nodes/edges represent. See Karate Club and 1996 election notebook.
- **Quick starts and deep-dives:** skip heavy motivation; one-paragraph framing then data setup.

### 4. Data setup

Tutorials usually don't lean on `hiveplotlib.datasets.example_*` (that's gallery territory). Instead build a **purpose-built synthetic dataset** that supports the narrative (stochastic block models with tuned probabilities, contrived employee-seniority data, Gaussian blobs at cube corners), or **load a real dataset** via `networkx`, `hiveplotlib.datasets`, or a CSV.

Stay on the dataset you set up here; if a later section genuinely needs another, say why and keep the lead-in honest.

State the relationships in plain English before the visualization. Reader needs to know what to look for. From `quick_hive_plots.ipynb`:

> Above, we have generated 3 cliques of equal size (10 per clique) with the following properties:
> - Within-group communication is only 10% (`0.1` on the diagonal).
> - Group 1 is very social with Groups 2 and 3 (`0.5`)...

### 5. Pose questions, then visualize

Ask the reader to predict what they'll see. Examples:

- "*How socially separated are the two factions?*" (Karate Club)
- "*To what extent can we visualize these relationships with standard graph layouts as well as Hive Plots?*" (Intro)
- "*What if we want to compare multiple subgroups embedded in 1 network?*" (Comparing Subgroups)

Then build up incrementally:

1. Show the alternative visualization the reader probably knows for this kind of data, and explain its limits. **Pick the canonical alternative for the dataset, not just whatever is easiest.** Karate Club has a circular layout in the 1977 paper; Les Misérables is force-directed; a protein interaction network is a heatmap or 3D scatter. Don't default to circular. Skip the comparison if there's no obvious standard.
2. Build a baseline hive plot. Note what it does and doesn't show.
3. Add features (repeat axes, edge kwargs, sorting) one at a time, markdown between explaining the change.
4. Embed legend/story in the title via `flexitext` for the final figure (`karate_club.ipynb` closing visualization is canonical).

### Partition design: stay on 2 or 3 axes

A 4-axis hive plot is a bug. When deriving a partition for a dataset with no built-in groups (Les Misérables, Florentine Families, arbitrary `networkx`):

- **Bad:** run community detection, get 5 communities, stuff the 2 smallest into `Other`. Edges to `Other` collapse meaningful structure into noise.
- **Better:** pick a binary or ternary cut with substantive meaning (Medici-vs-rest, low/medium/high, observed-faction-A vs -B). The reader should be able to name it.
- **When 4+ groups all matter:** use `HivePlotMatrix.from_partition` for small multiples. The tutorial is then about the HPM.

If community detection is part of the narrative (Les Misérables is fair), still resolve to 2 or 3 axes for the final figure — either pick the 3 largest and drop the rest (with a sentence), or recombine into 2-3 named groups by hand.

### 6. Reflect on the visualization

Revisit the questions from section 5. Tutorials feel complete when they close the loop. Karate Club:

> Let's revisit our questions from earlier:
> > _How socially separated are the two factions?_...
> From this figure, there appear to be far more intra-faction connections than inter-faction connections...

### 7. References (real-data only)

`#### References` listing citations:

> Zachary W. (1977). An information flow model for conflict and fission in small groups. *Journal of Anthropological Research*, 33, 452-473.

Synthetic-data tutorials usually skip; may include "Further reading" pointers.

## Voice and tone

Tutorials read top-to-bottom but aren't essays. Prose explains the visualization; cut anything not doing that work.

- **Rhetorical questions** sparingly. One at start, one revisited at end. Don't stack throughout.
- **First-person plural** ("we will", "let's").
- **Plain-English framing** of every code block, 1-2 sentences. Reader should follow the story without running the code, without needing three paragraphs per cell.
- *Italics* for terms-of-art on first appearance (*hive plot*, *repeat axes*, *partition*).
- Backticks for class names, methods, parameters.
- When a parameter name collides with an English word (`graph`, `nodes`, `edges`, `backend`, `progress`), write "the `X` parameter" rather than bare `` `X` ``. The explicit "parameter" front-loads the disambiguation so the rest of the sentence reads cleanly. Pure-jargon names (`HivePlotMatrix`, `iter_populated_cells`) don't need this.

### Length discipline

A tutorial much longer than its closest sibling is too long. Tells you've over-written:

- More than 1-2 sentences of preamble before a code cell.
- A "Why bin?" abstract section alongside the visualization that already answers it — cut the section.
- Meta-discussion of which tools you're using ("we will use `flexitext` to embed legends" — just use it).
- Multiple paragraphs reflecting on a single figure. One is plenty.

If you're above 2x the closest existing notebook's word count for comparable scope, cut.

### Human voice

Read like the maintainer wrote it. No em-dashes. No AI filler ("delve", "moreover", "furthermore", "underscore", "in essence", "it's worth noting that", "let us consider", "as we can see"). No throat-clearing ("First, let's discuss" — just discuss). No hedging ("It is important to note that X" → "X"). Direct, slightly informal — "Let's look at what happens when we sort by degree" beats "We shall now examine the consequences." Calibrate against `karate_club.ipynb` and `comparing_network_subgroups.ipynb`. Avoid heavy bullet lists in the body; save them for dataset properties or wrap-up takeaways.

## Idioms

- **H3 title, H4 subsections.** Gallery uses H1/H2; tutorials use H3/H4. Don't mix.
- **Line length 79 in code cells** (`examples/ruff.toml`). Run `make format` before committing.
- **`flexitext`** for color-coded narrative titles (`quick_hive_plots.ipynb`, `karate_club.ipynb`). Use where it helps; don't narrate that you're using it.
- **`update_edges()` / `update_edge_plotting_keyword_arguments()`** for incremental edge styling. Good for the build-up flow.
- **Cross-link to gallery pages** when mentioning a parameter with a deep-dive: `For a high-level overview of the supported visualization back ends, see the [Hive Plots Using Other Visualization Libraries notebook](hive_plot_viz_outside_matplotlib.ipynb).`
- **Format cross-links as prose paragraphs**, not bulleted `## See Also`. Canonical: one paragraph per pointer in the form `For more on X, see the [Y](Y.ipynb) page.` (or `notebook` for a tutorial target). A generic `## See Also` + bullets reads as reference-index genre.
- **Exception:** topic-specific closing sections with their own depth are fine (e.g., `setting_partition_variable.ipynb` closes with `## Using Node Graph Metrics as Partition Variables`). The heading earns its place by naming a specific topic, not by being a catch-all.
- **Link to the single best next-step notebook, not every subordinate reference.** Don't enumerate "see the X Table, the Y Method, and the Z Walkthrough" — pick the walkthrough.
- **Anchor links:** `[Section Name](other_notebook.ipynb#section-name-slug)` (lowercased heading, spaces → hyphens). Use when the destination has multiple sections.

### Use the library; don't reinvent it

- **Derive a partition from a continuous variable:** `NodeCollection.create_partition_variable(data_column=..., cutoffs=..., labels=...)`. Don't hand-roll `pd.cut` + manual merge.
- **Build from a `networkx` graph plus computed metrics:** pass the graph straight to the constructor with the metrics you want (e.g. `HivePlot(graph=..., node_graph_metrics=["degree"], ...)`). The older `networkx_to_nodes_edges()` + `pd.DataFrame(G.degree).merge(...)` still works; new tutorials prefer the streamlined call.
- **Per-group edge styling:** `update_edges(partition_id_1=..., partition_id_2=..., ...)`. Don't loop over `edges.data`.
- **Multi-tag edges:** build the dict-of-DataFrames input and let `Edges` handle it.

If you're writing 10+ lines of pandas plumbing for hive plot setup, stop and check for a one-line equivalent.

### Figure-quality checks before shipping

- **Title overlap.** `ax.set_title(..., y=1.05)` (or `1.1`-`1.15` for multi-line or `flexitext`).
- **Single-color or invisible nodes/edges.** Check `repeat_edge_kwargs` / `non_repeat_edge_kwargs` are applied and distinguishable.
- **Highlight markers must be captioned.** A random colored dot on top of the plot needs a name in the title or `flexitext`.
- **Alpha and linewidth.** Default `alpha=1`, `linewidth=1` looks like ink blots above ~100 edges. Drop to ~0.4-0.6 or `linewidth=0.5`. See `comparing_network_subgroups.ipynb`.

## Workflow

1. Confirm subtype and section. Ask if unsure.
2. Identify or build the dataset. Real → provenance + citation; synthetic → designed to expose the relationships.
3. Sketch the questions and answers the final figure should reveal.
4. Pick a snake_case filename matching siblings.
5. Write the notebook. Prose-to-code roughly balanced; a mostly-code tutorial is really a gallery page.
6. Register in `docs/source/notebooks/index.rst` in both blocks, same order.
7. Run end-to-end (`make test-nb` is official; quick local execution in the `hiveplotlib` kernel works for verification).

## Reference notebooks by subtype

- **Concept introductions** → `introduction_to_hive_plots.ipynb`, `introduction_to_p2cps.ipynb`
- **Quick starts** → `quick_hive_plots.ipynb`
- **Real-data** → `karate_club.ipynb`, `bitcoin_user_ratings.ipynb`, `election_96.ipynb`, `correlations.ipynb`
- **Conceptual deep-dives** → `comparing_network_subgroups.ipynb`, `hive_plots_for_large_networks.ipynb`, `hive_plots_more_than_three_groups.ipynb`, `hive_plot_matrices.ipynb`, `hive_plot_viz_outside_matplotlib.ipynb`, `datashading_p2cps.ipynb`

Reading the closest neighbor before drafting is usually faster than working from this skill alone.
