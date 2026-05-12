# Plan: <issue ref or topic>

<!--
Plans go to <repo>/.claude/plans/<topic>.md, where <repo> is the repo the work
is in (hiveplotlib, hiveplotlib-llm-wiki, etc.). Tracked in git. The plan is
the canonical reference for the work; the conversation transcript is not.

This template lives at <harness>/.claude/templates/plan-template.md.
-->

## Goal

One paragraph. What user-visible value does this deliver when it lands? What's the simplest one-sentence pitch for the change?

## Prior ADRs / design docs

Required section. The Orchestrator invokes Research Liaison at planning start to search the wiki for prior ADRs and design docs that touch the same code or design space. List relevant entries here:

- `wiki/wiki/adr/NNNN-topic.md` — one-line on why this is relevant to the current plan (e.g., "established that NetworkX is an optional dep, scope here matches that boundary")
- ...

If no prior ADRs apply (entirely new design space, or work too small to have prior history), state "None — net new design space" or "None — out of scope for ADR review."

## Patterns this replaces

Required section. List old patterns this work obsoletes:

- `<old pattern>` found at: `<file:line>`, `<file:line>`. Replace with `<new pattern>`.
- ...

If nothing is replaced, state "None, this is a net new addition."

The Orchestrator runs grep during planning to populate this. The QA Engineer runs grep again post-execution to check for survivors not in `Holdouts`.

## Default justifications

For each new user-facing default, one sentence on what the user is trying to do when they reach for this code, and why this default matches that workflow:

- `<param>=<default>`: <one-sentence justification grounded in user workflow>
- ...

If no new defaults, state "No new defaults."

## Naming audit

Required section. Check user-facing names against the vocabulary users would actually use (often borrowed from adjacent ecosystem terms):

- New parameters: `<list>`. Vs. user vocab: `<ok | amend X→Y because Z>`
- New methods/classes: `<list>`. Same check.
- Prose-only terms: `<list>`

Internal module/package names are out of scope for this audit.

## API usage examples

Required when this work adds or modifies user-facing API. The planner and the API Critic each contribute snippets so ergonomic disagreements are visible before code lands. Both views go in the plan.

### Proposed (from planner / Orchestrator)

The exact code a user will run when this work is complete, as the planner currently sees the API:

```python
# Example 1: <one-line context — what the user is trying to do>
<code>

# Example 2: <one-line context>
<code>
```

### API Critic's take (planning mode)

The API Critic writes their own snippets showing how they think the user *should* be able to call this. If they agree with the proposed form, write "Agreed" and move on. If they have concerns, show the preferred alternative with one sentence per change explaining why.

```python
# Critic's preferred form for Example 1: <reason for the difference>
<code>
```

If concerns apply across multiple examples, the critic should also note recurring patterns (e.g., "every example pushes a config dict; consider keyword arguments instead").

### API Critic — post-implementation review

Filled by the API Critic after each workstream that lands user-facing API code (including mechanical propagations of an existing surface to a sibling class — see mental-model rule 7). The dispatching session invokes api-critic in post-impl mode; the QA Engineer verifies this section is filled before declaring the workstream complete.

Until filled, leave the placeholder:

```
Pending — invoke api-critic in post-implementation mode after Workstream <X> ships.
```

Once filled, the critic writes a confidence-tagged friction list:

```
Status: clean | propose
API surface reviewed: [<class.method>, <function>, ...]
Concerns:
  - [must-fix | worth-discussing | low-confidence] <one-line concern> — at <file>:<line>
    Suggested change: <one-sentence>
```

If no user-facing API surface changes, state "No API surface change" and skip all three subsections (planning examples, planning critic, post-impl review).

## Workstreams

Break the work into named workstreams. Each is a coherent, dispatchable chunk. Don't pre-decide which agent runs each; the Orchestrator dispatches. Amendments that emerge after planning live in the "Plan amendments" section below.

### Workstream A: <name>

**Status:** not started | in progress | complete
**Files:** <list>
**Done when:** <criteria, usually "tests pass, doc renders, X behavior verified">

### Workstream B: <name>

...

## Plan amendments

Optional. Populated by the Orchestrator in amend-plan mode when post-impl critic findings or scope-changing decisions land mid-flight (see `mental-model` rule 14 for the routing). Each amendment is dated and triaged as Added workstream / In-scope tweak / Deferred follow-up — the same three buckets as rule 14's trigger taxonomy. Empty until amendments accrue.

When the section is empty, leave this placeholder in place:

```
None yet. The Orchestrator will populate this section in amend-plan mode if
emergent work surfaces (rule 14 trigger).
```

When amendments accrue, use the subsection templates below. Each amendment names the trigger (which critic finding or user ask prompted it) and is dated:

### Added workstream <letter>: <name>

**Date:** YYYY-MM-DD
**Trigger:** <which critic finding or user ask prompted this — cite the plan section or the ask>
**Status:** not started | in progress | complete
**Files:** <list>
**Done when:** <criteria>

### In-scope tweak: <one-line summary>

**Date:** YYYY-MM-DD
**Trigger:** <which critic finding or user ask prompted this>
**Workstream affected:** <letter and name>
**Change:** old → new diff sketch (a few lines, enough to make the delta concrete)

### Deferred follow-up: <one-line summary>

**Date:** YYYY-MM-DD
**Trigger:** <which critic finding or user ask prompted this>
**Target:** <next plan / next release / left intentionally>
**Rationale:** <one line on why this is deferred rather than added or tweaked in this plan>

## Holdouts

Optional. If the replace-and-sweep audit finds patterns we deliberately want to leave alone (e.g., a teaching moment in a foundations tutorial), list them here with a one-line reason each. The QA Engineer won't flag these post-execution.

- `<file:line>`: kept as `<old pattern>` because <reason>

## Implementation log

Append-only. After each workstream completes, the executing agent writes one line here in the same turn:

- YYYY-MM-DD: Workstream A complete. <one-line summary of what landed>
- YYYY-MM-DD: ...
