---
name: viz-quality-bar
description: Visualization quality bar for hiveplotlib — foundational principles (storytelling-with-data, accessibility, data-ink discipline, palette discipline, density management), the polish-in-proportion-to-role rule, hive-plot-specific viz rules, datashader specifics, operational pre-flight checks, and an empirical-patterns appendix derived from auditing the hiveplotlib examples corpus. Load whenever working on hive plot figures, notebook viz cells, viz backend code, or reviewing rendered figures.
type: skill
---

# Hiveplotlib visualization quality bar

Storytelling-with-data (Cole Knaflic), accessibility (WCAG, colorblind-safe), Tufte data-ink minimalism. The figure carries the message; viz is load-bearing, not decoration. Loaded by Viz Critic, Notebook Author, Code Engineer (on plotting), API Critic (on viz APIs).

## Foundational principles

- **Clarity is the communicator's responsibility.** Title, labels, on-figure annotations alone answer "what am I looking at?"
- **Color focuses attention; it does not decorate.** Default to a single muted hue for the bulk; reserve a saturated accent for what the eye should land on.
- **Match palette type to data type.** Qualitative for categorical, sequential for ordered scalars, diverging around a meaningful midpoint. Don't mix.
- **Never rainbow / jet on ordered data.** Non-monotonic luminance fabricates banding and breaks for ~8% of men with red-green CVD. Default to viridis or cividis.
- **Verify accessibility before shipping.** 4.5:1 contrast for text, 3:1 for graphical objects. Never encode in red-vs-green alone; pair with shape, line style, position. Test in grayscale.
- **Maximize data-ink.** Drop boxes, redundant gridlines, 3D, shadows, gradients. Thin axes.
- **Label directly when possible.** Each glance to a side legend is overhead. Title-embedded `flexitext` over corner legends.
- **Annotate the insight in the title.** "Engineering connects to Sales 3x more than Sales connects internally" beats "Network of departments."
- **Encode magnitude in position and length.** Most precise pre-attentive channels. Prefer axis position over node area or edge color.
- **Scale node size by area, not radius.** Use scatter `s` (area-based), not a radius computation.
- **Tame density with structure, not just transparency.** A 1000-node hairball with low alpha is still a hairball. Filter, threshold, switch to datashader, or split into small multiples before relying on alpha.
- **Small multiples beat overlaid spaghetti.** Seven panels at identical scale beat seven overlaid series.

## Polish in proportion to role

A figure's polish budget matches its role. The corpus splits cleanly:

- **Showcase figures** (end-of-tutorial summary, research finding) earn full polish: `flexitext` titles with color tokens matching encoding, two-tone palettes (saturated against `darkgray`), hand-tuned title `y`, `Line2D` custom legends, multi-step `update_edges`, deliberate `zorder` and `alpha`. Canonical: `karate_club.ipynb`, `comparing_network_subgroups.ipynb`, `bitcoin_user_ratings.ipynb`.
- **Instructional figures** (demonstrate a method or parameter) stay spare. `set_title("...", y=1.05, size=N)` and default colors. Canonical: `edge_kwarg_hierarchy.ipynb`, `computing_graph_metrics.ipynb`, `update_edge_viz_kwargs.ipynb`.
- **HivePlotMatrix** sits in the middle. Layout discipline (`unify_axes=True`, `inset_axes` colorbars, consistent `fig.suptitle` `y`) over text styling.

**Predictor:** caption sells an insight → showcase. Caption demonstrates an API → instructional. **If a polish step needs more than ~10 lines of matplotlib and isn't on a showcase figure, ask whether it earns it.**

## Hive-plot-specific rules

1. **Repeat axes pair with two-tone edge coloring.** `repeat_edge_kwargs={"color": "darkgray"}` for intra-group, saturated or full palette for `non_repeat_edge_kwargs` (inter-group). Without contrast, the doubled axes overwhelm.
2. **Color groups through the kwarg hierarchy, not raw matplotlib.** Use `update_edges(p1, p2, color=..., p2_to_p1=False)` for directed asymmetric stories. Pick the highest-specificity setting that captures the story. Reference: `examples/edge_kwarg_hierarchy.ipynb`.
3. **Multi-tag overlay needs small multiples or datashader.** Single-figure overlay hides one set under another regardless of alpha. Default to `HivePlotMatrix.from_tags()`.
4. **HivePlotMatrix cross-cell comparison requires `unify_axes=True`.** Without it, each cell auto-scales independently and visual position carries no cross-cell meaning. Corpus uses True in 73 of comparative HPM hits across 13 files.
5. **For datashader cross-plot comparison, pin all rasterization parameters.** See datashader specifics.

## Datashader specifics

Rendering choice for dense edge sets, not a stylistic preference. Hive-plot edges bundle through shared angular corridors, so they occlude earlier than a raw scatter would; the trigger is qualitative, and it fires sooner than most expect (often a few hundred edges, not thousands). Backend-specific overrides on the universal principles:

- **Trigger by density, not preference.** Default to matplotlib for sparse plots. Reach for datashader once lowering `alpha` has stopped separating structure, i.e. alpha tuning has become trial-and-error.
- **Color via `cmap_nodes` / `cmap_edges` only.** `color=` and `node_kwargs={"color": ...}` raise `AttributeError`. Defaults: `cmap_nodes="copper"`, `cmap_edges` set to a seaborn cubehelix-like palette (similar to `"Blues"`), `log_cmap_nodes=True`, `log_cmap_edges=True`. Accept defaults; don't reach for `magma`/`cividis` (those are the matplotlib-path convention).
- **Log colormaps default on.** Turn off only when rasterization is genuinely uniform.
- **Multi-tag requires `tag=`.** Without it, a tag is silently chosen and the figure misleads.
- **Cross-plot comparison requires pinning** `dpi`, `pixel_spread_nodes`, `pixel_spread_edges`, `vmax_nodes`, `vmax_edges`. Canonical: `bitcoin_user_ratings.ipynb` (pins `vmax_edges=800`, `vmax_nodes=200` across years).
- **Hand-rolling a datashader path? Spread the aggregate, then shade once; never `tf.spread(tf.shade(agg))`.** Shading first and spreading the *colored* image composites with "over", so a lighter (less dense) line paints over a denser crossing: the "impossible for counts" artifact where light overwhelms dark at overlaps. hiveplotlib's own backend spreads the count array and shades once at the very end (matplotlib `imshow` cmap), which is why a hand-rolled path looks wrong beside it. Prefer the `datashade_*` functions; if you must hand-roll, spread the aggregate first.

## Interactive backends (Bokeh, HoloViews, Plotly)

Default to matplotlib for static, datashader at scale. Reach for interactive when the figure is for exploration not publication, when the reader needs hover identification of nodes/edges, or when the audience views in a browser. Each backend has its own kwarg surface; `rename_edge_kwargs()` translates matplotlib-style kwargs but not all survive — expect to retune when porting. Extras gate imports: `hiveplotlib[bokeh|holoviews|plotly]`.

## Operational checks before shipping a figure

- No single-color or invisible nodes/edges (exceptions: `darkgray` de-emphasis, `alpha=0` on nodes for edge-density panels — both principled in the corpus).
- **Title placement:** minimize whitespace between top-of-plot and title. Hive plots leave empty space (especially 3-axis), so default matplotlib placement looks too far. Tune `y` upward. Typical landings `y=1.05` to `y=1.15`; longer or multi-line titles tend higher. The value isn't load-bearing; closing the gap is.
- Alpha 0.4-0.6 for moderately dense (100+ edges); drop to 0.1-0.2 as density scales 10x. Alpha is not a substitute for filtering or backend choice.
- Linewidth: thicker for sparse, thinner for dense.
- **Pick the backend for the density.** Matplotlib for sparse plots; because hive-plot edges bundle, reach for datashader once lowering `alpha` stops separating structure (often just a few hundred edges), not only at thousands.
- Color distinction must hold in grayscale.
- When a section is *about* a metric, color by that metric.

## Empirical patterns from the codebase

Descriptive appendix; house style. When in doubt, do what the corpus does.

- **Sequential palettes (matplotlib path):** `cividis` for edges, `magma` for nodes. Perceptually uniform, colorblind-safe, survive grayscale. Datashader uses its own defaults; don't override unless there's a reason.
- **Qualitative:** `sns.color_palette("colorblind")` for many groups. Paired groups: matplotlib's `royalblue` / `darkorange` (karate, quick start, comparing subgroups). Hidden house style worth honoring.
- **De-emphasis:** `darkgray`. Reuse rather than inventing.
- **Diverging:** built ad-hoc via `sns.light_palette` + `sns.dark_palette` glued through `ListedColormap`. `coolwarm` reserved for cases with an established convention (politics in `election_96.ipynb`).
- **Title placement:** corpus tunes `y` between `1.05` and `1.15`; values below `1.0` are outliers.
- **flexitext titles:** color tokens match figure's encoding (`<color:royalblue, weight: bold>Mr. Hi</>`). Placement is hand-tuned; expect to tune when adding.
- **Polished-figure import stack:**
  ```python
  import matplotlib.pyplot as plt
  from flexitext import flexitext
  import seaborn as sns
  from matplotlib.lines import Line2D
  ```
  Instructional notebooks omit `flexitext` and `Line2D`.
- **Partition design in showcases:** `repeat_axes=True` near-universal, paired with two-tone discipline.
- **Datashader defaults:** `cmap_nodes="copper"`, `cmap_edges` seaborn cubehelix-like (similar to `"Blues"`), `log_cmap_nodes=True`, `log_cmap_edges=True`, `vmin_nodes=1`, `pixel_spread_nodes=7`, `pixel_spread_edges=1`, `dpi=150`. Honor unless there's a reason.
- **Thumbnails for the gallery.** Every notebook has a thumbnail at `docs/source/_static/<notebook>.<ext>` referenced from `conf.py`. Sphinx's default (last figure) is rarely right. Routine post-notebook step: pick the most representative figure, strip text, save. Sometimes color-tuned post-hoc to orthogonalize from neighboring thumbnails — don't flag non-data-semantic color choices on a thumbnail-serving figure.
- **Audit caveats:** P2CP-specific patterns only spot-checked. Interactive backends only sampled at the import level.

## Pointers

- `<harness>/.claude/skills/hiveplotlib-tutorial-notebook/SKILL.md` — tutorial-specific viz
- `<harness>/.claude/skills/hiveplotlib-gallery-notebook/SKILL.md` — gallery-specific viz
- `examples/edge_kwarg_hierarchy.ipynb` — edge styling reference
- `examples/karate_club.ipynb` — storytelling-aligned tutorial reference
- `examples/comparing_network_subgroups.ipynb` — showcase polish at scale
- `examples/bitcoin_user_ratings.ipynb` — HPM small-multiples + datashader pinning
