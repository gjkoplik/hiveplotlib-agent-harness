---
name: grill-me
description: Socratic passes the dispatching session runs inline (not a sub-agent), in two modes plus the failure-mode wave that runs between them. Brief mode is pre-spec extraction, run BEFORE the spec is drafted when a non-trivial brief underdetermines plan-shaping choices, interviewing the maintainer one question at a time; its record is the spec transcribed from it. The failure-mode wave runs at spec stage, once the spec is drafted and before the maintainer signs it, naming the modes into the spec's `## Failure modes` (the research branch is unchanged and still post-plan). The post-plan grill is the alignment gate, interrogating the maintainer wave by wave, high level to low, over a written plan or task, accepting being grilled back, and settling the plan's delivery shape before dispatch. Use brief mode when the maintainer invokes it or the dispatching session offers it on an underdetermined brief (a surfaced gate, on every non-trivial brief name that it ran or was knowingly skipped). Use the post-plan grill before sending the harness off on a long-horizon or autonomous workflow, when reviewing an existing plan in `wiki/wiki/plans/`, when the maintainer says "grill me" / "let's align on this" / "stress-test this plan" / "am I missing anything", or any time intent is consequential and only partly written down. Open decisions that cannot be grilled live park in the plan's maintainer-questionnaire section (defined template-side; this skill points at it). The point is confirmed alignment, not a quiz.
type: skill
---

# Grill Me

Two Socratic modes, deliberately disentangled, and the failure-mode wave that runs between them:

- **Brief mode** is *extraction*. It runs **before the spec is drafted**, when a non-trivial brief underdetermines plan-shaping choices. There is no artifact yet to review; the interview pulls the missing intent out of the maintainer's head, and the spec is transcribed from it. Its record is that spec.
- **The failure-mode wave** is *elicitation*, run at **spec stage**: once the spec is drafted, before the maintainer signs it. The modes it exists for are the maintainer-named, outcome-level ones, and those are nameable against a stated outcome with no plan to name them against. The implementer-level modes that do need a plan arrive later, through the living rubric's append path below.
- **The post-plan grill** is *alignment*. The maintainer answers pointed questions about a written plan so the reasoning that lives in their head (and in a dense plan document) becomes explicit shared understanding before any agent is dispatched. It carries the interrogation waves and the delivery-shape decision, and its record lands in the plan's `## Alignment (grill)` section.

Each is the cheapest place to catch its failure: brief mode before the spec is drafted, the wave before it is signed, the grill before the workstreams run.

## What it is and isn't

The artifact critics (`api-critic`, `editorial-critic`, `viz-critic`) review **artifacts that exist**. Grill-me reviews **intent**: brief mode before any artifact exists, the failure-mode wave around the drafted spec, the post-plan grill around the plan artifact. It catches the failures they structurally cannot: a shipped API default the maintainer was "letting slide", a load-bearing premise nobody wrote down, a conflation making a decision feel harder than it is, a deliverable that was assumed but never planned.

Every pass is run **inline by the dispatching session**, like `mental-model`, not as a sub-agent. The conversation is stateful across many turns; a sub-agent would lose that and lose the human in the loop.

The `adversary` gets one pass per layer, both rubric-aware (`agent-harness/.claude/agents/adversary.md`). Its **spec-stage** pass attacks the drafted spec, after the failure-mode wave and before the maintainer signs, so extracted intent gets challenged rather than treated as settled. Its **plan-stage** pass runs **before** the post-plan grill, so the grill interrogates the adversary's items instead of re-deriving them.

## Brief mode (pre-spec extraction interview)

**When.** Before the spec is drafted, on a non-trivial brief that underdetermines plan-shaping choices (scope ambition, the deliverable set, a fork the drafter would otherwise settle by default). Maintainer-invoked, or offered by the dispatching session. The offer is a **surfaced gate** like the grill gate: on every non-trivial brief the dispatching session names that brief mode ran or was knowingly skipped, so a silent non-offer is visible after the fact. The gate outcome is also recorded on the spec, as one line in its `## Sign-off` section above the append-only fence, so the record survives the conversation transcript and the signer sees how the intent was extracted. The "looks underdetermined" judgment stays with the dispatching session, not a checklist.

**Ordering.** Brief-mode interview first, then research-liaison pre-task, then the spec draft: extraction sharpens what the liaison searches for, and the liaison's findings reach the spec. If planning judgment prefers another order for a given task, record why.

**Method.** An interview, not a review; there is no plan yet.

1. **One question at a time.** Each answer steers the next question. No wave batching (waves are the post-plan grill's shape, sized for reviewing a document; extraction works fork by fork).
2. **Ask only what the brief underdetermines.** Where the brief already settles a question, don't ask it. Every question you do ask leads with a recommended answer; the maintainer confirms or corrects rather than composing an answer from scratch.
3. **Target plan-shaping forks.** Scope ambition (ship-all vs ship-the-core), what is explicitly out, the deliverable the maintainer is assuming but has not written, anything the drafter would otherwise settle by default.
4. **Stop** when the brief determines the plan-shaping choices, or the maintainer signals enough.

**Record.** The interview's answers are transcribed into the spec (`wiki/wiki/specs/<topic>.md`, or `agent-harness/.claude/specs/<topic>.md` for harness-self work): the outcome statement, the call shape, what is out of scope. The maintainer answers, an agent writes, and that drafted spec is the interview record every later pass reads, starting with the failure-mode wave below.

## Failure-mode wave (spec stage)

Once the spec is drafted and before the maintainer signs it, run a dedicated **failure-mode-elicitation wave**: force the maintainer to name what would make this work hollow, wrong, or fake. Not "what could go wrong in implementation" (the post-plan grill's correctness waves cover that), but "what would make the shipped thing a failure even if every test passes": a feature that solves a problem no user has, an answer that looks rigorous but rests on an unevidenced premise, a result that is an artifact of how it was measured rather than a real finding. The maintainer names these; a model-authored list reproduces the model's blind spots, which is the whole failure this wave exists to fix.

Tailor the prompt to the spec at hand. A code spec's modes are things like "ships surface no one asked for," "a default that silently corrupts a common case," "duplicates an existing path," "lands reachable only from an entry point users are being steered away from." The spec carries a `Path:` line per call-shape snippet, which makes that last kind cheap to elicit: ask, for each claimed benefit, which call a user actually types to reach it, and whether that is a call they would ever be told to type. Elicit the modes appropriate to *this* spec; do not import a fixed checklist.

The wave runs **before** the spec-stage adversary, not after it: a rubric-free spec pass would push the two-invocation problem up a layer instead of removing it, since the adversary would need a second read once the modes exist. The adversary-first ordering this appears to violate belongs to the interrogation waves, which have adversary items to interrogate; this wave is maintainer-led elicitation and has none.

**On a code plan no spec governs** the wave runs at neither point. It belongs to the spec stage and there is no spec for it to run against, and the post-plan slot is the research shape's, so that plan's `## Failure modes` stays empty by design rather than by oversight, and the implementer tier beneath it is the only tier it gets. Nothing records the absence and no field is added for it; the adversary reads the empty rubric directly and says which branch it is on.

**On a research plan** the wave is unchanged and still runs **post-plan**, since a research run has no spec: it sits inside the post-plan grill, after the high-to-low interrogation waves resolve and before the grill closes. It elicits the *domain* failure modes a finding can fall into. Lead with **structure-is-artifact**: the apparent structure is an artifact of how it was drawn or measured, not a real finding (the maintainer's Datasaurus result is the concrete case: identical degree sequence, different apparent structures, so a two-cluster look can survive nothing but the layout). Then the surrounding kinds: **already-known** (the finding reinvents or restates a published result), **n-too-small** (the conclusion rests on too few observations to hold), **uncontrolled-comparison** (a difference is claimed against no controlled baseline), and **grounding failures** (a claim with no source; a voucher who is the claim-maker). These are the *kinds* to elicit for a research plan, still in the maintainer's words and still not a fixed checklist; a given research plan surfaces its own.

Capture the named modes into the spec's `## Failure modes` section (one line per mode, in the maintainer's words); on a research plan they go into the research plan's `## Failure-mode rubric`, as before. Whether the wave ran or was knowingly skipped rides the spec's `## Sign-off` line next to the brief-mode gate outcome (on a research plan, the `## Alignment (grill)` capture carries it), since an empty rubric cannot distinguish a wave that never ran from one that ran and surfaced nothing. The rubric this wave seeds is **living**, with three lifecycle points:

1. **Seeded here, at spec stage**, by this wave (post-plan on a research plan).
2. **Appended by implementers** when they hit a weeds-level failure mode mid-task that the planner could not have foreseen. That tier sits in the plan, beneath the rubric the orchestrator transcribes from the signed spec.
3. **Consumed by the adversary** at both ends: its spec-stage pass reads the modes this wave just named, and its post-impl pass attacks the shipped artifact against the living rubric.

Like the rest of the grill, this wave is **record-only**: it names the modes, it does not act on them. Before the first signature the spec is a draft agents write, so a mode implying a change to it is folded in by the drafting agent and read at the sign-off gate; after the signature that same change is a re-sign, surfaced to the maintainer, and no agent ever signs. A mode implying a change to a plan that already exists is emergent work, routed to orchestrator `amend-plan`, never hand-edited from the grill.

## The post-plan grill (alignment gate)

The subsections below describe this mode; `## Invariants` and `## Voice` bind every pass.

### Method

1. **Read first, then grill.** Read the target plan (`wiki/wiki/plans/<topic>.md`) or the task brief in full, plus the signed spec it serves when one exists, and skim the code it names. Grill from the full picture, not half of it.
2. **Recommended answer first, across the interrogation waves.** Each question in the high-to-low waves ships with your recommended answer attached, whether or not the plan or code already leans one way; the maintainer confirms or corrects. Do not quiz them on things already written down. This keeps the grill on genuine forks and respects the maintainer's time. The failure-mode wave is the exception, and on a code plan it has already run at spec stage, so the exception applies here only on a research plan, where the wave sits inside this grill: there the maintainer names the modes, since leading with model-authored candidate modes reproduces the model's blind spots.
3. **Waves, high to low.** Wave 1: premise, scope, the irreversible commitments (core deps, public API defaults). Later waves: subtle correctness claims, the memory/perf model, the things most likely to bite. Keep each wave small (roughly 3-5, then 2-4, then 1-3 questions). Each wave's answers steer the next; don't dump everything at once.
4. **Target the high-leverage forks.** The load-bearing "why now" premise; scope ambition (ship-all vs ship-the-core); anything close to irreversible (a core dependency, a public default that needs a deprecation to change); the subtlest correctness risk in the chain; and anything the maintainer admits to skimming.
5. **Accept being grilled back.** When the maintainer pushes, find the real argument or concede. Update toward them when they are right. The goal is alignment, not winning the point. A grill that only ever ratifies the plan did nothing.

### Delivery shape

Before the grill closes, settle how the work ships: a single MR, or sliced MRs under a milestone with the slice boundaries named. Record the decision in the plan's `Delivery shape:` slot under `## Alignment (grill)`; when the grill is skipped or the question never comes up, the default is a single MR. The decision is always the maintainer's. Slicing composes with the plan's `## Not yet plannable` section: a later slice that is genuinely not yet specifiable may sit there, subject to that section's entry gate, realigned before its branch is cut.

### Capture (keep the record in one place)

After each wave resolves, append a dated entry to the plan's `## Alignment (grill)` section, titled `Maintainer shared-understanding pass (grill), Wave N — <topics>`. Record the confirmed positions, the clarifications, and any **OPEN** items with the divergence stated plainly (do not fabricate consensus). This fills the plan's pre-dispatch alignment gate and turns "what the maintainer actually thinks" from implicit into durable. (Plans predating the `## Alignment (grill)` section may carry their captures under `## Plan amendments`; new plans use the dedicated gate.)

The failure-mode wave has its own destination and its own timing. On a code plan governed by a spec it ran at spec stage: its named modes go into the spec, before the plan exists, and nothing about it lands under `## Alignment (grill)`. What reaches the plan is the orchestrator's transcription of the signed rubric into `## Failure modes`, where the adversary reads it. On a code plan no spec governs it ran nowhere, so neither section receives anything. On a research plan the wave runs inside this grill, so its modes and its ran-or-skipped line do land in the plan, under `## Failure-mode rubric` and `## Alignment (grill)` respectively.

Capture is **record-only**. Do not edit workstream done-whens, naming audits, or default justifications from the grill. A resulting plan *change* is emergent work, routed to orchestrator `amend-plan` (which populates `## Plan amendments`), never hand-edited from the grill.

### Routing emergent change

A grill commonly surfaces a real change: a flipped or removed API decision, a new deliverable, a scope shift. That is emergent work. Per `mental-model` rule 14, route it to the orchestrator's `amend-plan` mode rather than hand-editing the workstream set. The grill records the decision and recommends the routing; the orchestrator (with the api-critic where the surface changes) makes the edit. Mark the item OPEN in the capture until the maintainer gives the final call, then bundle the amend-plan dispatch.

## Parked maintainer decisions

Not every open decision gets a live answer. When the posture is async and a maintainer gate parks mid-run or at review, record it in the plan's `## Maintainer questionnaire` section; the plan template owns that section's shape and close mechanics, this skill just points at it. Parking beats guessing, and beats stalling the run until the next live session.

## Invariants (all passes)

- **Facts are the agents' job, never the maintainer's.** Never ask the maintainer something an agent or a repo read could answer; dispatch the fact-find and ask only decisions.
- **Never answer your own grilling.** A grilling pass that answers its own questions has broken; the recommended answer is an offer, and only the maintainer's confirmation is the answer.

## Voice (all passes)

Follow the maintainer's prose rules: no em-dashes, no AI filler, direct and slightly informal. One sharp question per genuine fork, with your recommended answer attached across the interrogation waves. Not interrogation theater, every question should be one whose answer changes what happens next.

## Stopping (post-plan grill)

Stop when a wave stops surfacing divergence, or the maintainer signals they are aligned. Then state the open decisions still on them, and name the next dispatch (orchestrator `initial-plan` / `amend-plan`, or the first workstream). Offer, do not assume, the next step. The close is an act-gate: no workstream dispatches until the maintainer explicitly confirms shared understanding, and a wave going quiet is not confirmation. (Brief mode's stopping condition is in its Method above.)
