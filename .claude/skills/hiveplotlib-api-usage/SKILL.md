---
name: hiveplotlib-api-usage
description: How to correctly USE the hiveplotlib API from a DOWNSTREAM project that depends on the installed package — the canonical construction paths, the judgment the library encodes as defaults/thresholds (when to reach for datashader, a matrix vs one plot, comparable panels), and the traps agents hit when driving the API blind. Load when writing Python that imports hiveplotlib to build a plot in a consumer repo (analysis / research / notebook work against the published package). Do NOT load when developing hiveplotlib itself, i.e. a repo containing `src/hiveplotlib/`: there the source tree is the source of truth and this skill lags in-flight API changes, so it would mislead. Distinct from `mental-model` (developing the library) and `viz-quality-bar` (figure-design judgment, which this points at).
type: skill
---

# Using the hiveplotlib API

For agents *writing code against* an installed hiveplotlib, in a downstream consumer repo. This is the twin of the public `llms-full.txt` (this one lands in context during loops; that one is fetchable at the docs root); keep their guidance in sync when either changes.

## When NOT to use this skill

This skill documents how to *use* the published hiveplotlib package. Do not apply it when working inside the hiveplotlib library repo itself (the one containing `src/hiveplotlib/`). There, the code you are reading or changing is the source of truth, and this skill (plus the `llms.txt` / `llms-full.txt` files it mirrors) can lag behind in-flight API changes, so it would fight active development. The harness deliberately does not sync this skill into the library repo; if you somehow see it there, ignore it and trust the source.

## Match the installed version

This skill tracks the latest API, so a consumer repo pinned to an older release can be missing features documented here. The `unify_axes` and `graph_multigraph` keyword arguments, for example, are recent additions absent from `hiveplotlib==0.27.0`: a call this skill presents as normal raises `TypeError: HivePlot.__init__() got an unexpected keyword argument 'graph_multigraph'` there. When a kwarg or constructor documented here raises `TypeError` or `AttributeError`, confirm it against the installed build with `inspect.signature(...)` before assuming a typo, then bump the pin or fall back to the older signature. Guessing a fix (hand-rolling what the missing kwarg would have done) reintroduces the low-level scaffolding this skill exists to steer you off of. (Observed against a 0.27.0-pinned satellite repo, 2026-07-06.)

## The rules (read first)

1. Build with `HivePlot(...)`. Never hand-wire `Axis` / `add_nodes` / `place_nodes_on_axis` / `connect_axes`; that low-level `BaseHivePlot` path renders but does not transfer.
2. Pass a NetworkX graph as the `graph=` **keyword**: `HivePlot(graph=g, ...)`. Positional `HivePlot(g, ...)` silently misbinds. There is no `from_networkx`.
3. More than three partition groups: start with `HivePlotMatrix.from_partition(...)`. A single plot with more than three axes is a deliberate, occasional choice, not the reflex.
4. Edges bundling into a hairball (often just a few hundred, since hive-plot edges share angular corridors): render with `backend="datashader"` once lowering `alpha` has stopped separating structure. Don't wait for thousands.
5. Comparing matrix panels: `unify_axes=True` for axis ranges (matrix-only, and only when cells share a sorting variable) *and* a consistent node color for color. Separate concerns; check both.
6. Don't override the good defaults: the datashader colormaps, the per-point alpha channel, the graph type (`graph_multigraph` / `graph_directed`).

Everything below expands these. The root cause of all six is reconstructing the API from primitives instead of from its intended entry points. For figure *quality* (color, alpha, density, storytelling), defer to `viz-quality-bar`.

## Build a hive plot: the two canonical paths

You construct one class, `HivePlot`, and give it data one of two mutually exclusive ways.

**From tabular data:**

```python
from hiveplotlib import HivePlot, NodeCollection, Edges

nodes = NodeCollection(data=node_df, unique_id_column="id")
edges = Edges(data=edge_df)  # edge_df has "from" / "to" columns
hp = HivePlot(
    nodes=nodes,
    edges=edges,
    partition_variable="group",  # a node column: which axis each node lands on
    sorting_variables="score",  # a node column: position along the axis
)
hp.plot()  # renders on the default matplotlib backend
```

**From a NetworkX graph** (pass it as the `graph=` keyword):

```python
hp = HivePlot(
    graph=g,  # networkx Graph/DiGraph/MultiGraph/MultiDiGraph
    partition_variable="group",  # a node attribute on g
    sorting_variables="score",
    node_graph_metrics=["degree"],  # optional: compute metrics during ingestion
)
```

Node attributes on the graph become available as partition/sorting variables. Request derived metrics (e.g. `"degree"`) via `node_graph_metrics=[...]` and use them as the partition or sorting variable. Graph metrics are not tied to the `graph=` path: `node_graph_metrics` and `edge_graph_metrics` also work on the tabular path (an internal graph is built from your `nodes`/`edges`), and either can be computed later via `compute_graph_metrics()`.

### Trap: passing the graph positionally

`HivePlot(g, ...)` binds `g` to the **`nodes`** parameter, not `graph`. It fails later, deep inside node handling, with a confusing `AttributeError` far from the real mistake. Always pass `graph=g` as a keyword.

### Trap: `HivePlot.from_networkx(...)` does not exist

There is no `from_networkx` classmethod (an easy thing to assume from other network libraries). Pass the graph through `graph=`. If you need to customize the conversion (rename the unique-id column, skip the uniqueness check), call `hiveplotlib.converters.networkx_to_nodes_edges(graph, ...)` yourself and pass the resulting `nodes` / `edges`. The *out* direction is `hiveplotlib.converters.nodes_edges_to_networkx(...)`.

### Trap: don't hand-wire the low-level scaffold

If you find yourself constructing `Axis` objects, calling `add_nodes`, looping `place_nodes_on_axis`, and connecting axes edge-by-edge with `connect_axes`, stop. That is the `BaseHivePlot` layer. It renders, so the mistake is silent, but it bypasses everything `HivePlot` does for you (axis assignment, node placement, sorting from columns) and stores edges in a different place, so code written against it doesn't transfer to `HivePlot`. Only drop to the base class for a genuinely bespoke manual layout.

## The judgment calls (these are the expensive mistakes)

Half of blind-usage failures are *working code that makes a bad plot*. The library encodes the right call as a default or a threshold. Know the thresholds.

### More than three groups: start with a matrix

A single hive plot targets **two or three axes**. Putting a 4+-group partition on one `HivePlot` silently hides most edges (edges only draw between neighboring axes), so when a partition has more than three groups the recommended starting point is a `HivePlotMatrix`. A single hive plot with more than three axes is still legitimate when you specifically want it (it only works when nodes can be ordered so edges connect neighboring axes; see the *Hive Plots with More Than Three Groups* notebook), but that is a deliberate decision, not the reflexive reach. Pick the matrix constructor by intent:

- `HivePlotMatrix.from_partition(...)`: one partition variable with many groups; one cell per group. This is the canonical "I have more than three groups" path.
- `HivePlotMatrix.from_tags(...)`: one panel per edge type / relationship / predicate (one tagged edge set per cell).
- `HivePlotMatrix.from_variable_sweep(...)`: sweep a sorting variable across cells.

Do not write a helper that returns a `HivePlot` or a `HivePlotMatrix` depending on group count; they are different objects with different call sites.

### Two axes: you are probably in the wrong library

The lower bound bites harder than the upper one. A hive plot with only two axes and no repeat axes wastes the polar layout: nothing occupies the third sector, so it is two spokes with edges between them. Switching to a P2CP is **not** the fix, because a two-axis P2CP is still polar and polar buys nothing at two axes; the honest form of two parallel axes is a plain Cartesian parallel coordinates plot, drawn outside this library. If a task lands you at two axes (for example a pairwise "how do these two node types connect" view), add a meaningful third axis or reach for a different tool; do not ship the two-axis figure. Three axes, often with repeat axes, is the load-bearing hive-plot shape.

The library's own two-axis figures are not a counterexample. They exist to show that the mechanics work, and in the P2CP documentation to teach how to read a single pair of axes before more are added. Neither is a recommendation to plot two axes for real work. (Observed on a knowledge-graph pairwise view, 2026-07-06.)

### Dense / bundled edges: the datashader backend

Hive-plot edges are curves bundled through shared angular corridors, so they occlude into a hairball earlier than a raw scatter would. The trigger is qualitative: once lowering `alpha` has stopped separating structure, you are past due for datashader. In practice that can be as few as a few hundred edges, so don't wait for thousands.

```python
hp = HivePlot(..., backend="datashader")  # needs the hiveplotlib[datashader] extra
```

On the datashader backend, color goes through `cmap_edges` / `cmap_nodes`; `color=` and `node_kwargs={"color": ...}` raise on this backend. When you still want crisp colored nodes on top of datashaded edges, compose datashader edges under matplotlib axis lines and nodes on one shared `ax` (see the Datashader example notebook). Keep in mind: `graph_multigraph=False` (the default for tabular input) collapses duplicate same-direction edges, which is the very density datashader is meant to show, so keep duplicates when overlap *is* the signal.

### Comparing panels: unify axis ranges AND color, separately

Two things must match for small multiples to be comparable, and they are controlled independently:

- **Axis value ranges** (so a position means the same value in every cell): `unify_axes` is a `HivePlotMatrix` feature only (`HivePlotMatrix(...)` / `from_partition(...)` / `from_variable_sweep(...)`); `HivePlot` has no `unify_axes`. Pass `unify_axes=True`, or `unify_axes={"vmin": ..., "vmax": ...}` for explicit bounds. Only unify when the cells share the same sorting variable, so their axes measure the same quantity. If cells sort on different variables, unifying is actively misleading (the axes mean different things), so leave it off. This does **not** touch color.
- **Color** (so a color means the same thing in every panel): the matrix's `node_kwargs` are forwarded to every cell's node render, so a single `node_kwargs` styles all cells uniformly. For data-driven per-node color, fix each node's color up front (a consistent category-to-color map, or a precomputed color) so every cell colors the same node identically. There is no automatic color unification, and the matrix does **not** thread a `NodeCollection`'s `node_viz_kwargs` per cell.

Verify you unified both where it makes sense: panels can line up positionally while their colors still disagree.

For single plots that must match an external reference, pin each axis's range explicitly with `vmin` / `vmax`: pass `axis_kwargs={axis_id: {"vmin": ..., "vmax": ...}}` at construction, or call `plot.update_axis(axis_id, vmin=..., vmax=...)` afterward. Don't hand-recompute node coordinates or drop to the base-class layer to force a range (there is no `unify_axes` on `HivePlot`).

### Don't fight the good defaults

- **Datashader colormaps.** The datashader edge/node colormaps have deliberately chosen defaults. Overriding them (e.g. forcing `viridis` through `cmap_edges` / `cmap_nodes`) tends to be harder to read intuitively and more visually distracting, without adding information. Both the default and `viridis` are perceptually uniform, so this is about legibility and restraint, not colormap correctness; leave the defaults unless you have a specific reason.
- **Per-point alpha.** On a single `HivePlot`, drive per-node visibility through the per-node channel (`NodeCollection.node_viz_kwargs` / a per-point alpha column), not a scalar `alpha=` in `node_kwargs`, which clobbers the per-point channel and makes hidden nodes render solid.
- **Graph type (`graph_multigraph` / `graph_directed`).** These set the internal graph used for metrics and edge handling. `graph_multigraph=False` (default for tabular input) collapses duplicate same-direction edges last-write-wins; `True` keeps them, but metrics needing a simple graph (e.g. `onion_layers`) reject a multigraph. `graph_directed` changes what metrics mean (directed vs undirected degree, reciprocal-edge handling). Flipping either is legitimate when you actually want that graph type, including to enable a computation a warning is pointing you at; just do it understanding the implications, not reflexively to silence the warning.

## Edge styling

The simplest lever is bulk styling of all edges, set at construction or after:

```python
hp = HivePlot(..., all_edge_kwargs={"color": "gray", "alpha": 0.3})
# or later:
hp.update_edge_plotting_keyword_arguments("all_edge_kwargs", color="gray", alpha=0.3)
```

Bulk styling follows a fixed precedence (lowest → highest priority): `all_edge_kwargs` → `clockwise_edge_kwargs` / `counterclockwise_edge_kwargs` → `repeat_edge_kwargs` / `non_repeat_edge_kwargs`. Later overrides earlier; conflicts warn. Each of those five names is both a `HivePlot(...)` constructor kwarg and a valid `edge_kwarg_setting` for `update_edge_plotting_keyword_arguments()`.

The two `add_edge_kwargs` methods are **not** interchangeable across classes:

- `P2CP.add_edge_kwargs(tag=..., **edge_kwargs)`: per-tag styling by tag alone.
- `HivePlot.add_edge_kwargs(axis_id_1, axis_id_2, tag=..., **edge_kwargs)`: styles a *specific axis pair* and requires both axis IDs. It is fine-grained, not the "style all edges" call. For all-edge styling on a `HivePlot`, use the hierarchy kwargs above.

Don't invent top-level `edge_color=` / `edge_style=` kwargs; they don't exist.

## Build order for metric-driven partitions

If the metric comes from a graph, one call computes it and partitions on it in the right order:

```python
hp = HivePlot(
    graph=g,
    node_graph_metrics=["degree"],
    partition_variable="degree",
    sorting_variables="degree",
)
```

For tabular data, the metric must already be a column *before* you partition on it (`create_partition_variable` requires `data_column` to already exist in the node data):

```python
nodes = NodeCollection(
    data=node_df, unique_id_column="id"
)  # node_df already has a "degree" column
col = nodes.create_partition_variable(
    data_column="degree", cutoffs=3
)  # bins it into a new column
hp = HivePlot(
    nodes=nodes, edges=edges, partition_variable=col, sorting_variables="degree"
)
```

Use `create_partition_variable` rather than hand-rolling `pd.cut` plus a label dict.

## When in doubt

The full public usage reference (self-contained, no harness needed) is served at
`https://hiveplotlib.readthedocs.io/stable/llms-full.txt`. The human docs entry points are the *Introduction to Hive Plots* and *Quick Start Hive Plots* notebooks.
