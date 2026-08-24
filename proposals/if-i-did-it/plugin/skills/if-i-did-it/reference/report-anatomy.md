# Report anatomy

Read before writing the report. Build from `assets/report-template.html`.

## Shape

A single self-contained HTML file. Inline CSS, inline SVG, no CDN links, no external fonts, no build step. It has to survive being emailed, opened offline, and read on a phone at midnight.

Sections, in order. The order is the argument:

1. **The question, and who is asking.** One sentence naming the subject at its version, plus the calibration line: what the reader already knows that this report builds on, and the appetite they named. Putting the appetite at the top means every later section is read against it.
2. **The thing itself, in one screen.** The explainer, pitched at the baseline from Phase 0. Lead with the nearest-neighbor sentence ("it is X but Y"). One worked example, marked `ran` if it was run and `unrun` if it was not. This section exists because the reader has not used the subject; if it needs a second screen, the subject is too big for one report.
3. **If I did it.** Past tense. The integration as it happened: the seam diagram, the blast radius as a real file list, the public surface delta, the dependency reality, the test and doc surface.
4. **What it cost to back out.** Never omitted, never folded into another section. Its absence is the most common defect in adoption write-ups and the reason bad adoptions persist.
5. **The case against.** The skeptic's, unedited in substance.
6. **The case for.** The advocate's, unedited in substance.
7. **What they actually disagree about.** Usually one empirical question. Name it, and name the observation that would settle it.
8. **Verdict.** Adopt, do not adopt, not yet with its trigger, or keep the tension with the seam named. Plus the appetite fit and the cheapest thing that would settle the question. On a decline or a not-yet, the reverse premortem sits here as one short paragraph, so the reader can see the method was checked against its own bias.
9. **What was checked, and how.** Sources with versions and dates, the probe and what it showed, the local lineage result, and an explicit list of what was not checked. The unchecked list is load-bearing: a report that does not say what it skipped reads as if it skipped nothing. When an earlier run on this subject exists, this section opens with the diff against it: which objections closed, which got worse, which are new.

## Epistemic tiers

Three tiers, visually distinct, applied at the claim level. The template defines `.ran`, `.sourced`, and `.inferred`.

| Tier | Means | Looks like |
| --- | --- | --- |
| `ran` | Observed in the probe | Solid left border, filled badge |
| `sourced` | Cited source, quoted, version-stamped | Solid left border, outline badge |
| `inferred` | Reasoned from the above | Dashed left border, muted badge |

Rules:

- Every claim about the subject sits in exactly one tier. Untiered prose is for framing and transitions only.
- An `inferred` claim never uses the grammar of an observation. "The migration would touch the plotting layer" is inferred; "the migration touched 14 files under `src/`" had better be `ran` or `sourced`.
- A code snippet that was not executed carries the `unrun` marker on the block itself. Never present unrun code as a working example, especially to a reader who has not used the subject and will copy it verbatim.
- The legend appears once, near the top, before the first tiered claim.

## Diagrams

Earn their place or leave them out.

**Welcome**, because they carry structure the prose cannot:

- The seam: where the new thing meets the existing code.
- The blast radius: real paths, sized by how much of each changes.
- Before and after at a call site, side by side.
- The decision spine: the fork, the two branches, the exit cost of each.

**Banned**, because they launder judgment into a graphic:

- Feasibility gauges, confidence dials, readiness scores.
- Risk heatmaps colored from adjectives.
- Any chart whose numbers came from the model rather than from the repo, the probe, or a cited source.

The test is one line: **name the measurement.** If you cannot say where a number came from, it does not get drawn.

Inline SVG or a `<pre class="mermaid">` block. Diagrams need a text alternative in the prose, because the report gets read on a phone and gets skimmed.

## Voice

Direct, slightly informal, compressed. No em-dashes. No "it is worth noting that", "delve", "moreover", "in essence". No throat-clearing. Say each thing once.

Past tense in the "If I did it" section, present tense everywhere else. The tense shift is the signal that the reader has crossed into the counterfactual, so keep it clean.
