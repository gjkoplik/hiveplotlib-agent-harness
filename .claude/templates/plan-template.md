# Plan: <issue ref or topic>

<!--
Hiveplotlib and wiki-structure plans go to wiki/wiki/plans/<topic>.md (tracked
in the wiki submodule). Harness-self plans go to agent-harness/.claude/plans/
<topic>.md (gitignored). New plans start in plans/; once the work ships, wiki
plans move to plans/archived/<topic>.md (see plans/README.md). The plan is the
canonical reference; the conversation transcript is not.
-->

## Goal

One paragraph. What user-visible value lands when this ships?

## Prior ADRs / design docs

Populated by research-liaison at planning start. List relevant entries:

- `wiki/wiki/adr/NNNN-topic.md` — one-line on why it's relevant.
- ...

Or "None — net new design space" / "None — out of scope for ADR review."

## Patterns this replaces

- `<old pattern>` at: `<file:line>`, `<file:line>`. Replace with `<new pattern>`.

Or "None, this is a net new addition." QA Engineer greps post-execution; survivors fail unless in `Holdouts`.

## Default justifications

- `<param>=<default>`: <one-sentence justification grounded in user workflow>

Or "No new defaults."

## Naming audit

Check user-facing names against the vocabulary users would use (often the dominant adjacent ecosystem):

- New parameters: `<list>`. Vs. user vocab: `<ok | amend X→Y because Z>`
- New methods/classes: `<list>`. Same check.
- Prose-only terms: `<list>`

Internal module/package names are out of scope.

## API usage examples

Required when this work adds or modifies user-facing API.

### Proposed (from planner / Orchestrator)

Each example uses `# Example N: <context>` / `# Example data:` / `# Call site:`. Must be runnable Python with no placeholders. Ellipses, `g = nx.Graph(...)` without edges, "imagine the user has..." fail.

Carve-out for ecosystem inputs: when the input is user-constructed (an `nx.Graph`, a DataFrame), `# Example data:` constructs it with realistic ecosystem calls (e.g., `g = nx.karate_club_graph()`). When the input is library-produced, the block can reference the producing call.

```python
# Example 1: <one-line context>
# Example data:
<runnable data construction, no placeholders>

# Call site:
<call site>
```

### API Critic's take (planning mode)

`Agreed`, or preferred snippets with one-sentence reasons:

```python
# Critic's preferred form for Example 1: <reason for the difference>
<code>
```

Note recurring patterns across snippets if applicable.

### API Critic — post-implementation review

Filled by api-critic after each workstream that lands user-facing API code (including mechanical propagations to sibling classes — see mental-model rule 7). Until filled:

```
Pending — invoke api-critic in post-implementation mode after Workstream <X> ships.
```

Once filled:

```
Status: clean | propose
API surface reviewed: [<class.method>, <function>, ...]
Concerns:
  - [must-fix | worth-discussing | low-confidence] <one-line concern> — at <file>:<line>
    Suggested change: <one-sentence>
```

If no user-facing API change, state "No API surface change" and skip all three subsections.

## Notebook review

Filled by editorial-critic after each workstream that adds or restructures a notebook; it reviews the notebook as an artifact (right notebook, dataset coherence, genre fit, section-worth). Figures in the same notebook are viz-critic's post-impl pass, not this one. Until filled:

```
Pending — invoke editorial-critic in post-implementation mode after Workstream <X> ships.
```

Once filled:

```
Status: clean | propose
Notebook reviewed: <file>, genre (gallery | tutorial), class documented
Concerns:
  - [must-fix | worth-discussing | low-confidence] <one-line concern> — at <file>:<cell>
```

If the plan touches no notebooks, state "No notebook change" and skip this section.

## Workstreams

Coherent, dispatchable chunks with checkable done-when criteria. Don't pre-assign agents.

Multiple workstreams may dispatch concurrently. In-tree state from a co-running workstream is expected, not broken. When the state genuinely doesn't match the brief, halt under rule 9.

### Workstream A: <name>

**Status:** not started | in progress | complete
**Files:** <list>
**Done when:** <criteria>

### Workstream B: <name>

...

## Plan amendments

Populated by orchestrator in `amend-plan` mode when rule 14 triggers (post-impl critic `must-fix`/`should-fix`, or a scope-changing user ask). Three subsections matching rule 14's trigger taxonomy. Append-only; empty until amendments accrue.

Placeholder when empty:

```
None yet. The Orchestrator will populate this section in amend-plan mode if
emergent work surfaces (rule 14 trigger).
```

### Added workstream <letter>: <name>

**Date:** YYYY-MM-DD
**Trigger:** <which critic finding or user ask prompted this>
**Status:** not started | in progress | complete
**Files:** <list>
**Done when:** <criteria>

### In-scope tweak: <one-line>

**Date:** YYYY-MM-DD
**Trigger:** <which critic finding or user ask>
**Workstream affected:** <letter and name>
**Change:** old → new diff sketch

### Deferred follow-up: <one-line>

**Date:** YYYY-MM-DD
**Trigger:** <which critic finding or user ask>
**Target:** <next plan / next release / left intentionally>
**Rationale:** <one line>

## Holdouts

Optional. Patterns the replace-and-sweep audit should leave alone:

- `<file:line>`: kept as `<old pattern>` because <reason>

## Implementation log

Append-only. After each workstream completes, one line in the same turn:

- YYYY-MM-DD: Workstream A complete. <one-line summary>
- YYYY-MM-DD: ...
