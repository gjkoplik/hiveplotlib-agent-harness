---
name: viz-quality-bar
description: Hiveplotlib's visualization house style, layered on top of the general `agent-viz` figure bar rather than restating it. Covers the storytelling-versus-instructional split as this corpus actually practises it, hive-plot-specific rules (repeat-axis two-tone colouring, the edge kwarg hierarchy, the 2-3 axis rule, partial edge coverage), datashader specifics, interactive backends, and the empirical palette and layout conventions derived from auditing the examples corpus. Load whenever producing, revising or reviewing a hive plot, a P2CP, a HivePlotMatrix, or any figure in this repo's notebooks. Load `agent-viz` alongside it for the general bar; this skill does not repeat it.
type: skill
---

# Hiveplotlib visualization house style

**This skill is a layer, not a whole bar. Load `agent-viz` first.**

The general rules for any figure a person will look at (quantitative honesty, statistical honesty, accessibility, how a figure argues, production and reproducibility, the pre-ship checks) live in the **`agent-viz`** skill, which is maintained separately and shared across projects:

```
/plugin marketplace add gjkoplik/skills
/plugin install agent-viz@gjkoplik
```

Everything below is what hiveplotlib adds on top: this corpus's house style, the hive-plot-specific rules a general bar has no reason to carry, and the conventions an audit of `examples/` actually found. It deliberately does **not** restate the general bar. If a rule here contradicts `agent-viz`, `agent-viz` wins and the contradiction is a bug in this file.

**If `agent-viz` is not installed**, the short version of what you are missing, kept as a labeled fallback rather than a copy:

- **Quantitative honesty.** Zero baselines under area-encoded marks. Truncation disclosed by choosing the range, not by a break glyph. Never invert an axis silently. Label a log axis. Units on every quantitative axis. No raw floats in labels. Colorbars carry explicit limits, a unit, and `extend` when data crosses them.
- **Statistical honesty.** An error bar without a stated meaning is not a measurement. State n. Two whiskers in one figure must not mean two different things. Show the spread you measured. Disclose clipping, missing data, and binning choices. Categorical order is an encoding.
- **Accessibility.** 4.5:1 contrast for text. Never encode in red-vs-green alone. Colour distinction survives grayscale. Alt text where the medium supports it.

That list is a pointer, not the rule set. Go read `agent-viz`.

## Two kinds of figure

Decide which one you are drawing before you read another rule. This library's corpus contains both, deliberately, and they pull against each other.

**The storytelling figure.** A research finding, an end-of-tutorial payoff, a blog post, a README hero. Its job is to make a reader understand something quickly and remember it. It owes the floor *and* the ceiling: insight in the title, emphasis palette, direct labeling, annotation of the point being made, hand-tuned placement. Canonical: `karate_club.ipynb`, `comparing_network_subgroups.ipynb`, `bitcoin_user_ratings.ipynb`.

**The instructional figure.** A demonstration of what a method, parameter, or backend does. Its job is to show the reader **how to use the code**, and the code is as much the artifact as the picture. Its real quality bar is *minimal, clean, copy-able source* that still renders something coherent. Canonical: `edge_kwarg_hierarchy.ipynb`, `computing_graph_metrics.ipynb`, `update_edge_viz_kwargs.ipynb`.

**Things that are correct on an instructional figure and must not be flagged:**

- **A plain, literal title.** `ax.set_title("repeat_axes=True")` is doing its job. Demanding an insight-bearing title on a parameter demo is a category error; there is no insight, that is the point.
- **Default colors, no palette work.** Every line spent on color is a line the reader has to skip to find the API call.
- **No `flexitext`, no custom `Line2D` legend, no tuned `zorder`.** The polished import stack is a showcase signature and its absence here is deliberate.
- **Color choices orthogonalized across notebooks rather than optimized within one.** Making neighboring gallery entries visually distinguishable is a real constraint operating at the level of the gallery, not the figure. A palette that looks arbitrary in isolation can be correct in context.
- **Nothing hand-aligned, no whitespace craft.** Matplotlib's defaults are a legitimate answer when the figure is a caption for a code cell.

**Where the tension does not resolve in favor of minimalism, and this is the pushback:**

- **Orthogonalize inside the safe space, not out of it.** Differentiating notebooks by reaching for a rainbow ramp on ordered data, or a red-against-green pairing, buys visual distinctiveness with a floor violation. There is plenty of room between `cividis`, `magma`, the seaborn colorblind qualitative set, and the `royalblue`/`darkorange` pair. Differentiation is a constraint to satisfy *within* the floor.
- **A literal title still has to be literal about the right thing.** "Hive Plot" on a page demonstrating `repeat_axes` is a miss by instructional standards too, because it orients the reader toward nothing. The instructional title's job is orientation rather than insight, but it still has a job.
- **Minimal code buys API comprehension. It never buys a misleading axis.** A truncated baseline, an unlabelled log scale, a silently clipped colorbar or an undisclosed error bar is as wrong in a two-cell demo as in a paper figure, and worse in one respect: the reader is there to learn the idiom, and will copy it.

**Predictor:** caption sells an insight → storytelling. Caption demonstrates an API → instructional. **HivePlotMatrix** sits in the middle: layout discipline (`unify_axes=True`, `inset_axes` colorbars, consistent `fig.suptitle` `y`) over text styling.

**The customization budget, stated once so the producer and the reviewer use one number.** On a non-showcase figure, more than **~10 lines** of matplotlib customization is the point to ask whether it earns its place; more than **~100 lines** is the point to stop and reclassify the figure. Reviewers flag against the same two thresholds.

## Hive-plot-specific rules

1. **Hive plots have 3 axes, almost always.** Partition design uses meaningful binary or ternary cuts the reader can name, not numbered community-detection labels. Four or more axes is a bug; reach for `HivePlotMatrix` instead.
2. **Repeat axes pair with two-tone edge coloring.** `repeat_edge_kwargs={"color": "darkgray"}` for intra-group, saturated or full palette for `non_repeat_edge_kwargs` (inter-group). Without contrast, the doubled axes overwhelm.
3. **Color groups through the kwarg hierarchy, not raw matplotlib.** Use `update_edges(p1, p2, color=..., p2_to_p1=False)` for directed asymmetric stories. Pick the highest-specificity setting that captures the story. Reference: `examples/edge_kwarg_hierarchy.ipynb`.
4. **Multi-tag overlay needs small multiples or datashader.** Single-figure overlay hides one set under another regardless of alpha. Default to `HivePlotMatrix.from_tags()`.
5. **HivePlotMatrix cross-cell comparison requires `unify_axes=True`.** Without it, each cell auto-scales independently and visual position carries no cross-cell meaning.
6. **For datashader cross-plot comparison, pin all rasterization parameters.** See datashader specifics.
7. **A hive plot draws a subset of the edges, and the subset moves with the axis order.** Without repeat axes, intra-group edges have nowhere to land. Say what fraction is drawn when the figure is making a claim about the whole graph.

## Datashader specifics

Rendering choice for dense edge sets, not a stylistic preference. Hive-plot edges bundle through shared angular corridors, so they occlude earlier than a raw scatter would; the trigger is qualitative, and it fires sooner than most expect (often a few hundred edges, not thousands). Backend-specific overrides on the universal principles:

- **Trigger by density, not preference.** Default to matplotlib for sparse plots. Reach for datashader once lowering `alpha` has stopped separating structure, i.e. alpha tuning has become trial-and-error.
- **Color via `cmap_nodes` / `cmap_edges` only.** `color=` and `node_kwargs={"color": ...}` raise `AttributeError`. Defaults: `cmap_nodes="copper"`, `cmap_edges` set to a seaborn cubehelix-like palette (similar to `"Blues"`), `log_cmap_nodes=True`, `log_cmap_edges=True`. Accept defaults; don't reach for `magma`/`cividis` (those are the matplotlib-path convention).
- **Log colormaps default on.** Turn off only when rasterization is genuinely uniform.
- **Multi-tag requires `tag=`.** Without it, a tag is silently chosen and the figure misleads.
- **Cross-plot comparison requires pinning** `dpi`, `pixel_spread_nodes`, `pixel_spread_edges`, `vmax_nodes`, `vmax_edges`. Canonical: `bitcoin_user_ratings.ipynb` (pins `vmax_edges=800`, `vmax_nodes=200` across years).
- **Hand-rolling a datashader path? Spread the aggregate, then shade once; never `tf.spread(tf.shade(agg))`.** Shading first and spreading the *colored* image composites with "over", so a lighter (less dense) line paints over a denser crossing: the "impossible for counts" artifact where light overwhelms dark at overlaps. hiveplotlib's own backend spreads the count array and shades once at the very end (matplotlib `imshow` cmap), which is why a hand-rolled path looks wrong beside it. Prefer the `datashade_*` functions; if you must hand-roll, spread the aggregate first.

## Interactive backends (Bokeh, HoloViews, Plotly)

Default to matplotlib for static, datashader at scale. Reach for interactive when the figure is for exploration not publication, when the reader needs hover identification of nodes/edges, or when the audience views in a browser. Each backend has its own kwarg surface; `rename_edge_kwargs()` translates matplotlib-style kwargs but not all survive, so expect to retune when porting. Extras gate imports: `hiveplotlib[bokeh|holoviews|plotly]`. Interaction is an encoding decision: say what the interaction is *for*, and remember an interactive figure that does not respond is not interactive.

## Operational checks: hive plots

- No single-color or invisible nodes/edges (exceptions: `darkgray` de-emphasis, `alpha=0` on nodes for edge-density panels, both principled in the corpus).
- **Title placement:** minimize whitespace between top-of-plot and title. Hive plots leave empty space (especially 3-axis), so default matplotlib placement looks too far. Tune `y` upward. Typical landings `y=1.05` to `y=1.15`, with `y=1.2` common on longer titles. The value isn't load-bearing; closing the gap is.
- Alpha 0.4-0.6 for moderately dense (100+ edges); drop to 0.1-0.2 as density scales 10x. Alpha is not a substitute for filtering or backend choice.
- Linewidth: thicker for sparse, thinner for dense. Default `linewidth=1` looks like ink blots above ~100 edges; drop to ~0.5.
- Check `repeat_edge_kwargs` / `non_repeat_edge_kwargs` are applied and distinguishable, and check `vmin`/`vmax` against the data range.
- **Pick the backend for the density.** Matplotlib for sparse plots; because hive-plot edges bundle, reach for datashader once lowering `alpha` stops separating structure (often just a few hundred edges), not only at thousands.
- **Getting the pixels:** notebook PNG outputs are reachable in-memory from `cell.outputs[].data['image/png']` (base64) without re-rendering to disk.

## Empirical patterns from the codebase

Descriptive appendix; house style. When in doubt, do what the corpus does.

**Scope any corpus grep to tracked files** (`git ls-files`, or non-recursive `examples/*.ipynb`). `examples/.ipynb_checkpoints/` holds dozens of untracked stale notebooks, including checkpoints of deleted ones, and a recursive grep folds them in and roughly doubles every count. A convention the maintained corpus abandoned can otherwise vote here.

- **Sequential palettes (matplotlib path):** `cividis` for edges, `magma` for nodes. Perceptually uniform, colorblind-safe, survive grayscale. Datashader uses its own defaults; don't override unless there's a reason.
- **Qualitative:** `sns.color_palette("colorblind")` for many groups. Paired groups: matplotlib's `royalblue` / `darkorange` (karate, quick start, comparing subgroups). Hidden house style worth honoring.
- **De-emphasis:** `darkgray`. Reuse rather than inventing.
- **Diverging:** built ad-hoc via `sns.light_palette` + `sns.dark_palette` glued through `ListedColormap`. `coolwarm` reserved for cases with an established convention (politics in `election_96.ipynb`).
- **Prefer a colored title over a small legend.** When the legend would carry only two or three entries, delete it and put those words in the title, colored to match what they label, via `flexitext`. The title then does double duty: it states the takeaway *and* it is the legend, so the reader never leaves the sentence to decode the figure.
  ```python
  from flexitext import flexitext
  flexitext(
      0.02, 1.02,
      "<size:17, weight:bold>Drawing 2M edges went from "
      "<color:darkgray>11.2 seconds</> to <color:#2166AC>7.9 seconds</></>",
      va="bottom", xycoords="axes fraction", ax=ax,
  )
  ax.get_legend().remove()  # or never create one
  ```
  Color tokens must match the encoding exactly, or the title lies. Placement is hand-tuned; expect to nudge `x`/`y`. **Do not** use it when the legend has many entries, when the mapping is ordered (a colorbar's job), or when the title's sentence would have to contort to name every series. Gallery notebooks are exempt: a plain `ax.set_title(...)` is the genre default there.
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
- **Thumbnails for the gallery.** Every notebook has a thumbnail at `docs/source/_static/<notebook>.<ext>` referenced from `conf.py`. Sphinx's default (last figure) is rarely right. Routine post-notebook step: pick the most representative figure, strip text, save. Sometimes color-tuned post-hoc to orthogonalize from neighboring thumbnails, so don't flag non-data-semantic color choices on a thumbnail-serving figure.
- **Audit caveats:** P2CP-specific patterns only spot-checked. Interactive backends only sampled at the import level. Counts in this appendix were taken before the checkpoint-scoping rule above and are worth re-deriving before anyone leans on a specific number.

## Pointers

- `<harness>/.claude/skills/hiveplotlib-tutorial-notebook/SKILL.md`: tutorial-specific viz
- `<harness>/.claude/skills/hiveplotlib-gallery-notebook/SKILL.md`: gallery-specific viz
- `examples/edge_kwarg_hierarchy.ipynb`: edge styling reference
- `examples/karate_club.ipynb`: storytelling-aligned tutorial reference
- `examples/comparing_network_subgroups.ipynb`: showcase polish at scale
- `examples/bitcoin_user_ratings.ipynb`: HPM small-multiples + datashader pinning
