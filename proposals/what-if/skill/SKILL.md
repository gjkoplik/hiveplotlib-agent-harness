---
name: what-if
description: Take a cheap look at a half-formed idea before committing to a conversation about it. Ask what it would mean to add some capability, library, pattern, or technique, and get back a short calibrated report: what it is in terms you already know, the surface it would land on in this repo, the API and structural implications, what would be hard to undo, and the case for and against at equal length. Deliberately brief, with everything past the first screen behind expandable sections. Use when someone says "should we use X", "what would it take to add X", "I keep hearing about X, is it worth it here", or floats an idea they are not yet committed to. Never implements, never produces a plan, and a "not worth it" is a successful run.
disable-model-invocation: true
---

# What If

A sunk-cost circuit breaker. Someone throws a half-formed idea at you and wants enough to decide whether it deserves a real conversation, before the conversation itself makes them feel committed.

**Cheap is the point.** Not a research run with a small budget: the cheap version is the only version. Anything that would make someone hesitate before firing this at a shower thought is a bug, however much rigor it buys. If a phase does not survive that test, cut it.

## The two rules

**Do not implement.** No production code, no dependency added, no config changed. A throwaway probe in `/tmp/what-if/<slug>/` is allowed and often the best thing you can do with ten minutes; delete it after and report what it showed, including when it showed the idea does not work.

**Do not produce a plan.** No workstreams, no handoff, no pre-filled brief. A plan is the sunk cost in another form, and it prejudges the decision this exists to keep open. The report ends with the call and stops. What happens next is the reader's: ask follow-up questions, go try the thing, start planning for real, or drop it.

## Budgets, because "be brief" is not enforceable

- **Top level: under 400 words.** The part read before deciding whether to keep reading never grows.
- **Each expandable: under 150 words.**
- Anything wanting more is not more prose. It is a follow-up question the reader asks, or a signal the idea has outgrown triage.

Collapsed is not the same as short. Eight disclosures at 800 words each has the same problem, hidden.

## 1. Calibrate

Three questions, one at a time, each with your recommended answer attached so the reader confirms rather than composes. Never ask what you could find out yourself.

1. **Which exact thing?** Name it at a version. Adoption questions die on ambiguity here more than anywhere.
2. **What next to it do you already know well?** The nearest neighbor, not a self-rated expertise score. People are bad at rating themselves and good at naming what they use. This becomes the spine of every explainer: "it is X but Y."
3. **How much appetite?** An afternoon, a week, an evening. Stated now, before any report exists. You will not predict how long the work takes; you will say whether it fits this number and what would have to be cut.

**The answers set what opens by default.** This is the load-bearing part. Something adjacent to what they know stays collapsed as a one-line reminder. Something genuinely new opens with a short explainer. Same document, different shape per reader, calibration visible in the layout instead of buried in word choice. If six explainers open by default, they are further from this subject than the idea assumed, and that belongs at the top of the report.

## 2. Look

One pass, one context. Three things:

**What it is.** At a stated version, on a stated date. This is where a report like this goes confidently wrong, because the reader asked precisely because they cannot check you. Cite what matters, stamp the version, and search once for the case against rather than only for how to use it.

**What it would touch here.** Grep the repo. Real paths, real symbols, counted rather than described. This is the section no blog post can give them, so it is where the run earns itself. Cover the surface it lands on, the API and default changes, anything needing a deprecation, and what is hard to undo.

**What this repo already decided.** Unfamiliar to the reader does not mean new to the repo. Check the git log and any decision records for an earlier attempt, a dependency deliberately dropped, or a written ruling against it. If a decision record already ruled it out, say so out loud rather than quietly proposing what was declined.

## 3. Weigh

The case for and the case against, **at equal length**. One context writes both, which is the cost of cheap, so symmetry is the substitute for independence: a weak side cannot be padded and a strong one cannot be truncated. Both must name a concrete fact, not an adjective. "Faster" without a number is not an argument, and neither is "more surface to maintain" without saying what surface.

Then name what the two actually disagree about. It is usually one empirical question, and saying what would settle it is worth more than either case.

Watch your own thumb on the scale, in both directions. Effort already spent pulls toward yes. Imagining the thing already failed pulls toward no. Before landing on a flat "not worth it," check once whether the honest answer is "not yet" with a trigger.

## 4. Call

One line, plus one sentence of why:

- **Worth doing.** With the appetite fit named.
- **Not worth doing.** With the reason that is carrying the weight.
- **Not yet.** With the trigger that would change the answer. Without a trigger this is a "no" that gets re-researched from scratch in six months.
- **Worth doing smaller.** The fraction that captures most of the value, when there is one.

Then the cheapest thing that would settle it. Often that is "spend an hour with it," and when it is, say so and let the report be short. A "not worth doing" is a successful run.

## Output

A self-contained HTML file plus a markdown twin of the same content, written side by side. The HTML is what gets read; the markdown is what version controls, since HTML does not diff and does not render on a repo host. Build the HTML from `${CLAUDE_SKILL_DIR}/assets/report-template.html`, which carries the disclosure mechanics, the expand and collapse controls, and both themes.

Write both to a durable, dated path in the repo. **Do not stage or commit them.** Print the path and let the reader decide whether this idea is worth keeping; that choice is itself part of the triage.

## Honesty is a formatting job

The reader cannot check you, so mark the exceptions rather than everything. Default voice is your read. Two things get marked: **ran** for anything observed in the probe, and **sourced** for a cited, version-stamped claim. Marking every sentence is noise; marking the two that outrank your judgment is signal.

Never present unexecuted code as a working example. Mark it unrun.

Diagrams of structure are welcome and grounded: where the new thing meets the old, the blast radius as real paths, a before and after call site. Scores are not. A feasibility gauge or risk heatmap built from your own adjectives launders a guess into a graphic. The test is one line: name the measurement.
