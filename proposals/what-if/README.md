# Proposal: `what-if`

A **strawman**, not an accepted change. Nothing here is wired in: `sync.sh` only touches `.claude/skills`,
`.claude/agents`, `.claude/commands`, and `.claude/settings.json`, so this directory cannot reach a consumer repo.

Renamed from `if-i-did-it` and reframed after maintainer feedback. It is a cheap sunk-cost circuit breaker for
half-formed ideas, not a rigorous adoption report: brief by design, with progressive disclosure as the calibration
device (what stays collapsed depends on what the reader already knows).

## Settled

- **Cheap only.** No deeper mode. What the reader does next is theirs.
- **No handoff.** A plan is the sunk cost in another form. The report ends with the call.
- **Reports persist as version-controllable files**, written but never staged. The maintainer chooses what to keep.
  An HTML file for reading plus a markdown twin for diffing, since HTML does neither well in git.
- **No bundled agents.** Cheap-only removed the blind advocate/skeptic pair, so this is a plain skill directory
  rather than a plugin: one `SKILL.md` and one template. It can live as a personal skill, a project skill, or a
  plugin later without changing anything.

## Open

Placement. The prior recommendation was a personal marketplace repo, but `gjkoplik/agent-viz` may absorb this if it
gets generalized. **That question is unanswered here:** the remote for `agent-viz` holds one commit and a README,
and the maintainer reports substantial uncommitted local work that this session could not see. Do not conclude
anything about restructuring it from the remote alone.

## Status

`skill/SKILL.md` is written. `skill/assets/report-template.html` is not: the previous template was built for the
long-form design and does not fit. No grill, no adversary pass, no plan.
