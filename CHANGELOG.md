# Changelog

A summary of major structural changes as the agentic harness evolves.

Dated versioning, most recent release first.

## Unreleased

## 2026.09.01

This cycle extends the harness beyond building code into also supporting *doing research*: a bounded, adversarially
validated research capability that rides the same spine as a code plan, with a focus on keeping a run cheap, staying
scientifically honest, and durably saving what it finds instead of burning the budget for nothing.

The cycle also puts a **spec** above every code plan: a one-page signed statement of intent that the maintainer reads
and signs before any plan exists, and that every later stage answers to. Plans, the per-workstream gate, the adversary,
and qa all now check against the spec, so a change of intent is a visible re-sign rather than a silent drift.

The cycle also adapts ideas from reviewing the harness against
[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (reviewed at version `0.6.3`, July 2026):
adversarial-review hardening, a security audit, a pre-plan interview, opt-in auto-dispatch, and changelog discipline.

A second review, against [mattpocock/skills](https://github.com/mattpocock/skills) (August 2026), shaped several of the
entries below: `grilling` sharpened how `grill-me` asks, `wait-what` became the `clarify` skill, `to-questionnaire` and
`wayfinder` gave the plan template its `## Maintainer questionnaire` and `## Not yet plannable` sections, `wizard` was
pared down to a point-don't-describe rule (its bash-script form deliberately rejected), and that repo's skill-writing
principles became the harness's own. The delivery-shape convention was prompted by `wayfinder`'s map-above-tickets
framing.

Visualization review now reads two skills. The general figure bar moved out to `agent-viz`, and `viz-quality-bar`
keeps only hive-plot house style. This is the harness's first external dependency, and it does not install itself: a
consumer needs two manual commands before the general bar is available, and `sync.sh` prints them when it is missing.

### Model Compatibility

Reviewed the harness against Claude Fable 5 (in contrast to Opus 4.8). Implemented some suggested changes: moving the
deterministic qa audits into a script, hardening a few gates against silent failure and lost work, and filling small
gaps left by the recent adversary and research additions.

### Added

- `grill-me` **brief mode**: the harness can now interview the maintainer before planning when the ask is fuzzy, and
  each plan records whether it ran or was knowingly skipped.
- Security audit in `qa-engineer`: dependencies get audited and security-relevant changes get a sanity check before
  code is recommended to the maintainer.
- Performance check in `qa-engineer`: touching library source now gets the consumer's perf/equivalence suite run, plus
  the heavier benchmark sanity pass at plan end; regressions block unless the maintainer has recorded the trade.
  Placed as a trip-wire plus a qa step, not a mental-model rule, the same call as the security audit.
- Excuse+rebuttal ratchet in `mental-model`: caught rationalizations get written down next to the rule they dodged,
  so the same excuse doesn't work twice.
- Opt-in **auto-dispatch mode**: approve a plan once ("run it through") and it runs gate-to-gate, with no
  between-workstream stops unless something actually needs the maintainer.
- **`research-track`**: the harness can now do research, not just build code; runs stay bounded and cheap, get
  adversarially checked, and land a durable page wherever the consumer keeps one.
- `audit.sh`: qa-engineer's deterministic audits (plan scaffolding, test-name contract, rationalization markers,
  CHANGELOG cap) now run as a script qa interprets, so every pass runs the same checks instead of re-deriving greps
  from prose.
- Plan template gains a `## Viz review` post-impl section, closing a gap where qa checked for a viz-critic section
  that had no home in the template.
- The security and performance checks now read the diff to decide whether they apply, so qa can't mistakenly skip
  either on a change that needed it.
- Plan template: `## Not yet plannable` parks work too foggy to spec, and `## Maintainer questionnaire` parks decisions
  waiting on the maintainer (answered in chat, transcribed by an agent, surfaced in every workstream report). Settled
  names carry forward as the vocabulary later sessions reuse.
- The dispatching session argues the sliced-MR case when a plan outgrows one reviewable MR (the call stays the
  maintainer's, recorded in the plan); a user-invoked `clarify` skill restates a message that didn't land; agents hand
  the exact link and steps for maintainer-only actions; and unrequested work that looks wrong pauses for clarification.
- Skill authoring gets three standing principles: a description names when the skill applies, model-invocable vs
  user-only is chosen explicitly, and every skill edit is checked against growth.
- Multi-agent executions now report agents dispatched, peak concurrency, and approximate tokens (basis named, "unknown"
  when unmeasurable), with a plan total at plan end; the weekly dream watches whether the new mechanisms get used.
- Specs: a one-page intent artifact stating the outcome and the literal call shape a user types, signed by the
  maintainer before any plan is written; plans serve specs, any later change is a dated re-sign only the maintainer
  approves, and the per-workstream gate, the adversary, and qa now check the work (claimed at dispatch, shipped at
  review) against the spec rather than the plan alone.

### Changed

- The adversary's post-impl pass now reads the shipped diff before it reads the plan's justifications, so its attack
  starts from the artifact rather than the author's framing.
- CHANGELOG entries are now hard-capped at a few lines and written at maintainer altitude; `qa-engineer` compresses
  offenders, and natural phrasing beats abbreviation soup.
- In-place prose auto-fixes carry a provenance guard as a rule-7 invariant: committed text may be fixed in place,
  uncommitted text gets a ready-made proposed fix instead. Hoisted from qa expertise after a real loss.
- The adversary's post-impl blind-first read is now structural: a two-message dispatch hands a scratch extract first
  and the plan path only after the raw findings land.
- `research-track` names the selection rule when claims outgrow the verify-voucher pool; unverified claims are
  labeled and treated as ungrounded at convergence.
- The weekly harness-reflection dream also consolidates the expertise files (merge, compress, prune), parallel to
  its memory pass, so per-task writes don't bloat them indefinitely.
- Plan files get an explicit section-ownership convention: each agent writes only its own sections, and the
  dispatching session serializes shared appends under concurrent dispatch.
- A minor review nit no longer forces a re-planning round-trip in default mode; the maintainer just says amend,
  defer, or skip at the checkpoint (nits that affect later work still route automatically). `must-fix` is unchanged.
- `grill-me` leads its questions with a recommended answer, sends agents to dig up facts instead of asking the
  maintainer, settles delivery shape, and holds dispatch until the maintainer confirms shared understanding.
- `research-track` bounds are now the pre-flight estimate as a binding total (exceed it only by surfacing a revised
  estimate first), a concurrency ceiling of 8, and consumption reported honestly rather than gated.
- A research run's landing target follows the consumer: a wiki page where there is a wiki, and on the harness itself
  an expertise entry or a CHANGELOG line rather than another repo's wiki.
- Figures are now reviewed against two skills: [`agent-viz`](https://github.com/gjkoplik/skills/tree/main/plugins/agent-viz)
  for the general figure bar, and `viz-quality-bar`, cut down to hive-plot house style. Both apply to any figure a
  person will look at, not just hive plots. `agent-viz` is an external plugin whose install is manual (two commands,
  printed by `sync.sh`), and `viz-quality-bar` says what a reader is missing when it is absent.
- `api-critic` and `qa-engineer` now check that a claimed benefit is reachable: the post-impl pass walks whether a
  user can obtain what a workstream promises, and a recorded performance figure has to name the user-reachable path
  it came off (`audit.sh` decides when that applies, so an `n/a` can't hide a check nobody ran).
- The orchestrator's feasibility audit now fires on settings added to an existing object, traced through everything
  that rebuilds or resets it, so one the next rebuild would silently undo gets caught while it is still a proposal.

### Fixed

- Routing vocabulary matches the tags critics actually emit; a tag that was documented but never emitted is retired.
- Agents can write their own expertise files regardless of which repo the session was opened from.
- A sub-agent's governing skill is read by path at task start, with a short labeled summary as a fallback, for the
  notebook author, viz critic, and editorial critic. No definition claims a skill loads itself any more, because a
  sub-agent never loaded one. Instructed reads land about half the time, so this raises the floor rather than
  guaranteeing arrival.
- A session's skill list is not fixed at session start. That claim is out of two expertise files; the barrier it
  described was an unsynced consumer copy.
- `viz-quality-bar` carries the partition-design rule `viz-critic` was already reviewing against.
- `viz-quality-bar` and `notebook-author` state one matplotlib customization budget rather than two 10x apart, so a
  figure can no longer be compliant when written and flagged in review.
- Corpus greps are scoped to tracked files; `examples/.ipynb_checkpoints/` was roughly doubling every count.
- `audit.sh` no longer reports `clean` off a sweep that read no files; an empty sweep reports `skipped`. On the
  harness itself the scaffolding sweep covers `.claude/` and the root markdown, which is what the harness ships, so
  rule 15 is checked on harness-self work; `plans/`, `expertise/` and `templates/` are excluded as definition sites
  for the swept strings. The rationalization audit reports `excluded` there, its markers being ordinary English in
  agent prose.

## 2026.07.03

First pass at adding an adversarial component to the harness, plus formalizing regularly-updated support for Hiveplotlib
usage by LLMs.

### Added

- `adversary` agent: cold-context dissent, the structural fix for model sycophancy (grill-me is inline and run by the
  agreeable dispatching session; the orchestrator cannot attack its own premise). Dual-mode (a cold planning challenge
  before grill-me, a post-impl attack on the shipped artifact), read-only, propose-only, and mandatory on every plan
  (`mental-model` rule 18). Anchored on a maintainer-authored `## Failure modes` rubric that a new grill-me elicitation
  wave populates, so the standard is the maintainer's rather than the model's.
- `hiveplotlib-api-usage` skill: how to drive the published API from downstream/research repos, so agents stop
  reconstructing it wrong from source. Synced into consumer repos only, never the library itself (where it would fight
  in-flight API changes). The `harness-reflection` dream now maintains it alongside the docs'
  `llms.txt` / `llms-full.txt`.

## 2026.06.22

Changes after running on several additional Hiveplotlib implementation plans through the release of Hiveplotlib v0.28.

Notable additions: added a weekly dreaming routine, a /grill-me skill invocation confirming human-agent alignment before dispatch on major plans, a new editorial critic, and a file to store agent-agnostic and personal feedback.

### Model Compatibility

Reviewed the harness against Claude Opus 4.8 (in contrast to Opus 4.7). Found already-aligned; no additional rule
changes needed.

### Added

- Version-controlled scheduled routines: a new `.claude/scheduled-tasks/` directory holds canonical,
  machine-agnostic `SKILL.md` definitions plus a README documenting the source-of-truth and how to deploy routines.
  This way, the routines are reviewable and portable instead of living only in the desktop app's store.
  - `harness-reflection`: weekly "dreaming" run that mines the past week's session transcripts for
    recurring mistakes and leaves uncommitted edits to the expertise gotchas (plus a memory-consolidation
    pass) for review. A local reproduction of Anthropic's Dreams; no data leaves the machine.
  - `wiki-update`: a weekly wiki run that updates against code changes plus a quick web search for anything new with
    hive plots; writes a digest and notifies on completion.
- `personal-gotchas.md` expertise file: a home for cross-cutting gotchas not owned by a single role
  (environment, shell, working-style), with an explicit fallback-not-default routing rule so the per-role
  playbooks stay the preferred target. Wired so every agent and the dispatching session read it at task
  start in addition to any role file.
- `editorial-critic` agent: read-only review of a notebook as a whole artifact (right notebook for the content,
  dataset coherence, genre fit, section-worth), parallel to viz-critic's figure pass. Closes the gap where no agent
  owned notebook structure and scope.
- Orchestrator notebook-coherence audit at planning time, and an amend-plan check that surfaces scope-crossing notebook
  fixes (wrong notebook, changed dataset set) for sign-off rather than applying them silently.
- `grill-me` skill: a Socratic alignment pass the dispatching session runs inline over a plan or task before dispatch,
  confirming human-agent alignment.

### Changed

- Expertise entries are kept leaner and no longer carry a provenance pointer to the plan or workstream a lesson came
  from. Reflected in the shared expertise-file header.
- Plans, plan amendments, and ADRs now have a per-artifact concision standard so each reads directly instead of being
  skimmed past for a summary.
- Gallery skill gains a scope-discipline section (prefer one dataset, keep a page focused on the class it documents,
  plus 2-3 axes and length notes); the tutorial skill, already covering most of this, gains a one-line dataset-drift
  note.

### Fixed

- Auto-mode sometimes blocked agent from expertise writes on the harness. Resolved by adding harness-managed
  `.claude/settings.json` shipped by `sync.sh`, ensuring agents have `Edit`/`Write` on
  `agent-harness/.claude/expertise/**` (and including the Claude `skill-creator` plugin).
- Version controlled test artifacts were being created. Added text requesting test artifacts to go to `/tmp/` (and
  gitignored `hiveplotlib/tmp/` as an extra line of defense).
- Docs were being built to default `sphinx` directory instead of the supported `make docs` location (`public`). Added
  more language requiring docs build using `make` tools (and gitignored the `sphinx` default `docs/build` as an extra
  line of defense).
- Test engineer was writing test docstrings in the context of bugs (which becomes stale information after the
  fix), instead of solely what the test is testing. Added anti-pattern note for `test-engineer` agent.
- Tests were also narrating harness internals in their docstrings (which plan item a critic flagged, what the user
  resolved), which leaks process metadata into shipped code. Clarified in mental model skill and test engineer agent
  files.
- A test was checking a wrapper's name and docstring wording, but those only affect how the docs and `help()` read,
  not what the code actually does. Added a rule: tests check behavior, and how things read in the docs is left to
  docs review.
- Removed discussion of never-shipped `HivePlot.from_networkx` classmethod; updated to the shipped `HivePlot(graph=...)`
  surface across the notebook skills, notebook-author, orchestrator, and code-engineer.

## 2026.05.25

Some revisions after applying and updating the harness over a single Hiveplotlib sprint.

### Added

- Halt-on-confusion discipline that prevents agents from self-recovering on unexpected state, with an absolute ban on
  destructive git and filesystem operations. Enables safe concurrent agent dispatch.
- Mid-flight scope changes route back through the plan owner rather than being applied ad-hoc.
- ADR promotion: major plans distill into durable architecture decision records once the work ships.
- Audits that prevent silent substitution of one entry point for another in shipped artifacts.
- Living changelog inside the harness for harness-self changes, distinct from the consumer's changelog.

### Changed

- Compressed the wording of the harness across every file.
- Plan template requires runnable code in API usage examples.
- Verification standardized on project-defined wrappers (e.g. `make` targets) rather than raw tool invocations.
- Plan-internal scaffolding (workstream labels, phase numbers) banned from shipped artifacts.
- When using harness as submodule in Hiveplotlib, plans now passed to wiki.

## 2026.05.10

First pass at creating an agent harness for hiveplotlib. **Not yet tested on real work.**

Includes the `mental-model`, `viz-quality-bar`, `hiveplotlib-tutorial-notebook`, and `hiveplotlib-gallery-notebook`
skills, the plan template, the `sync.sh` distributor (with manifest-based orphan tracking so consumer-specific files in
`.claude/` are never touched), per-agent expertise files (curated playbooks, not logs), and the agents listed below:

- `orchestrator` — produces plans
- `api-critic` — dual-role API ergonomics review (planning + post-impl)
- `research-liaison` — wires the dev loop to the research wiki; owns ADR promotion
- `code-engineer` — implements workstreams
- `test-engineer` — writes pytest tests
- `docs-engineer` — writes docstrings and prose docs
- `notebook-author` — creates or updates Jupyter notebooks
- `viz-critic` — read-only review of rendered figures
- `qa-engineer` — runs tests/lint/type/doc-build, checks release-readiness, switches to formal diagnostic mode on
  test-failure escalation

Full inventory and conventions in [`CLAUDE.md`](CLAUDE.md).
