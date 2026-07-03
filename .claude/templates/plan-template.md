# Plan: <issue ref or topic>

<!--
Hiveplotlib and wiki-structure plans go to wiki/wiki/plans/<topic>.md (tracked
in the wiki submodule). Harness-self plans go to agent-harness/.claude/plans/
<topic>.md (gitignored). New plans start in plans/; once the work ships, wiki
plans move to plans/archived/<topic>.md (see plans/README.md). The plan is the
canonical reference; the conversation transcript is not. Keep it concise per
mental-model rule 17 (plans shape).
-->

## Goal

One paragraph. What user-visible value lands when this ships?

## Alignment (grill)

Maintainer alignment pass on the plan's premise and decisions, run via the `grill-me` skill before any workstream dispatches. Recommended for major or long plans, and for any plan dense enough that the reasoning lives in the maintainer's head rather than fully on the page. The dispatching session runs it inline and records each wave here. The maintainer may knowingly skip it.

Until run:

```
Not yet run — recommended before dispatch for major plans. Run the grill-me skill
or knowingly skip; record each wave below. Route any resulting plan change to
amend-plan (rule 14).
```

Once run, a status line plus dated `Maintainer shared-understanding pass (grill), Wave N — <topics>` entries (confirmed positions, clarifications, and OPEN items stated plainly):

```
Status: aligned (N waves, YYYY-MM-DD) | open decisions pending
Open decisions: <list, or none>
```

Captures are record-only; resulting plan changes route to amend-plan. If the plan is trivial enough not to warrant a grill, state "Not warranted — <one-line why>" and skip.

## Failure modes

The ways this work could be hollow, wrong, or fake even if every test passes (a feature no user needs, a default that silently corrupts a common case, a result that is an artifact of how it was measured). Seeded by grill-me's failure-mode wave (the maintainer names them, in their words), so the rubric is the maintainer's standard, not the model's. This rubric is **living**: seeded here at planning, appended by implementers when they hit a weeds-level mode mid-task, and consumed by the adversary (its post-grill rubric-check maps the plan against these modes; its post-impl pass attacks the shipped artifact against them).

Until the wave runs:

```
Not yet named — grill-me's failure-mode wave populates this. Each mode one line,
in the maintainer's words.
```

Once named:

```
- <failure mode, one line>: <what makes it hollow / wrong / fake>
- ...
```

If the plan is trivial enough not to warrant a grill, state "Not warranted — <one-line why>" and skip (the same call as the grill itself).

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

## Adversary review

Cold-context dissent against the plan and the artifact it ships (the structural fix for model sycophancy). Both subsections are **mandatory on every plan** (rides rule 1: a plan exists iff the work is non-trivial, which is itself the signal it deserves cold criticism). The challenge is written by the adversary in planning mode, before grill-me; the post-impl section after the artifact ships. See `agent-harness/.claude/agents/adversary.md`.

### Adversary's challenge (planning mode)

Written by the adversary on a cold read of this plan, before grill-me, working the three mandated angles (premise, approach, size-and-maintenance / could-this-not-exist). A light conditional post-grill rubric-check may append to it after the failure-mode wave names the modes. Until filled:

```
Pending — invoke the adversary in planning mode (cold, before grill-me).
```

Once filled:

```
Status: challenge (<n> items) | clean | clean — no new modes to check
Plan reviewed: <plan path> (cold | cold, post-grill rubric-check)
Items:
  - [must-fix | worth-discussing | low-confidence | existential-must-fix] <one-line challenge> — at <plan section>
    Rubric: <"Failure modes" entry it maps to | "no entry — flagging anyway" | "no rubric yet — pre-grill">
    Push: <the change or the question the maintainer must answer>
```

### Adversary post-impl

Filled by the adversary after each workstream ships: a fresh context reads its own planning challenge plus the orchestrator's disposition (plan-section-as-memory) and attacks the shipped artifact against the living `## Failure modes` rubric, checking whether each disposition held or scope quietly ballooned. Until filled:

```
Pending — invoke the adversary in post-impl mode after Workstream <X> ships.
```

Once filled:

```
Status: clean | propose
Artifact reviewed: <workstream / diff>
Dispositions held: <yes | scope ballooned: ...>
Concerns:
  - [must-fix | worth-discussing | low-confidence] <one-line concern> — at <file>:<line>
    Rubric: <"Failure modes" entry, or "no entry">
```

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

Populated by orchestrator in `amend-plan` mode when rule 14 triggers (post-impl critic `must-fix`/`should-fix`, or a scope-changing user ask). Three subsections matching rule 14's trigger taxonomy. Append-only; empty until amendments accrue. Each entry concise per rule 17 (amendments shape).

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
