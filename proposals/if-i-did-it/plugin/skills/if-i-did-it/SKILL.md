---
name: if-i-did-it
description: Contemplate adopting a capability you have not used before, without building it. Runs a calibration interview to find out what you already know, then produces a past-tense field report from the timeline where you shipped it: what it would take, where it would sit in this codebase, what it would cost to back out, the strongest case for and the strongest case against (written independently, neither seeing the other), and a short explainer of the thing itself for a reader meeting it for the first time. Lands a self-contained HTML report and, on an adopt verdict, a ready-made planning brief. Use when the maintainer says "should we use X", "what would it take to add X", "I keep hearing about X", "is X worth it here", or names a library, service, pattern, or technique they are curious about but have not touched. Never implements; a shipped line of production code means this skill has failed.
disable-model-invocation: true
---

# If I Did It

You are writing a field report from the timeline where the maintainer already adopted the thing. Past tense, throughout. Not "we could add Polars," but "we added Polars, and here is what that cost."

The tense is the method, not a flourish. Prospective hindsight (explaining an outcome as though it already happened) produces roughly 30% more correctly identified reasons than forward-looking speculation, and the reasons come out episodic and specific rather than generic. Write "the migration stalled on the groupby rewrite" and you will find the groupby rewrite. Write "there may be migration challenges" and you will find nothing.

One refinement from the original study, which matters for how you write: the lever is **treating the outcome as settled**, more than the grammar itself. Explanations for events framed as certain ran longer and more episodic than explanations for events framed as maybe. So do not hedge the frame. "We adopted it" and "here is how the second week went," not "we would likely have adopted it."

## The one rule

**You do not implement.** No production code, no dependency added to the manifest, no config changed. Throwaway probes in `/tmp/if-i-did-it/<slug>/` are not only allowed, they are the point (see Phase 2). If a probe turns out well and you feel the pull to keep it, that is the failure mode this rule exists to stop. Write down what the probe proved and delete it.

## Phase 0. Calibrate (inline, with the maintainer)

Do not skip this and do not batch it. The whole value of the report is that it is pitched at a reader who does not know the subject yet, and you cannot pitch it without knowing where they are standing.

Ask **one question at a time**, each with your recommended answer attached so the maintainer confirms or corrects rather than composing from scratch. Never ask what you could find out yourself; go read the repo first.

Six things to establish, in roughly this order:

1. **The subject, stated back.** Say what you think they are asking about in one sentence, including which specific thing (the library, not the category). Adoption questions die on ambiguity here more than anywhere else.
2. **Baseline.** What adjacent thing do they already know well? That becomes the spine of every explainer in the report: "it is `X` but `Y`." A reader who knows pandas learns Polars in one sentence if you say the right sentence. Ask for the nearest neighbor, not for a self-rated expertise score.
3. **Appetite.** How much time are they willing to spend, decided *now*, before any report exists. A week? An afternoon? One evening? This is Shape Up's appetite and it runs the opposite direction from an estimate: you will not predict how long the work takes, you will report whether it fits the number they just gave and what would have to be cut to make it fit. Estimates from a model are guesses wearing a number; a fit-check against a fixed budget is answerable.
4. **What would make this a bad idea.** Ask before they have read anything. Their answer is the rubric the skeptic works against later, and it is worth more than yours because it is theirs.
5. **The reference class.** What does this resemble that they have already done? The last dependency they took on, the last rewrite they attempted, the last tool they adopted and later regretted. This is the outside view, and it is the single most useful input to the effort question, because a maintainer's own history predicts their next adoption better than any decomposition you can build.
6. **Where the report lands and who reads it.** Just them, or a collaborator, or a future maintainer who inherits the decision.

Stop when those six are settled. Do not turn this into a quiz; three exchanges is often enough.

## Phase 1. Recon (what the thing actually is)

Establish what is true about the subject, at a stated version, on a stated date. This is where a report like this hallucinates, because the maintainer asked precisely because they cannot check your answer.

- **Every factual claim carries its source and a supporting quote.** No claim without one.
- **Version-stamp everything.** An API claim is only true at a version. Record the version you checked and the date.
- **The claim-maker is not the voucher.** Anything load-bearing gets re-read by a context that did not produce it, and survives only on confirmation, not on the benefit of the doubt.
- **Search for the case against, separately and on purpose.** Find the migration-away posts, the open issues, the "we moved off it" writeups. A search that only asks "how do I use X" returns only people who chose X.

Also establish the **liveness** facts, which decide more adoption questions than features do: last release, release cadence, bus factor, open-issue trend, whether the funding or the maintainer situation is stable, what the deprecation history looks like.

**Then trace the local lineage, which is the half of recon that is easy to skip.** Unfamiliar to the maintainer does not mean new to the repository. Search the git log, the decision records, and any design docs for whether this ground has been walked before: an earlier attempt that was abandoned, a dependency that was deliberately dropped, a pattern that was ruled out in writing. Two findings matter and they point opposite ways. If it was tried and abandoned, name what actually failed and whether that constraint still holds, because approaches get abandoned for reasons that expire. If it was ruled out in a decision record, the report is arguing against a written decision and has to say so out loud rather than quietly proposing what was already declined.

## Phase 2. Integration (what it would mean *here*)

Grounded in the actual repository, not in general. This is the section that no blog post about the subject can give the maintainer, so it is where the report earns its existence.

Count things, do not estimate them:

- **Blast radius.** The specific files, functions, and call sites that change. Grep for them and list them. A count of real paths beats any adjective.
- **Public surface delta.** New user-facing names, changed signatures, changed defaults. Anything requiring a deprecation cycle is called out by name, because those are the expensive ones.
- **Dependency reality.** What it drags in, what it conflicts with, whether it becomes required or optional, what happens to install size and to the supported platform and version matrix.
- **Test and docs surface.** How many tests would need to exist, what the doc build gains or breaks.
- **The seam.** Where the new thing meets the old, drawn as a diagram. If you cannot draw the seam, you do not understand the integration yet, and the report should say so rather than papering over it.

Then run a **throwaway probe** in `/tmp/if-i-did-it/<slug>/`: the smallest thing that turns the riskiest guess into an observation. Install it, call the one API that everything hinges on, feed it data shaped like the real data. Twenty minutes of running the thing outranks two hours of reading about it. Report what the probe showed, including when it showed the plan does not work. Then delete it.

**Exit cost gets its own section, always.** How would we back this out in six months? What gets stranded, what becomes load-bearing and unremovable, what does the data or the API surface look like after an un-adopt. Cheap-to-reverse and expensive-to-reverse decisions deserve completely different amounts of deliberation, and this is the section that tells the maintainer which one they are holding.

## Phase 3. The two cases (independent, blind)

The strongest case for and the strongest case against, **written by separate contexts, neither seeing the other**. One context writing both sides writes a real argument and a straw one, every time, and the straw one is whichever it wrote second.

Dispatch the two as parallel sub-agents with the same evidence pack from Phases 1 and 2:

- **`skeptic`** writes the case against, working the maintainer's Phase 0 rubric plus three standing angles: the problem is not real or not live; a smaller move covers it (a function, an existing dependency, doing nothing); the surface is maintained forever and is not load-bearing. The skeptic also holds the standing objection specific to this skill, which is that **reading a good report about an unfamiliar tool can substitute for the hour of using it that would teach more**. When that objection is the right answer, the skeptic must say so plainly.
- **`advocate`** writes the case for, and is held to the same standard: sourced, specific, naming the concrete thing that gets better and for whom. "It is modern" and "it is faster" without a number are not arguments.

Order matters: **run the skeptic's case first and let it land before the advocate starts.** By the time this phase runs, real effort has gone into the exploration, and the pull toward justifying that effort is strongest at exactly this moment. Writing the against-case first means it cannot be shaped as a rebuttal to a conclusion already reached.

Synthesize without picking a winner by volume. Name what the two sides actually disagree about, which is usually one load-bearing empirical question, and say what would settle it.

## Phase 4. Verdict

One of four, stated plainly, never hedged into mush:

- **Adopt.** With the appetite fit named.
- **Do not adopt.** With the reason that is doing the work.
- **Not yet.** With the specific trigger that would change the answer ("revisit when the 2.0 API stabilizes", "revisit if we hit the case this solves more than twice"). A "not yet" without a trigger is a "no" that will get re-researched from scratch in six months.
- **Keep the tension.** The two cases are both right, under different conditions that will not collapse into one answer. Then the verdict is the seam that keeps both alive: an optional extra, a config switch, two implementations behind one interface. Reach for this only when the tension is genuinely context-dependent, not when you are avoiding a call. It is ruled out when the choice is a one-way door, when the approaches cannot coexist, or when carrying both costs more than picking wrong.

A "do not adopt" is a successful run. The exploration cost is sunk either way, and the maintainer paid for an answer, not for a yes.

**On a "do not adopt" or a "not yet", run a reverse premortem before you write the verdict down.** Prospective hindsight has a known bias in the other direction: framing the work as already failed makes failure feel more available than it is, and a run that spent a phase building the case against will over-produce reasons to decline. So flip it once. Imagine it is a year on, the thing was adopted elsewhere and worked, and this decision reads as the timid call. Narrate why. If that story is easy to tell, the verdict is "not yet" with a trigger rather than "no", and if it is hard to tell, the "no" just got stronger. This costs one paragraph and it is the counterweight to the whole method's thumb on the scale.

Also name **the cheapest thing that would settle this**. Often it is "spend an hour with it." If that is the honest answer, the report says so and gets short.

## Phase 5. Land it

**The report.** A single self-contained HTML file at `/tmp/if-i-did-it/<slug>/report.html` (no CDN links, no external assets, inline everything, so it survives being emailed and read offline). Build it from `${CLAUDE_SKILL_DIR}/assets/report-template.html`. Structure and visual rules are in `reference/report-anatomy.md`; read it before writing the report.

**The handoff.** On an adopt verdict, also write a planning brief: the goal, the non-goals, the blast-radius list already grepped, the naming candidates, and the failure modes the skeptic named. This is what makes the exploration reusable instead of a document that gets read once. On a do-not-adopt or a not-yet, write a short breadcrumb instead (question, verdict, trigger, date) so the same ground is not re-covered later.

**Keep the old runs.** A verdict on an unfamiliar capability has a shelf life, and "not yet" is a promise to look again. Write each run to a dated file rather than overwriting the last one, so re-running on the same subject in six months produces a diff: which objections closed, which got worse, which are new, and whether the trigger fired. The diff is worth more than either report alone, and it is the only way the skill gets better at a subject rather than starting cold every time.

## Epistemic honesty is a formatting requirement

The reader asked for this report because they cannot check it. So the report must show its own confidence, visually, at the claim level. Three tiers, three visible treatments, defined in `reference/report-anatomy.md`:

- **Ran it.** Observed in the Phase 2 probe. Highest tier, and the only one that gets to sound certain.
- **Sourced.** Backed by a cited source with a quote and a version stamp.
- **Inferred.** Your reasoning from the above. Legitimate, and it must look different from the other two on the page.

A report where everything is the same weight is a report that quietly promotes guesses to facts, and it will be read by someone with no way to tell the difference. Never present an unrun code snippet as a working example; mark it unrun.

**No chart without a number the repo or the probe actually produced.** A feasibility gauge, a confidence dial, or a risk heatmap built from your own adjectives launders a guess into a graphic, which is worse than not drawing it. Diagrams of structure (the seam, the blast radius, the before-and-after call site) are grounded and welcome. Scores are not.
