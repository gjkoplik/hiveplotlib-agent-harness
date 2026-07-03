---
name: grill-me
description: Socratic passes the dispatching session runs inline (not a sub-agent), in two modes. Brief mode is pre-plan extraction, run BEFORE the orchestrator is invoked when a non-trivial brief underdetermines plan-shaping choices, interviewing the maintainer one question at a time; its record sharpens the orchestrator's brief and lands in the plan's Goal/non-goals. The post-plan grill is the alignment gate, interrogating the maintainer wave by wave, high level to low, over a written plan or task, accepting being grilled back, and running the failure-mode-elicitation wave. Use brief mode when the maintainer invokes it or the dispatching session offers it on an underdetermined brief (a surfaced gate, on every non-trivial brief name that it ran or was knowingly skipped). Use the post-plan grill before sending the harness off on a long-horizon or autonomous workflow, when reviewing an existing plan in `wiki/wiki/plans/`, when the maintainer says "grill me" / "let's align on this" / "stress-test this plan" / "am I missing anything", or any time intent is consequential and only partly written down. The point is confirmed alignment, not a quiz.
type: skill
---

# Grill Me

Two Socratic jobs, deliberately disentangled into two modes:

- **Brief mode** is *extraction*. It runs **before the orchestrator is invoked**, when a non-trivial brief underdetermines plan-shaping choices. There is no plan yet to review; the interview pulls the missing intent out of the maintainer's head so the orchestrator plans from a sharp brief instead of guessing. Its record lands in the orchestrator's brief and, from there, the plan's Goal/non-goals.
- **The post-plan grill** is *alignment*. The maintainer answers pointed questions about a written plan so the reasoning that lives in their head (and in a dense plan document) becomes explicit shared understanding before any agent is dispatched. It keeps the failure-mode wave, which stays post-plan by necessity: naming failure modes requires a concrete plan to name them against. Its record lands in the plan's `## Alignment (grill)` section (failure-mode wave excepted, see below).

Each mode is the cheapest place to catch its failure: brief mode before the plan is shaped, the grill before the workstreams run.

## What it is and isn't

The artifact critics (`api-critic`, `editorial-critic`, `viz-critic`) review **artifacts that exist**. Grill-me reviews **intent**: brief mode before any artifact exists, the post-plan grill around the plan artifact. It catches the failures they structurally cannot: a shipped API default the maintainer was "letting slide", a load-bearing premise nobody wrote down, a conflation making a decision feel harder than it is, a deliverable that was assumed but never planned.

Both modes are run **inline by the dispatching session**, like `mental-model`, not as a sub-agent. The conversation is stateful across many turns; a sub-agent would lose that and lose the human in the loop.

The `adversary`'s cold pre-grill challenge runs **before** the post-plan grill (`agent-harness/.claude/agents/adversary.md`): the grill is meant to interrogate the adversary's items, not re-derive them, and the adversary's light conditional post-grill rubric-check follows the failure-mode wave below. Brief mode sits earlier still: its interview record is an input the adversary's cold premise attack reads when one exists, so extracted intent gets challenged rather than treated as settled.

## Brief mode (pre-plan extraction interview)

**When.** Before the orchestrator is invoked, on a non-trivial brief that underdetermines plan-shaping choices (scope ambition, the deliverable set, a fork the orchestrator would otherwise settle by default). Maintainer-invoked, or offered by the dispatching session. The offer is a **surfaced gate** like the grill gate: on every non-trivial brief the dispatching session names that brief mode ran or was knowingly skipped, so a silent non-offer is visible after the fact. The gate outcome is also recorded as a line in the plan's `## Goal` at plan creation (the orchestrator writes it from the dispatch brief), so the record survives the conversation transcript. The "looks underdetermined" judgment stays with the dispatching session, not a checklist.

**Ordering.** Brief-mode interview first, then research-liaison pre-task, then orchestrator: extraction sharpens what the liaison searches for. If planning judgment prefers another order for a given task, record why.

**Method.** An interview, not a review; there is no plan yet.

1. **One question at a time.** Each answer steers the next question. No wave batching (waves are the post-plan grill's shape, sized for reviewing a document; extraction works fork by fork).
2. **Ask only what the brief underdetermines.** Where the brief already settles a question, don't ask it. Pre-fill your read where a partial answer exists and ask the maintainer to confirm or correct.
3. **Target plan-shaping forks.** Scope ambition (ship-all vs ship-the-core), what is explicitly out, the deliverable the maintainer is assuming but has not written, anything the orchestrator would otherwise decide by default.
4. **Stop** when the brief determines the plan-shaping choices, or the maintainer signals enough.

**Record.** The interview's answers go into the orchestrator's dispatch brief (the dispatching session includes them in the `initial-plan` brief) and land in the plan's Goal/non-goals. That is the interview record the adversary's cold pre-grill premise attack reads when present.

## The post-plan grill (alignment gate)

The remaining sections describe this mode.

### Method

1. **Read first, then grill.** Read the target plan (`wiki/wiki/plans/<topic>.md`) or the task brief in full, and skim the code it names. Grill from the full picture, not half of it.
2. **Pre-fill your read.** Where the plan or code already settles a question, state your answer and ask the maintainer to confirm or correct. Do not quiz them on things already written down. This is the repo-aware + recommended-answer discipline; it keeps the grill on genuine forks and respects the maintainer's time.
3. **Waves, high to low.** Wave 1: premise, scope, the irreversible commitments (core deps, public API defaults). Later waves: subtle correctness claims, the memory/perf model, the things most likely to bite. Keep each wave small (roughly 3-5, then 2-4, then 1-3 questions). Each wave's answers steer the next; don't dump everything at once.
4. **Target the high-leverage forks.** The load-bearing "why now" premise; scope ambition (ship-all vs ship-the-core); anything close to irreversible (a core dependency, a public default that needs a deprecation to change); the subtlest correctness risk in the chain; and anything the maintainer admits to skimming.
5. **Accept being grilled back.** When the maintainer pushes, find the real argument or concede. Update toward them when they are right. The goal is alignment, not winning the point. A grill that only ever ratifies the plan did nothing.

### Failure-mode wave

After the high-to-low waves resolve, run a dedicated **failure-mode-elicitation wave**: force the maintainer to name what would make this work hollow, wrong, or fake. Not "what could go wrong in implementation" (the correctness waves cover that), but "what would make the shipped thing a failure even if every test passes": a feature that solves a problem no user has, an answer that looks rigorous but rests on an unevidenced premise, a result that is an artifact of how it was measured rather than a real finding. The maintainer names these; a model-authored list reproduces the model's blind spots, which is the whole failure this wave exists to fix.

Tailor the prompt to the plan at hand. A code plan's modes are things like "ships surface no one asked for," "a default that silently corrupts a common case," "duplicates an existing path." Elicit the modes appropriate to *this* plan; do not import a fixed checklist.

**On a research plan**, the wave elicits the *domain* failure modes a finding can fall into. Lead with **structure-is-artifact**: the apparent structure is an artifact of how it was drawn or measured, not a real finding (the maintainer's Datasaurus result is the concrete case: identical degree sequence, different apparent structures, so a two-cluster look can survive nothing but the layout). Then the surrounding kinds: **already-known** (the finding reinvents or restates a published result), **n-too-small** (the conclusion rests on too few observations to hold), **uncontrolled-comparison** (a difference is claimed against no controlled baseline), and **grounding failures** (a claim with no source; a voucher who is the claim-maker). These are the *kinds* to elicit for a research plan, still in the maintainer's words and still not a fixed checklist; a given research plan surfaces its own.

Capture the named modes into the plan's new `## Failure modes` subsection (one line per mode, in the maintainer's words). The rubric this wave seeds is **living**, with three lifecycle points:

1. **Seeded here, at planning**, by this wave.
2. **Appended by implementers** when they hit a weeds-level failure mode mid-task that the planner could not have foreseen.
3. **Consumed by the adversary** at both ends: its post-grill rubric-check maps the plan against the modes this wave just named, and its post-impl pass attacks the shipped artifact against the living rubric.

This wave is what makes the adversary's light post-grill rubric-check possible. The sequencing: the adversary's **cold pre-grill challenge** runs first (rubric-free, since the modes are not named yet) → this wave names the failure modes → the adversary does a **light conditional post-grill rubric-check**, a delta-check of the plan against the newly-named modes only (skipped when the cold pass already covered them) → dispatch. Before this wave runs there is no rubric to check against, so the cold pre-grill pass cannot depend on one. See `agent-harness/.claude/agents/adversary.md`.

Like the rest of the grill, this wave is **record-only**: it names the modes into the plan, it does not act on them. A mode that implies a plan change is emergent work, routed to orchestrator `amend-plan`, never hand-edited from the grill.

### Capture (keep the record in one place)

After each wave resolves, append a dated entry to the plan's `## Alignment (grill)` section, titled `Maintainer shared-understanding pass (grill), Wave N — <topics>`. Record the confirmed positions, the clarifications, and any **OPEN** items with the divergence stated plainly (do not fabricate consensus). This fills the plan's pre-dispatch alignment gate and turns "what the maintainer actually thinks" from implicit into durable. (Plans predating the `## Alignment (grill)` section may carry their captures under `## Plan amendments`; new plans use the dedicated gate.)

The failure-mode wave is the exception to the destination: its named modes go into the plan's `## Failure modes` subsection (where the adversary reads them), not under `## Alignment (grill)`. Note in the alignment capture that the wave ran and point to the `## Failure modes` subsection it filled.

Capture is **record-only**. Do not edit workstream done-whens, naming audits, or default justifications from the grill. A resulting plan *change* is emergent work, routed to orchestrator `amend-plan` (which populates `## Plan amendments`), never hand-edited from the grill.

### Routing emergent change

A grill commonly surfaces a real change: a flipped or removed API decision, a new deliverable, a scope shift. That is emergent work. Per `mental-model` rule 14, route it to the orchestrator's `amend-plan` mode rather than hand-editing the workstream set. The grill records the decision and recommends the routing; the orchestrator (with the api-critic where the surface changes) makes the edit. Mark the item OPEN in the capture until the maintainer gives the final call, then bundle the amend-plan dispatch.

## Voice (both modes)

Follow the maintainer's prose rules: no em-dashes, no AI filler, direct and slightly informal. One sharp question per genuine fork, with your pre-filled read attached. Not interrogation theater, every question should be one whose answer changes what happens next.

## Stopping (post-plan grill)

Stop when a wave stops surfacing divergence, or the maintainer signals they are aligned. Then state the open decisions still on them, and name the next dispatch (orchestrator `initial-plan` / `amend-plan`, or the first workstream). Offer, do not assume, the next step. (Brief mode's stopping condition is in its Method above.)
