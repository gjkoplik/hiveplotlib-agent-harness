# Changelog

A summary of major structural changes as the agentic harness evolves.

Dated versioning, most recent release first.

## Unreleased

This cycle extends the harness beyond building code into also supporting *doing research*: a bounded, adversarially
validated research capability that rides the same spine as a code plan, with a focus on keeping a run cheap, staying
scientifically honest, and durably saving what it finds instead of burning the budget for nothing.

The cycle also adapts ideas from reviewing the harness against
[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (reviewed at version `0.6.3`, July 2026):
adversarial-review hardening, a security audit, a pre-plan interview, opt-in auto-dispatch, and changelog discipline.

### Added

- `grill-me` **brief mode**: the harness can now interview the maintainer before planning when the ask is fuzzy, and
  each plan records whether we bothered.
- Security audit in `qa-engineer`: dependencies get audited and security-relevant changes get a sanity check before
  code is recommended to the maintainer.
- Excuse+rebuttal ratchet in `mental-model`: caught rationalizations get written down next to the rule they dodged,
  so the same excuse doesn't work twice.
- Opt-in **auto-dispatch mode**: approve a plan once ("run it through") and it runs gate-to-gate, with no
  between-workstream stops unless something actually needs the maintainer.
- **`research-track`**: the harness can now do research, not just build code; runs stay bounded and cheap, get
  adversarially checked, and land durable wiki pages.

### Changed

- The adversary's post-impl pass now reads the shipped diff before it reads the plan's justifications, so its attack
  starts from the artifact rather than the author's framing.
- CHANGELOG entries are now hard-capped at a few lines and written at maintainer altitude; `qa-engineer` compresses
  offenders, and natural phrasing beats abbreviation soup.

### Fixed

- Routing vocabulary now matches the tags critics actually emit; a phantom tag no one ever used is retired.

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
