# hiveplotlib-agent-harness

Source of truth for skills, agents, commands, and shared mental model used to develop hiveplotlib and run research against it. **Intended to live at `<consumer-repo>/agent-harness/`** as a tracked git submodule of the consumer (pinned to a specific commit; bumpable via `make bump-harness` from the consumer). Distributed into the consumer's `.claude/` by `bash sync.sh` from the harness root; the script defaults to syncing into the parent directory when that parent looks like a consumer (has `pyproject.toml` or `.claude/`), otherwise pass the consumer path explicitly. Sync uses file copies because WSL symlinks aren't followed by Windows-side tools accessing via UNC paths.

## Layout

- `.claude/skills/mental-model/SKILL.md`: shared mental model loaded by every agent. Workflow rules, library invariants, prose voice. Points at the viz-quality-bar skill for viz work. **Start here.**
- `.claude/skills/viz-quality-bar/SKILL.md`: foundational viz principles (Knaflic + Tufte + accessibility), polish-in-proportion-to-role rule, hive-plot-specific rules, datashader specifics, interactive backends, operational checks, empirical patterns from the hiveplotlib examples corpus. Loaded by viz-touching agents.
- `.claude/skills/hiveplotlib-tutorial-notebook/SKILL.md`: tutorial-style notebook conventions (long-form storytelling, motivation, rhetorical questions, real-data writeups). Loaded by Notebook Author when the workstream calls for a tutorial.
- `.claude/skills/hiveplotlib-gallery-notebook/SKILL.md`: gallery-style notebook conventions (short, focused, single-feature reference). Loaded by Notebook Author when the workstream calls for a gallery example.
- `.claude/agents/orchestrator.md`: produces plans from the template. Does not write code.
- `.claude/agents/api-critic.md`: dual-role API ergonomics review. Planning mode edits the plan's "API Critic's take" subsection; post-impl mode produces a friction list.
- `.claude/agents/research-liaison.md`: wires the dev loop to the research wiki (the `hiveplotlib-llm-wiki` repo, mounted as the consumer's `wiki/` submodule, with content under `wiki/wiki/`). Pre-task surfaces prior thinking and ADRs; post-task updates the wiki and owns ADR promotion.
- `.claude/agents/code-engineer.md`: implements workstreams from accepted plans. Does not commit.
- `.claude/agents/test-engineer.md`: writes pytest tests, mirrors source structure, applies optional-dep markers, maintains 100% coverage.
- `.claude/agents/docs-engineer.md`: writes docstrings, autodoc rst, notebook index entries. Preserves user-friendly framing.
- `.claude/agents/notebook-author.md`: creates or updates `examples/` notebooks. Delegates style to the harness's tutorial/gallery skills (`hiveplotlib-tutorial-notebook`, `hiveplotlib-gallery-notebook`). Applies polish-in-proportion-to-role.
- `.claude/agents/viz-critic.md`: read-only review of rendered figures. Confidence-tagged proposal list.
- `.claude/agents/qa-engineer.md`: runs tests/lint/type/doc-build, audits replace-and-sweep, checks the Implementation log and CHANGELOG, auto-fixes deterministic issues, switches to formal diagnostic mode on test-failure escalation, proposes taste-call concerns. Does not run git mutating commands.
- `.claude/commands/`: user-typed entry points. Not yet added.
- `.claude/templates/plan-template.md`: canonical plan template used by every plan in `<consumer-repo>/.claude/plans/`.
- `sync.sh`: copies the harness's skills and agents into a consumer repo's `.claude/`. Auto-discovers skills (directories) and agents (`.md` files). Run from inside the consumer repo, or with the consumer path as an argument.

## Plans

Plans for hiveplotlib work do not live here. They live at `hiveplotlib/.claude/plans/<topic>.md` (or the equivalent path for other consumer repos). The harness owns the template; the consuming repo owns the plans for its own work.

## Build phases

1. **Skeleton (complete):** mental-model skill, viz-quality-bar skill, plan template, Orchestrator, Code Engineer, QA Engineer.
2. **Specialists (complete):** Test Engineer, Docs Engineer, Notebook Author, Viz Critic, API Critic, Research Liaison.
3. Hooks and observability: PreToolUse guardrails, Stop verification, agent-action log.
4. Self-update / pull-from-source distribution.

Currently in: Phase 2 complete. Awaiting a real task to one-shot test the full harness end-to-end.
