# hiveplotlib-agent-harness

Source of truth for skills, agents, commands, and shared mental model used to develop hiveplotlib and run research against it. Lives at `hiveplotlib/agent-harness/` as a tracked git submodule of hiveplotlib (pinned to a specific commit; bumpable via `make bump-harness` from hiveplotlib). The harness also drives meta-work on itself and on the `hiveplotlib-llm-wiki` repo when needed (the orchestrator's "Consumer parameter" section names the three known consumers), but the agents and skills are tuned for hiveplotlib's stack (pytest with `-n 7`, ruff/ty, 100% coverage, optional-backend markers). Treat this as hiveplotlib's harness; the cross-consumer routing is for adjacent meta-work, not a portability claim.

Distributed into the consumer's `.claude/` by `bash sync.sh` from the harness root; the script defaults to syncing into the parent directory when that parent looks like a consumer (has `pyproject.toml` or `.claude/`), otherwise pass the consumer path explicitly. Sync uses file copies because WSL symlinks aren't followed by Windows-side tools accessing via UNC paths.

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
- `.claude/commands/`: user-typed slash-command entry points distributed by `sync.sh` to every consumer. Use this for shared, harness-generic commands. Currently empty. **Consumer-specific commands** (referencing project-specific paths or agents) belong in `<consumer>/.claude/commands/` directly, where they stay machine-local (gitignored) unless the consumer chooses to track them separately.
- `.claude/templates/plan-template.md`: canonical plan template used by every plan in `<consumer-repo>/.claude/plans/`.
- `sync.sh`: copies the harness's skills and agents into a consumer repo's `.claude/`. Auto-discovers skills (directories) and agents (`.md` files). Run from inside the consumer repo, or with the consumer path as an argument.

## The dispatching session

The "dispatching session" is the consumer repo's main Claude Code conversation, the one Gary types into. It is not a sub-agent and has no agent definition. It dispatches the sub-agents listed in Layout, surfaces their reports back to Gary, and asks for confirmation between workstreams. This section consolidates the implicit role so the main session has somewhere to point at.

### Invocation triggers

Mapping from task phase to agent invocation:

- **Task start (non-trivial work).** Invoke research-liaison in pre-task mode to surface prior ADRs, then invoke the orchestrator in `initial-plan` mode with those findings included in the task brief. The orchestrator produces the plan at `<consumer-repo>/.claude/plans/<topic>.md`. Surface the plan path to Gary and pause for review.
- **Plan accepted.** Invoke the named specialist for each workstream as Gary green-lights it. The plan recommends which specialist owns each workstream; the dispatcher confirms and dispatches.
- **Workstream that adds or modifies user-facing API.** Invoke api-critic in post-implementation mode after the implementing specialist (code-engineer and/or notebook-author) finishes. This applies even to mechanical propagations to sibling classes (e.g., `HivePlotMatrix` mirroring `HivePlot`). The api-critic fills the plan's "API Critic — post-implementation review" section.
- **Workstream that produces or changes a figure.** Invoke viz-critic in post-implementation mode. Same shape as api-critic.
- **Workstream complete.** Invoke qa-engineer for release-readiness verification. The qa-engineer runs tests/lint/type/docs, audits replace-and-sweep, verifies Implementation log + CHANGELOG currency, and (per rule 7) auto-fixes deterministic issues and proposes taste calls. If a critic post-impl review section is still `Pending — ...`, qa flags `must-fix` and the dispatching session invokes the missing critic before proceeding.
- **Mid-flight emergent work** (post-impl critic finding tagged `must-fix` or `should-fix`, or any user ask that would change the workstream set). Route through the orchestrator in `amend-plan` mode per rule 14. The dispatching session reads the trigger, invokes orchestrator-amend-plan, and continues from the orchestrator's dispatch recommendation. The orchestrator edits the plan's "Plan amendments" section; the dispatching session does not edit the plan directly.
- **All workstreams complete, plan non-trivial.** qa-engineer surfaces a `worth-discussing` proposed concern recommending ADR promotion. When Gary green-lights, the dispatching session invokes research-liaison for the promotion.

### Sub-agent invocation discipline

Sub-agents do not invoke other sub-agents. Every agent invocation comes from the dispatching session. This keeps each sub-agent's context clean (no nested transcripts), keeps the topology of the harness simple (one caller, many leaves), and preserves natural human checkpoint moments between agent calls so Gary can review diffs, course-correct, or skip ahead.

Apparent exception, handled by routing: the orchestrator's `initial-plan` workflow step 2 describes pulling prior ADRs "via research-liaison in pre-task mode". The orchestrator does not have access to the Agent tool and cannot invoke research-liaison itself. The dispatching session is the one that physically runs research-liaison BEFORE invoking the orchestrator, then includes the findings in the orchestrator's task brief. The orchestrator then surfaces relevant entries into the plan's "Prior ADRs / design docs" section.

### Checkpointing rhythm

Between workstreams, the dispatching session:

1. Surfaces the completing agent's report (status, files touched, open questions).
2. Names the next dispatch (per the plan's workstream sequence or the orchestrator's amend-plan recommendation).
3. Pauses for Gary's confirmation before invoking the next agent. Even in auto mode, between workstreams is a natural human checkpoint.

The dispatching session does not implement work itself. It dispatches, summarizes, and checkpoints. Reading source files, editing code, or running `make` targets in the dispatching session for a plan-driven task is a process violation; those actions belong inside an agent.

## Plans

Plans for hiveplotlib work do not live here. They live at `hiveplotlib/.claude/plans/<topic>.md` (or the equivalent path for other consumer repos). The harness owns the template; the consuming repo owns the plans for its own work.

When the harness is its own consumer (plans for changes to the harness itself), plans live at `.claude/plans/` inside this repo and are gitignored. Same throw-away convention as in any consumer: durable knowledge gets promoted to an ADR in the wiki, not preserved as a tracked plan file.

