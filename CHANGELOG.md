# Changelog

A summary of major structural changes as the agentic harness evolves.

Dated versioning, most recent release first.

## WIP

### Model Compatibility

Reviewed the harness against Claude Opus 4.8 (in contrast to Opus 4.7). Found already-aligned; no rule changes needed.

### Added

- `editorial-critic` agent: read-only review of a notebook as a whole artifact (right notebook for the content, dataset coherence, genre fit, section-worth), parallel to viz-critic's figure pass. Closes the gap where no agent owned notebook structure and scope.
- Orchestrator notebook-coherence audit at planning time, and an amend-plan check that surfaces scope-crossing notebook fixes (wrong notebook, changed dataset set) for sign-off rather than applying them silently.

### Changed

- Revised mental model skill to more strictly encourage terser entries going forward.
- Gallery skill gains a scope-discipline section (prefer one dataset, keep a page focused on the class it documents, plus 2-3 axes and length notes); the tutorial skill, already covering most of this, gains a one-line dataset-drift note.

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
- Removed discussion of never-shipped `HivePlot.from_networkx` classmethod; updated to the shipped `HivePlot(graph=...)` surface across the notebook skills, notebook-author, orchestrator, and code-engineer.

## 2026.05.25

Some revisions after applying and updating the harness over a single Hiveplotlib sprint.

### Added

- Halt-on-confusion discipline that prevents agents from self-recovering on unexpected state, with an absolute ban on destructive git and filesystem operations. Enables safe concurrent agent dispatch.
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

Includes the `mental-model`, `viz-quality-bar`, `hiveplotlib-tutorial-notebook`, and `hiveplotlib-gallery-notebook` skills, the plan template, the `sync.sh` distributor (with manifest-based orphan tracking so consumer-specific files in `.claude/` are never touched), per-agent expertise files (curated playbooks, not logs), and the agents listed below:

- `orchestrator` — produces plans
- `api-critic` — dual-role API ergonomics review (planning + post-impl)
- `research-liaison` — wires the dev loop to the research wiki; owns ADR promotion
- `code-engineer` — implements workstreams
- `test-engineer` — writes pytest tests
- `docs-engineer` — writes docstrings and prose docs
- `notebook-author` — creates or updates Jupyter notebooks
- `viz-critic` — read-only review of rendered figures
- `qa-engineer` — runs tests/lint/type/doc-build, checks release-readiness, switches to formal diagnostic mode on test-failure escalation

Full inventory and conventions in [`CLAUDE.md`](CLAUDE.md).
