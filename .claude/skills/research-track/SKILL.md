---
name: research-track
description: Conventions for running bounded, grounded, durable research against a consumer repo: the shallow-panel dispatch shape (N disjoint lenses fired as parallel Agent calls, no Workflow), the two standing lenses every run floors (prior-art/counterfactual and counter-evidence), two-layer grounding inherited from the deep-research engine (generation-time required quotes; verify-time claim-maker != voucher, default-refuted), the generation-time second-vote self-flag, and the source-trustworthiness sniff test. Uses the shared adversary/grill spine, not a parallel one. Load when a research run is invoked against a consumer ("research X for hiveplotlib"), when writing or dispatching a research-plan, or when reviewing a research run's findings. The binding pre-flight estimate, the concurrency ceiling, and the headline consumption report live alongside these in this skill's bounds conventions; durable landing in research-liaison's producer path. Distinct from `mental-model` (the shared workflow/library rules a research run also obeys) and `grill-me` (the alignment pass a research plan also gets).
type: skill
---

# Research track

Conventions for running research **against** a consumer repo: bounded, grounded, and durable. Loaded by the dispatching session when a research run is invoked. This skill is the conventions home for the whole track; the `research-plan` orchestrator mode emits only the per-plan fill-in (Question, candidate stories, lenses, bounds, validation criteria, destination), and the conventions that hold across every run live here.

A research run researches **for** a consumer and lands its finding in that consumer's durable records. It uses the same adversary and grill spine as code work, not a parallel one (see "Shared spine" below). The engine it wraps already exists: the `deep-research` engine supplies the grounding and verify mechanics this skill inherits; what this track adds is a hard bound, an adversary validation gate at convergence, and a first-class durable landing.

## Entry point

A research run is **conversational**: the maintainer asks for it ("research whether the two-cluster structure in this hive plot is real or a layout artifact"). No slash command. The precedent is the Anthropic `deep-research` skill, which triggers the same way (a conversational-entry precedent only; there is no `deep-research` skill inside this harness, so do not point at one). A conversational trigger matches how the maintainer actually asks and needs no new command surface.

A slash command is a **deferred option, not built**: the surface stays minimal until a real need appears. If one is added later, it is a thin wrapper over this same convention set, not a second entry path with its own rules.

## Shallow panel (the dispatch shape)

The default and, for now, only dispatch topology. **N disjoint lenses, one pass each. The dispatching session fires N parallel Agent calls. No Workflow.**

Each lens:

- reads **non-overlapping** material and searches **differently** from the others,
- is **blind to the other lenses** (no shared live context; plan-section-as-memory is the only channel),
- returns only its **distilled conclusion**, not raw material. The hub never touches raw papers; a lens does its reading and grounding inside its own context and hands back the conclusion plus its citations.

**N is set by orthogonality**, not by speed. N is the number of genuinely disjoint slices the question decomposes into: distinct bodies of material, distinct search strategies. Fanning wider "for speed" spends the run's estimate on redundant coverage and floods the hub with near-duplicate conclusions. N counts against the binding pre-flight estimate and the lenses fire under the concurrency ceiling (both bounds and their enforcement live in this skill's bounds conventions).

### Two standing lenses, floored on every run

Two lenses are **standing seats**, floored on every research run **before** the orthogonality count fills the remaining N-2. They are obligations, not optional angles a given question may or may not spawn:

- **Prior-art / counterfactual lens** asks "how do people normally do this, what are the alternative approaches, has anyone already published this." Without it, a narrow-question run could ship zero prior-art coverage and still look complete, and a finding could not be told apart from a reinvention or an already-known result. Especially load-bearing for the hive-plot "is this even the right way to show this" questions.
- **Counter-evidence lens**, **blind to the confirming lenses**, actively searches for evidence *against* the emerging conclusion, and carries its non-confirming hits (labelled **not-fully-confirming**) all the way to synthesis, never dropping them. This is **generation-time disconfirmation**: a fresh search while the sources are still in the lens's context. It is deliberately **not** a convergence-adversary duty, because the convergence gate reads conclusions, not sources, and cannot re-open them (see "Grounding" and "Shared spine"). Fan-out search plus per-claim verify is structurally confirmatory; this lens is the counterweight.

Both standing lenses are counted in the pre-flight estimate (roughly +2 at the floor), so "no surprise" holds even for the leanest run.

## Grounding (inherited, two layers)

The grounding and verify mechanics are **inherited from the deep-research engine** (a private-store workflow script, not edited; its patterns are re-expressed here). Two layers:

- **Generation-time grounding.** Every lens **cites as it goes**: no claim without its source, and each claim carries the supporting **quote** (the engine's required `quote` field). A lens synthesizes from the material it actually read, not from prior knowledge.
- **Verification-time grounding.** The **claim-maker is not the voucher**: an independent verify agent re-reads the cited source for a claim, separate from the fetch agent that produced it. The verify default is **refuted-if-uncertain** (skeptical by default; a claim survives only on independent confirmation, not on the benefit of the doubt).

The single verify vote per claim is the grounding floor here, not a regression from the engine's flat multi-vote: the engine's votes were its *only* adversarial check, whereas the convergence-gate adversary is the real one here. The optional second vote is scheduled by the self-flag below.

### Generation-time second-vote self-flag

A lens whose support for a **load-bearing** claim rests on a **single quote** self-flags that claim **at generation** (while the source is still in its context) as wanting an independent re-verification. That flag is what **schedules the optional second verify vote**: this skill's bounds conventions turn a flag into a second voucher at verify.

The trigger lives **upstream, at generation**, on purpose: the observable it acts on is quote-vs-source fidelity, and **no role at convergence can see it**. The single voucher who read the source is gone by convergence; the convergence-gate adversary reads distilled conclusions, not the underlying sources; the hub never held the raw material. A convergence-time "is this claim central enough to re-verify" decision would be unfireable. So the lens that read the source, while it still holds it, is the only role that can flag the specific hole a single vote accepts: **a mis-supporting quote passing on one cooperative voucher**.

## Source-trustworthiness sniff test

The fetch/verify agents already hold a source in context; **they** make a "do we trust this source" judgment there. **No new pass and no new lens**: the sniff test rides the agents already in context, so it adds nothing to the pre-flight estimate.

The judgment: prefer formally-published, more-cited, stronger-provenance sources **when they corroborate**, but do **not** reflexively dismiss a preprint for being a preprint. It is a sniff test ("do we trust this source"), not an academic-pedigree filter. It is **orthogonal to the mis-quote re-read**: a faithfully-quoted claim from a junk source passes verify untouched, which is exactly why a separate trustworthiness call is needed. Record the judgment alongside each citation in the report.

## Bounds

The bounds conventions the rest of this skill points at. A research run is **bounded**, and the firm requirement is **no surprise**, not fewest agents: a slower run is fine, a silent blowout is not.

- **The pre-flight estimate is the binding total.** The estimate (see below) is mandatory, and once surfaced it binds the run: exceeding it requires surfacing a revised estimate *first* (ask when the maintainer is present; park and record under an async posture). Never a silent overrun. Typical runs stay an order of magnitude under the engine's ~97 for a full run, justified by orthogonal coverage rather than speed.
- **A concurrency ceiling of 8 simultaneous agents.** A hard limit on how many agents run at once, held by the dispatching session (see "Who holds the ceiling and the estimate" below).
- **Token consumption is reported, not gated.** Headline consumption (agents, peak concurrency, approximate tokens) is mandatory and honest in every run summary; there is no token gate. The no-surprise discipline lives in the estimate and its surfacing, not in a token number.

### The addable agent-count model

The shallow panel has its **own** agent-count model, and it is addable: a reader can name each component and sum them, and the sum **is the pre-flight estimate**.

```
1 scope-refine
+ N lenses            (N includes the 2 standing lenses)
+ verify vouchers     (one per verified claim, plus a generation-flagged
                       second voucher on the claims that self-flagged)
+ 1 synth
= the pre-flight estimate
```

The two fixed ends (scope + synth) cost **2**; the two variable pools are set by the question, not by a fixed share. **N lenses** come from orthogonality (the 2 standing lenses plus the genuinely disjoint slices, per the shallow panel above), and the **verify vouchers** from the claims worth verifying (single votes plus any generation-flagged second vouchers). The model's job is to make the estimate derivable and checkable component by component, not to prove a ceiling. A decomposition that balloons either pool mid-run does not silently proceed; the binding-estimate rule above is where it surfaces.

This is **not** the engine's flat model. The engine spends `1 scope + 5 search + 15 fetch + (claims x 3 votes) + 1 synth`, whose fixed part alone (`1 + 5 + 15 + 1 = 22`) already dwarfs a typical shallow-panel estimate before a single verify vote, and its verify runs at roughly **77%** of the ~97 total. That model is kept here only as **context for what the shallow panel does not do**: the shallow panel has no separate `5 search + 15 fetch` fan-out to exempt, because **each lens does its own search, fetch, and distill inside one agent context**. The covering is the N lenses counted in the estimate, not a breadth pool sitting outside it.

- **Single vote per claim by default.** One independent voucher re-reads the cited source (claim-maker != voucher, default-refuted). This is the grounding floor, not a regression from the engine's flat three votes: those were the engine's *only* adversarial check, whereas here the convergence-gate adversary is the real one.
- **An optional second vote**, which the estimate budgets for explicitly (the generation-flagged second vouchers in the addable model). It is tied to **one specific failure single-vote accepts**, not a vague "this claim feels central": a **mis-supporting quote can pass on a single cooperative voucher**, and the convergence-gate adversary reads distilled conclusions, not the underlying sources, so it will never catch a quote that does not actually support its claim. The second vote is the mitigation for exactly that hole: a claim whose support is **load-bearing** and whose source could plausibly be **mis-quoted**.

**How the second vote is scheduled.** It is **not** a convergence-time decision (nothing at convergence can see quote-vs-source fidelity). It is scheduled by the **generation-time self-flag** above: the lens agent that read the source, while it still holds it, flags a load-bearing single-quote claim as wanting re-verification, and the bounds convention turns that flag into an **independent second voucher at verify** for exactly the flagged claims. The trigger owner is the lens agent, upstream, where the observable is still in context; the second-vote apparatus is fireable because the flag, not a convergence guess, drives it.

**When claims outgrow the voucher pool.** Lens returns can produce more claims than the estimate's voucher component holds. Selection is explicit, never silent: load-bearing claims verify first, generation-flagged second votes are honored before breadth of coverage, and every claim that goes unverified is labeled `unverified` in the run summary and treated as ungrounded at the convergence gate (the adversary kills on it like any other missing grounding). A claim set too large to verify within the estimated voucher count is a revised estimate to surface (per the binding-estimate rule above); the run does not silently triage.

### Who holds the ceiling and the estimate

A skill is instruction to a dispatching session, not code with a guard, so "the bounds are enforced" needs an owner. The **dispatching session fires the N parallel Agent calls** (per the shallow panel above), so it is the role that **holds the running count against the estimate and the live count against the concurrency ceiling**; it surfaces at either boundary rather than silently proceeding. Three gates sit in order:

- the **pre-flight estimate** is the **before-the-run gate** (and the binding total),
- the **headline consumption** is the **after-the-run report**,
- the **running enforcement between them** is the **dispatching session's job**: it counts each Agent call it fires against the estimate, surfaces a revised estimate before exceeding it, and never has more than 8 agents live at once.

This is what promptware can honestly claim (the dispatcher counts and surfaces), not a code guard. A firmer in-script guard is the same "enforce the bound in the script" effort the engine holdout defers; want it and that is a separate change against the workflow store, not a promise this skill makes.

### Pre-flight estimate

An **agent-count estimate surfaces before the run starts**, derived from the addable model above (scope + N lenses + verify vouchers + flagged seconds + synth) rather than asserted as a top-line number. The surfaced estimate **is the run's binding total**: the run auto-proceeds under it, and exceeding it requires surfacing a revised estimate *first* (ask when the maintainer is present; park and record under an async posture). A run never silently overruns its own estimate. The estimate **counts the two standing lenses** (prior-art / counterfactual and counter-evidence) in its N, roughly **+2 against the base the model expresses** (scope + the remaining orthogonality lenses + the per-claim vouchers + synth), so a reader can check that the components sum to the stated total rather than adding a delta to a floor the estimate never states.

### Headline consumption

Consumption is a **headline in every run's summary**, not a figure buried in a stats object: the **agent count, peak concurrency, and approximate tokens** report next to the findings. **Nearing the estimate surfaces to the maintainer; exceeding it takes the revised-estimate surfacing above, never a silent overrun.** This extends the engine's own no-silent-cap discipline (it reports when a budget forces something to be dropped) to the verify phase, which the engine leaves unbounded.

A skill-only reader sees the shape the no-surprise claim rests on right here, so the pointer does not dangle:

```
Pre-flight estimate: ~19 agents (binding; revise-and-surface to exceed)
Resources consumed:  18 agents, peak concurrency 6 (ceiling 8), ~240k tokens (basis: task-notification subagent figures; "unknown" when unmeasured)
```

Both lines belong to the run's full summary, whose complete shape (`Findings`, `Adversary verdicts`, `Evidence mode`, `Destination`, and these two consumption lines) is emitted by the `research-plan` orchestrator mode; this is the consumption slice of it, carried here so the headline and no-surprise claims resolve to a present artifact.

## Deep exploration (a named, deferred slot)

When one lens would exceed a clean context, the intended tool is a **bounded Workflow** that shards read -> distill -> synthesize into fresh contexts, protecting both the shard contexts and the hub. That pattern is **not built here.** The shallow panel is the only dispatch topology in the shipped track: each lens returns only its distilled conclusion and distils inside its own context before returning, so nothing yet shows a literature lens overflows a clean context at the shipped bound.

This is a named, **revival-triggered** follow-up, not a gap. **Revival trigger:** a literature lens is observed to overflow a clean context on a real research run (the shallow panel cannot hold one lens's reads before it distills). At that point the bounded deep-exploration Workflow lands here, with its bounds enforced inside the Workflow (a shard cannot spawn sub-agents uncounted against the estimate or in excess of the concurrency ceiling).

## Evidence mode

The **literature** mode is the default and, for now, only evidence substrate: it inherits the engine's web grounding and verify directly. A **data-validity** mode (evidence from data probes and rendered plots, the layout-artifact / Datasaurus check) is a named, deferred follow-up on its own later plan; it needs a code-execution surface the literature mode does not. The run's summary carries an `Evidence mode: literature | data` field with only `literature` live, so the deferred mode is a visible slot, not a silent omission.

## Durable landing

A research run **ends by landing** a durable `analyses/<slug>.md` page (the path follows the consumer, see below), formatted from the validated run summary and surfaced for maintainer approval (not auto-committed). This closes the loop the whole track exists for.

**The landing target follows the consumer.** A consumer with a wiki gets `wiki/wiki/analyses/<slug>.md`, landed via research-liaison's producer path. A consumer with no wiki never defaults into another consumer's wiki, where the page would sit topically orphaned. Instead the finding is split by what kind of thing it is: **durable mechanics** (a fact about the tooling, a process lesson) land as expertise entries where the agent that needs them will read them; **what shipped** lands in the CHANGELOG; and a body of research substantial and general enough to be worth reading on its own belongs in **its own repository**, not in a subdirectory of the harness. Resist inventing a third tier between an expertise line and a repo: a page that only summarizes what was changed elsewhere is redundant the moment the change lands.

**The point of the landing is auto-save, not formatting.** The engine's core un-niceness is that it returns a JSON object and evaporates: nothing becomes a longer-term reference. So the run must **identify and save what is of interest on its own**, without the maintainer hand-directing which finding matters. The anti-goal is the one true autonomous run that burned its budget and **saved nothing**. The in-chat run summary is the headline; this page is the durable narrative-plus-evidence artifact. The first-class requirement of a run is reaching an honest terminal outcome and reporting consumption, not always emitting a page; the durable page reflects yield (a full page for a validated finding or a validated inconclusive, a minimal breadcrumb for a nothing-cohered run), so a low-yield run that saves nothing of interest is not dressed up as a landing.

The landing is owned by **research-liaison's producer path** (`research-liaison.md`, its fourth pass alongside pre-task / post-task / ADR promotion): it takes the validated summary, formats it to the schema, and surfaces it for approval. The approval gate already exists (research-liaison requires maintainer approval for any new `analyses/` page); the run is named as a **producer** of that page.

**Page schema** (research-liaison owns the pass; these are the slots):

- **What was established**: the confident conclusions.
- **What was validated, and how**: the finding tied to the adversary's convergence verdict and the grounding that carried it.
- **What was inconclusive, and why**: a landable *negative* result.
- **What's open**: questions surfaced but not pursued.
- **Sources**: kept compact.

**A nothing-cohered run lands a breadcrumb, not the full page.** The breadcrumb is a distinct minimal artifact: the question, the nothing-cohered verdict, and the consumption reported, nothing more. It records the dead end so it is not blindly re-researched later, without dressing a null run up as a thin finding-shaped page. The producer path (`research-liaison.md`) branches on `Yield` to land it.

**A validated inconclusive lands durably.** "The evidence does not support a confident answer" is a first-class terminal verdict, not a failed run. It lands via the `What was inconclusive, and why` slot as a **"do not re-research this dead end"** reference point, so the same question is not paid for twice. That slot is distinct from `What's open`: an open question is still worth asking; an inconclusive was asked and answered "the evidence will not say."

**Provenance is compact.** The `Sources` slot rides the inherited required-`quote` provenance (see "Grounding") to preserve where each source came from, but formatted **tight, no wall of text bloating the page**, so a finding that pans out into a paper or a rigorous blog post does not restart the source-hunt from scratch. This is a formatting discipline on material the run already carries, not a second provenance mechanism.

## Shared spine (not a parallel one)

This skill adds the research-run **conventions**, not new dissent machinery. The dissent spine is the **shared** one:

- The **adversary** applies to research runs with its **phase-aware authority** already codified in `mental-model` rule 18: a **non-killing dissenting voice during divergence**, and the **validation gate at convergence** (it checks findings against the plan's named failure-mode rubric and emits the "Adversary verdicts" block in the run summary, reading conclusions, not sources).
- The **grill** applies too: its failure-mode wave has a research branch that elicits the domain failure modes for a research plan (structure-is-artifact first, then already-known / n-too-small / uncontrolled-comparison / grounding failures).

Do not grow a parallel adversary/grill for research; that would defeat the shared-spine premise. This skill is the conventions home; the dissent stays on the shipped spine.

### The convergence gate

The convergence gate is where the divergent lenses' distilled conclusions come back together. Two things happen here, and both feed the run summary the `research-plan` orchestrator mode owns:

- **Per-finding validation.** The adversary validates or kills each finding against the named `## Failure modes` rubric, reading the distilled conclusions, not the underlying sources (a claim with no source, a voucher who is the claim-maker, a structure that does not survive a degree-preserving rewire, is killed). This produces the **"Adversary verdicts"** block.
- **Terminal-outcome classification.** The synth and convergence gate also classify the run's terminal outcome as one of **validated finding** (a confident, grounded conclusion), **validated inconclusive** (the question was pursued to a negative, "the evidence does not support a confident answer"), or **nothing-cohered** (the degenerate low-yield case: the panel ran but nothing of interest cohered, neither a confident finding nor a pursued-to-a-negative inconclusive). This is the run's honest "is there something of interest worth landing, and what" judgment. It **feeds the summary's `Yield` field** and the outcome-conditional `Destination` (see "Durable landing"): a validated finding or validated inconclusive lands the full page, a nothing-cohered run lands only the minimal breadcrumb.

The yield judgment lives here on purpose. The producer path that lands the page does **not** re-adjudicate (`research-liaison.md`); it formats what the run validated. So without an upstream judgment of what is *of interest*, "auto-save what is of interest" is a hope, not an install, and a low-yield run points at a tidy finding-shaped page it should not. The convergence gate is where that "of interest" judgment sites: it is not only per-finding validation but also the terminal-outcome call.

### Framing on the synth step

The synthesis step frames findings as **correlational, exploratory pointers, not causal claims** (the framework surfaces starting points and correlations, so a finding that reads as a cause overreaches its evidence). It labels non-confirming evidence as **not-fully-confirming** rather than dropping it: the counter-evidence lens's hits (see "Two standing lenses") are carried here and reported that way, never quietly discarded. This is a framing and labeling obligation on the synth, no extra agent; it is the causation-overclaim guard folded into the counter-evidence lens's disconfirmation carry.
