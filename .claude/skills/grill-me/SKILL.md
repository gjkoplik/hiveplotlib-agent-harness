---
name: grill-me
description: Run a Socratic alignment pass over a plan or task before dispatch, to surface tacit intent and divergence between the artifact-as-written and the maintainer's actual judgment. The dispatching session runs this inline (not a sub-agent), interrogating the maintainer wave by wave, high level to low, and accepting being grilled back. Use before sending the harness off on a long-horizon or autonomous workflow, when reviewing an existing plan in `wiki/wiki/plans/`, when the maintainer says "grill me" / "let's align on this" / "stress-test this plan" / "am I missing anything", or any time intent is consequential and only partly written down. The point is confirmed alignment, not a quiz.
type: skill
---

# Grill Me

An alignment gate. The maintainer answers pointed questions about a plan or task so the reasoning that lives in their head (and in a dense plan document) becomes explicit shared understanding before any agent is dispatched. This is the cheapest place to catch a misalignment: before the workstreams run, not after a critic reviews the output.

## What it is and isn't

The artifact critics (`api-critic`, `editorial-critic`, `viz-critic`) review **artifacts that exist**. Grill-me reviews **intent**, before or around the artifact. It catches the failures they structurally cannot: a shipped API default the maintainer was "letting slide", a load-bearing premise nobody wrote down, a conflation making a decision feel harder than it is, a deliverable that was assumed but never planned.

It is run **inline by the dispatching session**, like `mental-model`, not as a sub-agent. The conversation is stateful across many turns (waves); a sub-agent would lose that and lose the human in the loop.

## Method

1. **Read first, then grill.** Read the target plan (`wiki/wiki/plans/<topic>.md`) or the task brief in full, and skim the code it names. Grill from the full picture, not half of it.
2. **Pre-fill your read.** Where the plan or code already settles a question, state your answer and ask the maintainer to confirm or correct. Do not quiz them on things already written down. This is the repo-aware + recommended-answer discipline; it keeps the grill on genuine forks and respects the maintainer's time.
3. **Waves, high to low.** Wave 1: premise, scope, the irreversible commitments (core deps, public API defaults). Later waves: subtle correctness claims, the memory/perf model, the things most likely to bite. Keep each wave small (roughly 3-5, then 2-4, then 1-3 questions). Each wave's answers steer the next; don't dump everything at once.
4. **Target the high-leverage forks.** The load-bearing "why now" premise; scope ambition (ship-all vs ship-the-core); anything close to irreversible (a core dependency, a public default that needs a deprecation to change); the subtlest correctness risk in the chain; and anything the maintainer admits to skimming.
5. **Accept being grilled back.** When the maintainer pushes, find the real argument or concede. Update toward them when they are right. The goal is alignment, not winning the point. A grill that only ever ratifies the plan did nothing.

## Capture (keep the record in one place)

After each wave resolves, append a dated entry to the plan's `## Alignment (grill)` section, titled `Maintainer shared-understanding pass (grill), Wave N — <topics>`. Record the confirmed positions, the clarifications, and any **OPEN** items with the divergence stated plainly (do not fabricate consensus). This fills the plan's pre-dispatch alignment gate and turns "what the maintainer actually thinks" from implicit into durable. (Plans predating the `## Alignment (grill)` section may carry their captures under `## Plan amendments`; new plans use the dedicated gate.)

Capture is **record-only**. Do not edit workstream done-whens, naming audits, or default justifications from the grill. A resulting plan *change* is emergent work, routed to orchestrator `amend-plan` (which populates `## Plan amendments`), never hand-edited from the grill.

## Routing emergent change

A grill commonly surfaces a real change: a flipped or removed API decision, a new deliverable, a scope shift. That is emergent work. Per `mental-model` rule 14, route it to the orchestrator's `amend-plan` mode rather than hand-editing the workstream set. The grill records the decision and recommends the routing; the orchestrator (with the api-critic where the surface changes) makes the edit. Mark the item OPEN in the capture until the maintainer gives the final call, then bundle the amend-plan dispatch.

## Voice

Follow the maintainer's prose rules: no em-dashes, no AI filler, direct and slightly informal. One sharp question per genuine fork, with your pre-filled read attached. Not interrogation theater, every question should be one whose answer changes what happens next.

## Stopping

Stop when a wave stops surfacing divergence, or the maintainer signals they are aligned. Then state the open decisions still on them, and name the next dispatch (orchestrator `initial-plan` / `amend-plan`, or the first workstream). Offer, do not assume, the next step.
