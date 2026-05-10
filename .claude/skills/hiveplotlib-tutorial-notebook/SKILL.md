---
name: hiveplotlib-tutorial-notebook
description: Create a new tutorial notebook for hiveplotlib (or revise one to match house style). Tutorial notebooks are longer-form, narrative-driven explorations with motivation, a story or dataset, rhetorical questions that get revisited, and (for real-data tutorials) a References section with citations, e.g. "An Introduction to Hive Plots", "Quick Start Hive Plots", "Zachary's Karate Club", "Comparing Network Subgroups", "An Introduction to P2CPs". Use this skill whenever the user wants to add a tutorial, write up a real-dataset example, build a long-form explainer notebook, or document a new high-level concept like a new HivePlotMatrix variant or a new P2CP capability. Trigger when the user says things like "write a tutorial for X", "add a new long-form example", "do a writeup of dataset Y as a hive plot", or anything that calls for the storytelling/motivational mode rather than a feature reference.
type: skill
---

# Hiveplotlib Tutorial Notebook

This skill produces tutorial notebooks that match hiveplotlib's existing house style. Tutorials are the **storytelling layer** of the docs: they explain *why* a technique exists, walk a reader through a real or contrived dataset, pose questions, build up a visualization, and reflect on what the visualization shows. They're what someone reads when they want to understand hive plotting *as a concept*, not when they want to look up how a specific parameter behaves.

If the user wants a **short, focused, single-feature reference notebook** (e.g. documenting one method, parameter, or backend), use the `hiveplotlib-gallery-notebook` skill instead. Tutorials are linked from `docs/source/notebooks/index.rst`; gallery pages are linked from `docs/source/gallery_examples/index.rst`.

## When to use this skill vs. the gallery skill

Pick tutorial if any of these are true:

- The notebook needs a **motivation** section answering "why this technique?".
- The reader's question is "*what is this and when would I use it*" rather than "*how do I call this method*".
- The natural title is a sentence-y phrase (e.g. `### An Introduction to Hive Plots`, `### Quick Start Hive Plots`, `### Zachary's Karate Club`).
- The notebook walks through a **real dataset** (Zachary's Karate Club, Bitcoin user ratings, 1996 election data) or builds a **purpose-built synthetic dataset** to support the narrative.
- The notebook poses rhetorical questions early on and revisits them after the visualization.

Pick gallery if it's a focused "how to use feature X" reference.

## Tutorial subtypes

The existing tutorials cluster into four shapes; pick the closest match before drafting:

1. **Concept introductions** (e.g. `introduction_to_hive_plots.ipynb`, `introduction_to_p2cps.ipynb`). Heavy motivation section. Compare hive plots / P2CPs against alternatives (circular layout, spring layout, 3D scatter). Synthetic data built inline. Title: `### An Introduction to ...`.
2. **Quick starts** (e.g. `quick_hive_plots.ipynb`). Less philosophical, more "here is the practical workflow end-to-end" using a stochastic block model or similar contrived dataset. Title: `### Quick Start ...` or `### Quick Reference ...`.
3. **Real-data examples** (e.g. `karate_club.ipynb`, `bitcoin_user_ratings.ipynb`, `election_96.ipynb`). Open with a Background section explaining the dataset's provenance, end with a References section. Title: noun phrase naming the dataset.
4. **Conceptual deep-dives** (e.g. `comparing_network_subgroups.ipynb`, `hive_plots_for_large_networks.ipynb`, `hive_plot_matrices.ipynb`). Cover one large idea with multiple variants and tradeoffs, often building up scale/complexity progressively. Title: noun phrase naming the concept.

## File layout and registration

A new tutorial lives in `examples/` (the canonical source; *do not* edit copies in `docs/source/notebooks/`, those are overwritten on each docs build per [CLAUDE.md](../../../CLAUDE.md)).

1. Create `examples/<snake_case_name>.ipynb`. Filename is short and descriptive; `karate_club.ipynb`, `comparing_network_subgroups.ipynb`, `introduction_to_hive_plots.ipynb`.
2. Add the notebook to the appropriate section of [docs/source/notebooks/index.rst](../../../docs/source/notebooks/index.rst). The sections are: **Hive Plots** (concept intros + deep-dives for hive plots), **Hive Plot Examples** (real-data hive plot tutorials), **Polar Parallel Coordinates Plots** (concept intros + deep-dives for P2CPs), **P2CP Examples** (real-data P2CP tutorials). Each section has both an `.. nblinkgallery::` block **and** a hidden `.. toctree::` block; register the notebook in *both*, in the same order.
3. If the notebook depends on optional extras (`bokeh`, `holoviews`, `plotly`, `datashader`), surface the install command up front, e.g. `pip install hiveplotlib[datashader]`. See `comparing_network_subgroups.ipynb` for inline phrasing of optional-section requirements.

## Notebook structure

### 1. Title cell (markdown, H3)

Use `### Title`; note this is **H3, not H1**. This is unusual but it's the established convention for hiveplotlib tutorials. Subsection headers are then `####`.

Examples: `### An Introduction to Hive Plots`, `### Quick Start Hive Plots`, `### Zachary's Karate Club`, `### Comparing Network Subgroups`, `### An Introduction to P2CPs`.

### 2. Imports (single code cell)

One code cell, all imports at the top. Common companions for tutorials: `matplotlib.pyplot as plt`, `networkx as nx`, `pandas as pd`, `numpy as np`, `seaborn as sns`, `flexitext` (for in-figure color-coded titles), `matplotlib.lines.Line2D` (for custom legend handles, used in many real-data tutorials).

### 3. Motivation / Background (markdown, H4)

This section is what makes a tutorial a tutorial. Pick the right framing:

- **Concept intros** open with `#### Motivation: Why X?` walking through the problem the technique solves. Compare against alternatives the reader probably already uses ("hairball" force-directed plots, circular layouts, 2D scatter projections of 3D data). The intro tutorial for hive plots opens by naming two failure modes of existing layouts and then says hive plots fix both.
- **Real-data tutorials** open with `#### Background` describing the dataset's history, who collected it, what the nodes/edges represent. Karate Club and the 1996 election notebook are the canonical examples.
- **Quick starts and deep-dives** can skip a heavy motivation block and go straight to "before plotting" / "data setup" with a one-paragraph framing.

### 4. Data setup

Tutorials usually do **not** lean on `hiveplotlib.datasets.example_*` helpers; that's gallery territory. Instead:

- Build a **purpose-built synthetic dataset** that supports the narrative (stochastic block models with carefully tuned probabilities, contrived employee-seniority data, four Gaussian blobs at corners of a cube). Make the construction visible so the reader understands what relationships are baked in.
- Or **load a real dataset** via `networkx` (Karate Club graph), a `hiveplotlib.datasets` real-data helper, or a CSV.

State the relationships you've built in *plain English* before showing the visualization. The reader needs to know what to look for. Example from `quick_hive_plots.ipynb`:

> Above, we have generated 3 cliques of equal size (10 per clique) with the following properties:
> - Within-group communication is only 10% (`0.1` on the diagonal).
> - Group 1 is very social with Groups 2 and 3 (`0.5`)...

### 5. Pose questions, then visualize

Tutorials work best when they ask the reader to predict what they'll see. Examples:

- "*How socially separated are the two factions? How long does it take to confirm there exists a connection between blue and orange?*" (Karate Club)
- "*To what extent can we visualize these relationships with standard graph layouts as well as Hive Plots?*" (Intro to Hive Plots)
- "*What if we want to compare multiple subgroups embedded in 1 network?*" (Comparing Network Subgroups)

Then build up the hive plot incrementally. Often the right structure is:

1. Show the alternative visualization the reader probably already knows for this kind of data, and explain its limits. **Important: pick the alternative that is canonical for this dataset or use case, not just whatever is easiest.** Karate Club has a circular layout in the original 1977 paper, so karate_club.ipynb opens with a circular layout. Les Misérables is more commonly shown as a force-directed layout. A protein interaction network might be commonly shown as a heatmap or 3D scatter. **Do not default to circular.** Look up what the canonical visualization for the dataset is, or skip the comparison entirely if there is no obvious standard.
2. Build a baseline hive plot. Note what it does and doesn't show.
3. Add features (repeat axes, edge kwargs, sorting tweaks) one at a time, with a markdown cell between each explaining what changed and why.
4. Embed the legend / story directly in the title using `flexitext` for the final figure (see `karate_club.ipynb`'s closing visualization for the canonical pattern).

### Partition design: stay on 2 or 3 axes

Hive plots are designed for 2 or 3 axes. **A 4-axis hive plot is a bug, not a feature.** When you derive a partition for a real dataset that has no built-in groups (Les Misérables, Florentine Families, an arbitrary `networkx` graph), you have several choices and the wrong one ruins the visualization:

- **Bad pattern**: run a community-detection algorithm, get 5 communities, stuff the 2 smallest into an `Other` axis. The reader can no longer see "the whole graph" because edges to `Other` collapse meaningful structure into noise.
- **Better pattern**: pick a binary or ternary cut that has substantive meaning for the dataset (Medici-vs-rest, low/medium/high on a continuous variable, observed-faction-A vs observed-faction-B). The cut should be one a reader can name and remember, not a numbered community label.
- **When the dataset really has 4+ groups that all matter**: use `HivePlotMatrix.from_partition` for a small-multiples view. That is what HPMs were designed for. The tutorial should then be about the HPM, not a stuffed 4-axis hive plot.

If a community-detection step is part of the narrative (Les Misérables is a fair example), still resolve to 2 or 3 axes for the final hive plot. Either pick the 3 largest communities and **drop** the others from the visualization (with a sentence saying so), or recombine into 2-3 named groups by hand.

### 6. Reflect on the visualization

After the final figure, **revisit the questions** posed in section 5. Tutorials feel complete when they close a loop. Example from Karate Club:

> Let's revisit our questions from earlier:
> > _How socially separated are the two factions?_...
> From this figure, there appear to be far more intra-faction connections than inter-faction connections...

### 7. References (real-data tutorials only)

Real-data tutorials end with a `#### References` markdown section listing citations for the dataset. Examples:

> Zachary W. (1977). An information flow model for conflict and fission in small groups. *Journal of Anthropological Research*, 33, 452-473.

> Koplik, Gary, and Ashlee Valente. "The Parallel Coordinates Plot Revisited..." arXiv preprint arXiv:2109.10193 (2021).

Synthetic-data tutorials usually skip this section but may include "Further reading" pointers to other tutorials and gallery pages.

## Voice and tone

Tutorials read top-to-bottom rather than as reference material, but they are not essays. The prose exists to explain the visualization; cut anything that isn't doing that work. Use:

- **Rhetorical questions** that get revisited, sparingly. One framing question at the start and a revisitation at the end is enough; do not stack questions throughout the body.
- **First-person plural** ("we will...", "let's...", "we can...").
- **Plain-English framing** of every code block, in 1 to 2 sentences. The reader should be able to follow the story without running the code. They should not need to read three paragraphs per cell.
- **Italics** for terms-of-art on first appearance (*hive plot*, *repeat axes*, *partition*, *parallel coordinates*).
- **Backticks** for class names, methods, parameters.

### Length discipline

A tutorial that runs much longer than its closest existing sibling is almost always too long. Concrete tells that you have over-written:

- More than 1-2 sentences of preamble before a code cell.
- A "Why bin?" or "Why use X?" abstract section that exists alongside the visualization that already answers the question. Cut the abstract section; let the visualization do the work.
- A meta-discussion of which tools the notebook is using ("we will use `flexitext` to embed legends"; just use it). Library helpers are tools, not characters in the story.
- Multiple paragraphs reflecting on a single figure. One paragraph of reflection is plenty.

When in doubt, look at the closest existing notebook in your subtype and match its prose-to-code ratio. If you are above 2x the existing notebook's word count for a comparable scope, cut prose.

### Human voice (and avoiding AI tells)

The notebooks should read like Gary wrote them, not like an AI did. Concrete rules:

- **No em-dashes.** Use commas, parentheses, semicolons, or just shorter sentences. This is the single biggest AI-tell to scrub.
- **No AI filler phrases.** Avoid "delve", "moreover", "furthermore", "underscore", "in essence", "it's worth noting that", "let us consider", "as we can see". These read as machine-generated even when the surrounding prose is fine.
- **No hedging meta-commentary.** "It is important to note that X" is just "X". "We will now discuss Y" is just discussing Y.
- **Direct, slightly informal voice.** "Let's look at what happens when we sort by degree" reads better than "We shall now examine the consequences of sorting by degree." Read the existing tutorials for tone calibration; `karate_club.ipynb` and `comparing_network_subgroups.ipynb` are good benchmarks.
- **Cut throat-clearing.** "First, let's discuss the data" before introducing the data adds nothing. Just introduce the data.

Avoid heavy bullet lists in the body. Save bullets for enumerating dataset properties (e.g. the synthetic-data ground-truth list in `quick_hive_plots.ipynb`) or wrap-up takeaways.

## Idioms and conventions

- **H3 title, H4 subsections.** Repeat: gallery pages use H1/H2, tutorials use H3/H4. Don't mix.
- **Line length 79 in code cells** (per `examples/ruff.toml`). Run `make format` before committing.
- **`flexitext`** is the standard for in-figure color-coded narrative titles. `quick_hive_plots.ipynb` and `karate_club.ipynb` are the canonical examples. Use it where it helps the figure tell its story; do not narrate that you are using it.
- **`update_edges()` / `update_edge_plotting_keyword_arguments()`** for incremental edge styling. Good for the "build up the figure one feature at a time" tutorial flow.
- **Cross-link out to gallery pages** when the tutorial mentions a parameter or option that has its own gallery deep-dive, e.g. `For a high-level overview of the supported visualization back ends, see the [Hive Plots Using Other Visualization Libraries notebook](hive_plot_viz_outside_matplotlib.ipynb).`
- **Cross-link to other tutorials** when the tutorial references a related real-data example or follow-up.

### Use the library; don't reinvent it

Tutorials should showcase the right idiomatic API, not paper around it. The library has helpers for most of the common setup steps; using them is shorter and is what readers should learn from a tutorial. Specifically:

- For **deriving a partition from a continuous variable** (low/medium/high bins, etc.), use `NodeCollection.create_partition_variable(data_column=..., cutoffs=..., labels=...)`. Do NOT hand-roll `pd.cut` plus a manual column merge.
- For **building from a `networkx` graph plus computed metrics** (degree, betweenness, etc.), check whether the project's current API supports it via a single call (e.g. `HivePlot.from_networkx(..., node_graph_metrics=["degree"], ...)` if that surface is available on the current branch). If yes, use that. The older idiom of `networkx_to_nodes_edges()` followed by `pd.DataFrame(G.degree, columns=...).merge(...)` still works, but new tutorials should prefer the streamlined call where available. Read the current state of `src/hiveplotlib/converters.py` and `src/hiveplotlib/hiveplot.py` before deciding which to use.
- For **degree merging when the streamlined call is not available**, the `pd.DataFrame(G.degree).merge(...)` pattern is acceptable; cite `karate_club.ipynb` as the canonical reference and don't invent a new variant.
- For **per-group edge styling**, use `update_edges(partition_id_1=..., partition_id_2=..., ...)`. Don't loop over `edges.data` manually.
- For **multi-tag edges**, build the dict-of-DataFrames input form and let `Edges` handle it; don't pre-concatenate.

If you find yourself writing 10+ lines of pandas plumbing to set up a hive plot, stop and check whether the library has a one-line equivalent.

### Figure-quality checks before shipping

Tutorials are the front door for new users; the figures need to actually look good:

- **Title overlap.** When using `ax.set_title(...)` on a hive plot, the default position often clips into the top of the plot. Use `y=1.05` (or `1.1` to `1.15` if the title has multiple lines or is set via `flexitext`). The existing tutorials do this routinely.
- **Single-color or invisible nodes/edges.** If your hive plot is meant to show inter-group structure but everything renders as one color, the figure is failing to make its point. Check `repeat_edge_kwargs` / `non_repeat_edge_kwargs` are actually being applied, and that the colors are distinguishable.
- **Highlight markers must be captioned.** If you `ax.scatter(...)` a single point on top of the hive plot to draw attention to it, the title or `flexitext` block must name what the dot represents. A random colored dot with no caption confuses the reader.
- **Sanity-check alpha and linewidth.** Tutorials that build up edges with default `alpha=1` and `linewidth=1` often look like dense ink-blots. For datasets larger than ~100 edges, drop alpha to ~0.4-0.6 or use `linewidth=0.5`. Look at `comparing_network_subgroups.ipynb` for the canonical alpha-and-linewidth tuning.

## Workflow when creating a new tutorial

1. **Confirm subtype and section.** Concept intro, quick start, real-data example, or conceptual deep-dive? Which section in `docs/source/notebooks/index.rst`? If unsure, ask.
2. **Identify or build the dataset.** Real datasets need provenance and a citation; synthetic datasets need to be designed to expose the relationships the tutorial wants to show.
3. **Sketch the questions** the tutorial will pose and the answers the final visualization should reveal. The whole tutorial hangs on this loop.
4. **Pick a snake_case filename** matching siblings in the right section.
5. **Write the notebook** following the skeleton above. Keep prose and code in roughly equal balance; a tutorial that's mostly code is really a gallery page in disguise.
6. **Register the notebook** in `docs/source/notebooks/index.rst` in the right section, in *both* the `nblinkgallery` block and the hidden `toctree` block.
7. **Run it end-to-end** before reporting done. `make test-nb` is the official check; for a quick local verification execute the notebook in the `hiveplotlib` jupyter kernel and confirm no errors.

## Example skeletons by tutorial subtype

When the user picks a subtype, the closest existing notebook(s) are the best reference:

- **Concept introductions** → `introduction_to_hive_plots.ipynb`, `introduction_to_p2cps.ipynb`
- **Quick starts** → `quick_hive_plots.ipynb`
- **Real-data examples** → `karate_club.ipynb` (small undirected), `bitcoin_user_ratings.ipynb` (medium signed), `election_96.ipynb` (P2CP), `correlations.ipynb` (P2CP)
- **Conceptual deep-dives** → `comparing_network_subgroups.ipynb`, `hive_plots_for_large_networks.ipynb`, `hive_plots_more_than_three_groups.ipynb`, `hive_plot_matrices.ipynb`, `hive_plot_viz_outside_matplotlib.ipynb`, `datashading_p2cps.ipynb`

Reading the closest neighbor before drafting is usually faster than working from this skill alone.
