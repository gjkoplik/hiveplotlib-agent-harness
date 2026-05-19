# Changelog

A summary of major structural changes as the agentic harness evolves.

Dated versioning, most recent release first.

## [WIP]

Some revisions after applying the harness on a few Hiveplotlib development tasks.

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
