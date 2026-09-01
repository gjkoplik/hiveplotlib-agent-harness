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

Spec: `<path>` (signed YYYY-MM-DD), or `none` when no spec governs this plan. Written at plan creation by the orchestrator, which also transcribes the spec's call shape and failure-mode rubric into the sections below. The spec stays canonical; those copies exist so the agents reading this plan do not have to open it.

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

The ways this work could be hollow, wrong, or fake even if every test passes (a feature no user needs, a default that silently corrupts a common case, a result that is an artifact of how it was measured). The **top tier is transcribed by the orchestrator from the signed spec**, where grill-me's failure-mode wave named the modes in the maintainer's own words before the signature, so the rubric is the maintainer's standard and not the model's; the copy is one-directional and the spec stays canonical. Beneath it sits the **plan-local implementer tier**: weeds-level modes an implementer hits mid-task that no planner could have foreseen, appended here and nowhere else. That is what makes the rubric **living**, and the adversary's post-impl pass attacks the shipped artifact against both tiers.

Until it is named:

```
Not yet named. Only two branches reach this state, since a spec-governed plan whose
wave ran has the top tier transcribed at plan creation. Where that spec's
failure-mode wave was knowingly skipped, name that here in one line. Where no spec
governs this plan, no wave runs for it at any stage, so the top tier stays empty by
design; say so in one line. Implementers append the weeds-level tier beneath either
case as they hit one.
```

Once named:

```
- <failure mode, one line>: <what makes it hollow / wrong / fake>
- ...
```

An empty section and an absent rubric are different things, and the adversary reads the difference, so never leave this blank: a blank one reads as an oversight, while a named case reads as the decided cost it is. On a plan too trivial for a wave, state "Not warranted: <one-line why>".

## Prior ADRs / design docs

Populated by research-liaison at planning start. List relevant entries:

- `wiki/wiki/adr/NNNN-topic.md`: one-line on why it's relevant.
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

The snippets below are transcribed by the orchestrator from the signed spec's call shape, every fence with its `Path:` line attached, so each claimed benefit's reachability is checkable without opening the spec. The spec stays canonical: a snippet here that contradicts it is a re-sign trigger, not a plan-local override. Where no spec governs this plan, the planner authors them directly.

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

api-critic's planning mode walks the **signed spec's call shape**, at spec stage and before the signature, so on a spec-governed plan this subsection is a pointer rather than a review:

```
Ran at spec stage YYYY-MM-DD against <spec path>; surfaced at the sign-off gate.
```

Where no spec governs this plan, this is the live destination and api-critic fills it against the snippets above. `Agreed`, or preferred snippets with one-sentence reasons:

```python
# Critic's preferred form for Example 1: <reason for the difference>
<code>
```

Note recurring patterns across snippets if applicable.

### API Critic — post-implementation review

Filled by api-critic after each workstream that lands user-facing API code (including mechanical propagations to sibling classes — see mental-model rule 7). Two audits ride the block: **benefit-reachability**, whether each benefit this workstream claims is obtainable from the shipped surface through the call a user actually types, and **test-method coverage**, whether the `test_<method>_*` tests for the methods it touched call the method they name. Until filled:

```
Pending — invoke api-critic in post-implementation mode after Workstream <X> ships.
```

Once filled:

```
Status: clean | propose
API surface reviewed: [<class.method>, <function>, ...]
Concerns:
  - [must-fix | worth-discussing | low-confidence] <one-line concern> (at <file>:<line>)
    Suggested change: <one-sentence>
Benefit-reachability: <clean | findings: [<claimed benefit> - <what a user cannot obtain>, ...]>
Test-method-coverage audit: <clean | gaps: [...]>
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
  - [must-fix | worth-discussing | low-confidence] <one-line concern> (at <file>:<cell>)
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
  - [must-fix | worth-discussing | low-confidence] <one-line concern> (at <file>:<location>)
```

If the plan touches no figures, state "No figure change" and skip this section.

## Adversary review

Cold-context dissent against the plan and the artifact it ships (the structural fix for model sycophancy). Both subsections are **mandatory on every plan** (rides rule 1: a plan exists iff the work is non-trivial, which is itself the signal it deserves cold criticism). Planning mode runs **once per layer**: the spec-stage pass attacks the drafted spec before the maintainer signs it and **reports to the dispatching session** for the sign-off gate rather than writing here, since no agent edits a spec; the plan-stage pass attacks this plan before grill-me and writes `### Adversary's challenge`. The post-impl subsection is filled after the artifact ships. See `agent-harness/.claude/agents/adversary.md`.

### Adversary's challenge (planning mode)

Written by the adversary's **plan-stage** pass on a cold read of this plan, before grill-me, working approach and size-and-maintenance against the workstream set. Premise and could-this-not-exist were worked at spec stage against the signed outcome statement, and that pass reports rather than writing here. Where no spec governs this plan, and on a research plan, which has none, the plan-stage pass is the only one and works all three angles itself. Until filled:

```
Pending — invoke the adversary in planning mode (plan stage, cold, before grill-me).
```

Once filled:

```
Status: challenge (<n> items) | clean
Plan reviewed: <plan path> (plan stage, cold)
Items:
  - [must-fix | worth-discussing | low-confidence | existential-must-fix] <one-line challenge> (at <plan section>)
    Rubric: <"Failure modes" entry it maps to | "no entry — flagging anyway" | "no rubric (<research plan | no spec governs this plan | failure-mode wave knowingly skipped>)">
    Push: <the change or the question the maintainer must answer>
```

### Adversary post-impl

Filled by the adversary after each workstream ships: a fresh context attacks the shipped artifact blind first, against the workstream's done-whens and the living `## Failure modes` rubric, then reads its own planning challenge, the orchestrator's disposition of it (plan-section-as-memory), the workstream's Implementation log entry and the signed spec, and reconciles. It checks whether each disposition held or scope quietly ballooned, and re-grades the workstream's recorded spec-gate call. Where no spec governs this plan, that re-grade is out of scope and says so. Until filled:

```
Pending — invoke the adversary in post-impl mode after Workstream <X> ships.
```

Once filled:

```
Status: clean | propose
Artifact reviewed: <workstream / diff>
Dispositions held: <yes | scope ballooned: ...>
Spec-gate re-grade: <held | mismatch: ... | not recorded | n/a (no spec governs this plan)>
Concerns:
  - [must-fix | worth-discussing | low-confidence] <one-line concern> (at <file>:<line>)
    Rubric: <"Failure modes" entry, or "no entry">
```

## Workstreams

Coherent, dispatchable chunks with checkable done-when criteria. Don't pre-assign agents.

Multiple workstreams may dispatch concurrently. In-tree state from a co-running workstream is expected, not broken. When the state genuinely doesn't match the brief, halt under rule 9.

**Section ownership (this file has many writers).** Each agent writes only its own named section(s): critics their review blocks, the adversary its two subsections, implementers their Implementation log line and any `## Failure modes` implementer-tier append, the orchestrator the rest (`## Not yet plannable` included, and the spec-derived lines: `## Goal`'s `Spec:` line, the transcribed call shape under `## API usage examples`, and the transcribed top tier of `## Failure modes`). `## Maintainer questionnaire` items are appendable by any implementing agent with Edit; editorial-critic and viz-critic, which carry no Edit, record items through the same recording hop their review blocks already use; transcribing the maintainer's answer on close belongs to the agent running the amendment. Never rewrite another agent's section. The dispatching session avoids concurrently dispatching two agents that write the same section, and serializes Implementation-log appends when workstreams run concurrently.

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

Append-only. After each workstream completes, one line in the same turn: what shipped, the workstream's **consumption figures** (the plan-end aggregate reads them from here rather than from reconstructed chat), and the **pre-dispatch spec-gate post** with its match call and a one-line rationale (the post-impl spec-gate re-grade reads that call off this entry, and prints `not recorded` when it is absent). Where no spec governs this plan, that last clause reads `n/a (no spec governs this plan)`.

- YYYY-MM-DD: Workstream A complete. <one-line summary>. Consumption: <n> agents, peak concurrency <n>, token total <n | unknown (<basis>)>. Spec gate: <what the post claimed a user types and gets>; <match | mismatch: ...>; <rationale>.
- YYYY-MM-DD: ...

---

# Research-plan shape (the `research-plan` orchestrator mode emits this, NOT the sections above)

A research task (research **for** a consumer, landing in that consumer's durable records) uses this shape instead of the code-plan structure above. It is **deliberately light**: no workstream-style done-when ceremony, no replace-and-sweep / naming / API-usage audits. That lightness is a design choice, not an omission. Workstream-style done-whens suit code; imposed on research they **strangle the divergence** the run needs to explore. A future editor should not "fix" this by adding ceremony. Conventions (shallow-panel dispatch, the two standing lenses, bounds, grounding, durable landing) live in the `research-track` skill, not here; this shape carries only the per-plan fill-in.

The mandatory-adversary sections (`## Adversary review`, both subsections) and grill-me's failure-mode wave (its research branch, still post-plan, landing in `## Failure-mode rubric` below) apply to this shape too. The shared spine covers research; they are not code-plan-only.

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

`wiki/wiki/analyses/<slug>.md` for a validated finding or validated inconclusive on a consumer with a wiki, landed via research-liaison's producer path under maintainer approval; a minimal breadcrumb for a nothing-cohered run. On a wiki-less consumer, name the destination explicitly per the `research-track` skill's landing conventions rather than assuming a page.

## Minor pivots vs. amend-plan

Iteration lives **inside** the bounded run: minor pivots (refining a lens, dropping a dead angle) do not force an amend-plan. Only a **fundamental change of the research question** mid-run is an amend-plan. The mode is a minimal frame so exploration is not gated per pivot.
