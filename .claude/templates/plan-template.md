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

Brief-mode gate: <ran (interview record folded into Goal/non-goals above) | knowingly skipped>. One line, written at plan creation from the dispatch brief, so the gate outcome survives the conversation transcript.

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
Delivery shape: single MR | sliced MRs with named slice boundaries
```

Captures are record-only; resulting plan changes route to amend-plan. The `Delivery shape:` line records the grill's call on whether the work ships as one MR or as sliced MRs under a milestone; when the grill is skipped or silent on it, the default is a single MR. If the plan is trivial enough not to warrant a grill, state "Not warranted: <one-line why>" and skip.

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

If the plan is trivial enough not to warrant a grill, state "Not warranted: <one-line why>" and skip (the same call as the grill itself).

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

Names settled here are the shared vocabulary later sessions must reuse. Internal module/package names are out of scope.

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

## Viz review

Filled by viz-critic after each workstream that produces or changes a figure (rendered figures and notebook viz cells, reviewed against the viz-quality-bar skill). Until filled:

```
Pending — invoke viz-critic in post-implementation mode after Workstream <X> ships.
```

Once filled:

```
Status: clean | propose
Figures reviewed: [<file>:<cell> or <file>:<line>, ...]
Polish budget: [showcase | instructional | HPM] per figure
Concerns:
  - [must-fix | worth-discussing | low-confidence] <one-line concern> — at <file>:<location>
```

If the plan touches no figures, state "No figure change" and skip this section.

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

Filled by the adversary after each workstream ships: a fresh context attacks the shipped artifact blind first, against the workstream's done-whens and the living `## Failure modes` rubric, then reads its own planning challenge plus the orchestrator's disposition (plan-section-as-memory) and reconciles, checking whether each disposition held or scope quietly ballooned. Until filled:

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

**Section ownership (this file has many writers).** Each agent writes only its own named section(s): critics their review blocks, the adversary its two subsections, implementers their Implementation log line and any `## Failure modes` append, the orchestrator the rest (`## Not yet plannable` included). `## Maintainer questionnaire` items are appendable by any implementing agent with Edit; editorial-critic and viz-critic, which carry no Edit, record items through the same recording hop their review blocks already use; transcribing the maintainer's answer on close belongs to the agent running the amendment. Never rewrite another agent's section. The dispatching session avoids concurrently dispatching two agents that write the same section, and serializes Implementation-log appends when workstreams run concurrently.

### Workstream A: <name>

**Status:** not started | in progress | complete
**Files:** <list>
**Done when:** <criteria>

### Workstream B: <name>

...

## Not yet plannable

Work the plan can see but cannot spec yet. Entries are commitment markers: deliberately fuzzy and less committed than a workstream. An executing agent that reaches one realigns first (amend-plan, or the maintainer directly) rather than acting on it as written.

Entry gate: in if the question cannot be stated precisely yet, with a note on what would clear it; out if statable (statable questions belong in a grill or an open-decisions list). The section also lets a plan scope short on purpose and record what was left uncharted.

- <item>: <what is unclear, and what would clear it>

Or "None." (the common case).

## Maintainer questionnaire

Parked maintainer gates in decision-ticket shape. Any agent may append an item when a decision needs the maintainer and the maintainer is not present (a gate parked mid-run or at review). Items are numbered; each states its context and leads with a recommended answer, so a one-word reply can close it.

Close mechanics: the maintainer answers in chat; the agent running the amendment transcribes the answer into the item on close, and the answer is never edited after. The maintainer never edits the plan file; the section accrues an append-only decision log.

```
1. <decision needed, one line>
   Context: <what the decision gates, one or two lines>
   Recommended answer: <the recommendation, stated first>
   Answer (on close): <transcribed from the maintainer's chat reply; never edited after>
```

Or "None."

## Plan amendments

Populated by orchestrator in `amend-plan` mode when rule 14 triggers (post-impl critic `must-fix`/`worth-discussing`, or a scope-changing user ask). Three subsections matching the orchestrator's amendment triage (Added workstream / In-scope tweak / Deferred follow-up). Append-only; empty until amendments accrue. Each entry concise per rule 17 (amendments shape).

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

---

# Research-plan shape (the `research-plan` orchestrator mode emits this, NOT the sections above)

A research task (research **for** a consumer, landing in that consumer's wiki `analyses/`) uses this shape instead of the code-plan structure above. It is **deliberately light**: no workstream-style done-when ceremony, no replace-and-sweep / naming / API-usage audits. That lightness is a design choice, not an omission. Workstream-style done-whens suit code; imposed on research they **strangle the divergence** the run needs to explore. A future editor should not "fix" this by adding ceremony. Conventions (shallow-panel dispatch, the two standing lenses, bounds, grounding, durable landing) live in the `research-track` skill, not here; this shape carries only the per-plan fill-in.

The mandatory-adversary sections (`## Adversary review`, both subsections) and grill-me's failure-mode wave (`## Failure modes`, its research branch) apply to this shape too. The shared spine covers research; they are not code-plan-only.

## Question

The refined research question. One or two sentences.

## Candidate stories / hypotheses

The competing explanations the run weighs (e.g. "the two-cluster structure is real" vs. "it is a layout artifact"). A short list.

## Failure-mode rubric

Populated by grill-me's failure-mode wave (research branch): the domain failure modes for this question, structure-is-artifact first, then already-known / n-too-small / uncontrolled-comparison / grounding failures. Named as the *kinds* of modes to elicit, not a fixed checklist. Consumed by the adversary at convergence.

## Lenses + bounds

The N disjoint lenses the run fires, and the run's bounds: the **binding pre-flight estimate** (exceeded only by surfacing a revised estimate first) and the **concurrency ceiling of 8**. Two lenses are **standing seats floored on every run** before the orthogonality count fills the rest (they are obligations, not optional angles):

- a **prior-art / counterfactual lens** ("how do people normally do this, what are the alternatives, has anyone already published this"),
- a **counter-evidence lens** (searches for what would falsify the emerging story).

The remaining N−2 are set by orthogonality (genuinely disjoint slices), counted in the pre-flight estimate. See the `research-track` skill for the shallow-panel dispatch and the addable agent-count model the estimate derives from.

## Validation criteria

What a validated finding must clear (grounded, independently verified, adversary-convergence-cleared). The run classifies its terminal outcome honestly into **one of three legitimate outcomes** (a validated-inconclusive and a nothing-cohered are terminal verdicts, not failed runs):

- **validated finding**: a confident, grounded conclusion; lands the full page.
- **validated inconclusive**: pursued to a negative ("the evidence does not support a confident answer"); a first-class outcome that still lands the full page as a "do not re-research this dead end" reference.
- **nothing-cohered**: the degenerate low-yield case, the panel ran but nothing of interest cohered, distinct from inconclusive (a positive determination). Lands only a minimal breadcrumb (ran-this / nothing-cohered / consumption reported), never a thin finding-shaped page.

## Destination artifact

`wiki/wiki/analyses/<slug>.md` for a validated finding or validated inconclusive; a minimal breadcrumb for a nothing-cohered run. Landed via research-liaison's producer path under maintainer approval.

## Minor pivots vs. amend-plan

Iteration lives **inside** the bounded run: minor pivots (refining a lens, dropping a dead angle) do not force an amend-plan. Only a **fundamental change of the research question** mid-run is an amend-plan. The mode is a minimal frame so exploration is not gated per pivot.
