# Changelog

Dated versioning, most recent release first.

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
