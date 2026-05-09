---
name: viz-quality-bar
description: Visualization quality bar for hiveplotlib — foundational principles (storytelling-with-data, accessibility, data-ink discipline, palette discipline, density management), the polish-in-proportion-to-role rule, hive-plot-specific viz rules, datashader specifics, operational pre-flight checks, and an empirical-patterns appendix derived from auditing the hiveplotlib examples corpus. Load whenever working on hive plot figures, notebook viz cells, viz backend code, or reviewing rendered figures.
type: skill
---

# Hiveplotlib visualization quality bar

Storytelling-with-data philosophy, Cole Knaflic-aligned, paired with accessibility discipline (WCAG, colorblind-safe palettes) and Tufte-style data-ink minimalism. The figure tells the story; viz is a load-bearing element of the message, not decoration.

This skill is loaded by agents that touch viz: Viz Critic, Notebook Author, Code Engineer (when working on plotting code), API Critic (when reviewing viz APIs). It is the source of truth for what makes a hive plot figure ship-ready.

The skill is structured top-down: universal foundational principles, then the polish budget rule (the principled answer to "is more polish always better"), then hiveplotlib-specific rules, then datashader specifics, then operational pre-flight checks, then an empirical-patterns appendix capturing the corpus's house style.

## Foundational principles

**Clarity is the communicator's responsibility, not the reader's.** If the reader has to puzzle over what a figure means, the figure has failed. Title, axis labels, and on-figure annotations alone must answer "what am I looking at?" without requiring the calling code or a verbal explanation.

**Color focuses attention; it does not decorate.** Color is processed pre-attentively, before conscious thought, so spending it on incidental groups burns the budget before the actual story lands. Default to a single muted hue for the bulk of edges; reserve a saturated accent for the subset the eye should land on first.

**Match palette type to data type.** Categorical groups use qualitative palettes (no implied ordering). Ordered scalars use sequential, lightness-based palettes. Data with a meaningful midpoint (signed correlations, deltas around zero) uses diverging palettes centered on that midpoint. Don't mix types: a sequential palette on a categorical variable invents an ordering that isn't there.

**Never use rainbow / jet for ordered data.** Non-monotonic luminance fabricates banding artifacts where the data is smooth, and the palette is broken for the ~8% of men with red-green color vision deficiency. Default to viridis or cividis (cividis when severe deuteranopia is a concern); both are perceptually uniform and survive grayscale printing.

**Verify accessibility before shipping.** Around 8% of men of Northern European descent and 0.5% of women have some color vision deficiency. Hold every figure to: at least 4.5:1 contrast for text, 3:1 for graphical objects against the background. Never encode meaning in red-vs-green alone; pair with shape, line style, or position so the figure works in grayscale. When in doubt, run the palette through a colorblind simulator.

**Maximize data-ink; erase the rest.** Drop bounding boxes, redundant gridlines, 3D bevels, drop shadows, gradient backgrounds. Thin axis lines. Suppress redundant tick labels. Let edges and nodes carry the weight (Tufte's data-ink ratio).

**Label directly on the figure when possible.** Every glance from chart to a side legend is cognitive overhead. Label each axis with its node-group name at the axis tip; annotate the one or two edges or nodes that carry the takeaway with on-plot text. Title-embedded `flexitext` story is preferred over corner legends.

**Annotate the insight in the title, not the noun.** "Engineering connects to Sales 3x more than Sales connects internally" beats "Network of departments." The title carries the takeaway sentence; subtitle or caption holds methodology.

**Encode magnitude where the visual system is most accurate.** Position and length are the most precise pre-attentive channels; area and color saturation are the least precise (Cleveland & McGill). For hive plots, prefer encoding the most important quantitative variable as axis position (radial distance) rather than node area or edge color.

**Scale node size by area, not radius.** A 2× value drawn with 2× radius looks 4× bigger because area grows quadratically. Use matplotlib's scatter `s` parameter (already area-based) rather than computing a radius and squaring it.

**Tame density with structure, not transparency alone.** A 1000-node hairball with low alpha is still a hairball. The hive-plot play is exactly the structural fix: meaningful axes, meaningful sort order. When even that is too dense, filter to top-k edges by weight, threshold by significance, switch backends to datashader, or split into small multiples (HivePlotMatrix) before relying on alpha.

**Use small multiples to compare, not overlaid spaghetti.** Seven overlaid series are unreadable; seven panels at identical scale let the eye scan and compare (Tufte). For hive plots: HivePlotMatrix, one panel per condition, timepoint, or threshold rather than collapsing into one figure with seven edge colors.

## Polish in proportion to role

A figure's polish budget should match its role in the notebook. This isn't a tradeoff between "principles" and "pragmatism"; it's a principled question of where polish is earned. Audit of the hiveplotlib examples corpus shows the corpus splits cleanly into three budgets:

**Showcase figures** (the canonical end-of-tutorial summary, the figure that delivers a research finding) earn full polish. `flexitext`-embedded titles with color tokens matching the figure's encoding; two-tone palettes (saturated colors against `darkgray` de-emphasis); hand-tuned title `y`; `Line2D`-built custom legends; multi-step `update_edges`; deliberate `zorder` and `alpha`. Canonical: `karate_club.ipynb`'s faction-coloring figure, `comparing_network_subgroups.ipynb`'s older-vs-newer comparison, `bitcoin_user_ratings.ipynb`'s annotated HPM.

**Instructional figures** (demonstrating what a method does, what a parameter changes) stay spare. `set_title("...", y=1.05, size=N)` and default colors are the rule. The figure exists to clarify an API, not sell a finding. Canonical: `edge_kwarg_hierarchy.ipynb`, `computing_graph_metrics.ipynb`, `update_edge_viz_kwargs.ipynb`.

**HivePlotMatrix figures** sit in the middle. The polish budget skews toward layout discipline (`unify_axes=True`, custom colorbars via `inset_axes`, `fig.suptitle` with consistent `y`) over text styling.

**Predictor.** If the caption sells an insight ("Group 1 is asymmetrically social with Groups 2 and 3"), it's a showcase and earns polish. If the caption demonstrates an API affordance ("Edge Kwargs Persisted"), it's instructional and stays spare. **If a polish step needs more than ~10 lines of matplotlib mucking and isn't on a showcase figure, ask whether the figure earns it.** This is the operational guardrail against burying instructional content under styling.

## Hive-plot-specific viz rules

Five rules the universal principles miss because they're ecosystem-specific. Drawn from the corpus audit.

1. **Repeat axes pair with two-tone edge coloring.** When `repeat_axes=True`, default to a muted color (corpus standard: `darkgray`) for `repeat_edge_kwargs` (intra-group) and a saturated color or full palette for `non_repeat_edge_kwargs` (inter-group). Without the contrast, the doubled axes overwhelm the eye and the inter/intra distinction vanishes. Set on init via `repeat_edge_kwargs={"color": "darkgray"}` or post-hoc via `update_edge_plotting_keyword_arguments(edge_kwarg_setting="repeat_edge_kwargs", color="darkgray")`.

2. **Color groups through the kwarg hierarchy, not raw matplotlib.** Use `update_edges(p1, p2, color=..., p2_to_p1=False)` for directed asymmetric stories. The five-level hierarchy (`all_edge_kwargs` → `clockwise/counterclockwise/repeat_edge_kwargs` → `non_repeat_edge_kwargs`) exists for a reason; pick the highest-specificity setting that captures the story. Canonical reference: `examples/edge_kwarg_hierarchy.ipynb`.

3. **Multi-tag overlay with shared geometry needs small multiples or datashader.** Single-figure overlay of multiple tags hides one set under another regardless of alpha. Default to `HivePlotMatrix.from_tags()` for cross-tag comparison; `comparing_network_subgroups.ipynb` is the canonical example of why overlay fails at scale.

4. **HivePlotMatrix cross-cell comparison requires `unify_axes=True`.** Without it, each cell auto-scales independently and visual position carries no meaning across cells. The corpus uses `unify_axes=True` in 73 of the comparative HPM hits across 13 files; the rare `False` cases are when each cell is genuinely a different network. Default to True; deviate only with cause.

5. **For datashader cross-plot comparison, pin all rasterization parameters.** Without pinning, the same network at two `pixel_spread` settings reports different density ranges and panels can't be compared honestly. See "Datashader specifics" below.

## Datashader specifics

The datashader backend handles large networks (low thousands of nodes/edges and up). It's not a stylistic preference; it's a rendering choice that compensates for matplotlib's limits at scale. The universal principles above mostly apply, with the following backend-specific overrides:

- **Trigger by size, not by preference.** Default to matplotlib for small and medium networks. Reach for datashader when alpha tuning has become "trial-and-error of playing with `linewidth` and `alpha`" (`comparing_network_subgroups.ipynb`'s explicit framing).
- **Color is via `cmap_nodes` and `cmap_edges` only.** `color=` and `node_kwargs={"color": ...}` raise `AttributeError` because the backend draws via `plt.imshow` on rasterized images. The backend defaults are `cmap_nodes="copper"` and `cmap_edges` set to a seaborn cubehelix-like palette (similar to matplotlib's `"Blues"`), with `log_cmap_nodes=True` and `log_cmap_edges=True`. Accept the defaults; don't reach for `magma`/`cividis` or other customizations unless the figure has a specific reason to deviate. (`magma`/`cividis` are the convention for continuous coloring on the *matplotlib* path, not on datashader.)
- **Log colormaps default on.** Turn off only if the rasterization is genuinely uniform (rare).
- **Multi-tag plotting requires `tag=`.** Without it, a tag is silently chosen and the figure misleads.
- **Cross-plot comparison requires pinning** `dpi`, `pixel_spread_nodes`, `pixel_spread_edges`, `vmax_nodes`, `vmax_edges` across panels. `bitcoin_user_ratings.ipynb` is the canonical example, pinning `vmax_edges=800` and `vmax_nodes=200` across all years.

## Interactive backends (Bokeh, HoloViews, Plotly)

Rarely needed for static demos, but they matter when interactivity is wanted. The most common driver is hover info on nodes or edges (showing node ID, partition, metric values when the user hovers over a glyph). Pan, zoom, and click selection are also supported.

Default to matplotlib for static demos, datashader at scale. Reach for an interactive backend when:

- The figure is for exploration, not publication.
- The reader needs to identify specific nodes or edges by hover.
- The audience will view the output in a browser (HTML docs, panel/dashboard, notebook export).

Each backend (bokeh, holoviews, plotly) has its own kwarg surface. `rename_edge_kwargs()` translates matplotlib-style kwargs, but not all kwargs survive the translation. When porting a figure between backends, expect to retune. The relevant extras gate the imports: `hiveplotlib[bokeh]`, `hiveplotlib[holoviews]`, `hiveplotlib[plotly]`.

## Operational checks before shipping a figure

- No single-color or invisible nodes/edges. (Exception: deliberate `darkgray` for de-emphasized "background" sets, or `alpha=0` on nodes when the panel is about edge density. Both are principled in the corpus.)
- Title placement: the goal is to minimize whitespace between the top of the hive plot and the title. Hive plots leave significant empty space above the axes (especially 3-axis layouts), so the default matplotlib title position looks too far from the figure. Tune title `y` upward until the gap closes. Typical landings: `y=1.05` to `y=1.15`, with longer or multi-line titles tending toward higher `y`. The specific value isn't load-bearing; closing the gap is.
- Alpha 0.4-0.6 for moderately dense plots (100+ edges); drop to 0.1-0.2 as density scales 10x. (Alpha is not a substitute for filtering or backend choice — see "Tame density with structure" above.)
- Linewidth sanity: thicker for sparse, thinner for dense.
- **Pick the right backend for the scale.** Matplotlib handles up to a few hundred edges well. As edge/node counts climb into the low thousands and beyond, switch to the datashader backend (see Datashader specifics).
- Color distinction in any partition or grouping must be visually separable in both color and grayscale. If you have to squint, fix it.
- When a section is *about* a metric (edge betweenness, degree, etc.), color the edges or nodes by that metric. A section that doesn't visually encode its own subject is a missed opportunity.

## Empirical patterns from the codebase

Descriptive appendix capturing what hiveplotlib's notebooks do consistently. Use as a "house style" reference: when in doubt, do what the corpus does.

**Sequential palettes for continuous coloring (matplotlib path):** `cividis` for edges, `magma` for nodes is the go-to convention for continuous node/edge coloring on the matplotlib (and matplotlib-rendered HoloViews) path. Both are perceptually uniform, colorblind-safe, and survive grayscale. Use them unless the figure has a specific reason to deviate. Datashader has its own defaults (`copper` for nodes, a cubehelix-like palette for edges); accept those rather than overriding to `magma`/`cividis`.

**Qualitative palettes:** `sns.color_palette("colorblind")` for many-group cases. For paired groups, the corpus's default contrast pair is named matplotlib colors `royalblue` / `darkorange` (karate, quick start, comparing subgroups). This is a hidden house style worth honoring.

**De-emphasis color:** `darkgray` for the "background" set — intra-group edges in karate, "everyone else" in quick start. Reuse this convention rather than inventing a new muted color.

**Diverging palettes:** built ad-hoc via `sns.light_palette` + `sns.dark_palette` glued through `ListedColormap`. `coolwarm` is reserved for cases where the variable has an established color convention (politics in `election_96.ipynb`).

**Title placement:** the corpus tunes title `y` to close the gap between the top of the hive plot and the title (hive plots leave noticeable empty space above the axes, so default placement looks too far). Typical landings between `y=1.05` and `y=1.15`, longer titles trending higher. The values themselves aren't normative; closing the whitespace is. Values below `1.0` are outliers and likely inconsistencies.

**flexitext titles:** color tokens always match the figure's color encoding (`<color:royalblue, weight: bold>Mr. Hi</>`). Placement coordinates (`xycoords="figure fraction"`, `x` and `y`) are hand-tuned per figure; no reusable rule. Expect to tune when adding a new flexitext title.

**Polished-figure import stack:**

```python
import matplotlib.pyplot as plt
from flexitext import flexitext
import seaborn as sns
from matplotlib.lines import Line2D  # for legend-only line glyphs
```

Instructional notebooks omit `flexitext` and `Line2D`.

**Partition design in showcases:** `repeat_axes=True` is near-universal in showcase notebooks (karate, intro, quick start, networkx, large networks, customizing curves), paired with the two-tone discipline above.

**Datashader defaults:** `cmap_nodes="copper"`, `cmap_edges` set to a seaborn cubehelix-like palette (similar to `"Blues"`), `log_cmap_nodes=True`, `log_cmap_edges=True`, `vmin_nodes=1`, `pixel_spread_nodes=7`, `pixel_spread_edges=1`, `dpi=150`. Honor these unless the figure has a specific reason to deviate.

**Thumbnails for the gallery.** Every notebook has a thumbnail at `docs/source/_static/<notebook_name>.<ext>`, referenced from `conf.py`. Sphinx's default would be the last figure in the notebook, which is rarely the right thumbnail. Routine post-notebook step: pick the most representative or orthogonal figure from the notebook, strip all text, save it as the thumbnail. The thumbnail-source figure is sometimes color-tuned post-hoc to orthogonalize from neighboring gallery thumbnails (i.e., to make the thumbnail visually distinct from its neighbors). When reviewing a notebook's colors, don't flag a non-data-semantic color choice as a "doesn't-match-data-semantics" issue if the figure is also serving as the thumbnail; the orthogonalization is principled.

**Caveats from audit:** P2CP-specific patterns (`introduction_to_p2cps.ipynb`, `datashading_p2cps.ipynb`, `p2cp_viz_outside_matplotlib.ipynb`) only spot-checked; their kwarg surface may have its own conventions worth documenting. Interactive backends (bokeh / plotly / holoviews) only sampled at the import level — see the Interactive backends section above for what we do know.

## Pointers

- `hiveplotlib/.claude/skills/hiveplotlib-tutorial-notebook/SKILL.md` — tutorial-specific viz (incremental reveal, partition discipline, embedded story).
- `hiveplotlib/.claude/skills/hiveplotlib-gallery-notebook/SKILL.md` — gallery-specific viz (reference style, single-feature focus).
- `hiveplotlib/examples/edge_kwarg_hierarchy.ipynb` — canonical reference for edge styling.
- `hiveplotlib/examples/karate_club.ipynb` — canonical reference for storytelling-aligned tutorial style.
- `hiveplotlib/examples/comparing_network_subgroups.ipynb` — canonical reference for showcase polish at scale.
- `hiveplotlib/examples/bitcoin_user_ratings.ipynb` — canonical reference for HPM small-multiples + datashader pinning.
