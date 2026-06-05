# hiveplotlib-agent-harness

Skills, agents, commands, and shared mental model for developing hiveplotlib and running research against it. Mounted as a git submodule of hiveplotlib at `hiveplotlib/agent-harness/` (pinned per-consumer, bumpable via `make bump-harness`). Tuned for hiveplotlib's stack (pytest `-n 7`, ruff/ty, 100% coverage, optional-backend markers). Also drives meta-work on itself and on the wiki repo; the orchestrator's Consumer parameter section names the three known consumers.

Distributed into the consumer's `.claude/` by `bash sync.sh`. Defaults to syncing into the parent directory when it looks like a consumer (has `pyproject.toml` or `.claude/`); pass the consumer path explicitly otherwise. Sync uses file copies because WSL symlinks aren't followed by Windows-side tools accessing via UNC paths.

## Trip-wires

- **Halt on confusion; never self-recover or run destructive ops.** See `mental-model` rule 9 for the trigger taxonomy and the absolute ban on destructive operations (no `git checkout -- <path>`, no `git reset --hard`, no `Write` over an un-read file, no silent substitution, etc.).
- **Test name = test body contract.** Shipped artifacts must not carry rationalization prose bridging a substitution against the brief. If an obstacle to the brief surfaces, halt under rule 9.
- **Scratch artifacts go to `/tmp/`, not the project tree.** See `mental-model` rule 16. The working tree is git-tracked space; even untracked PNG dumps, intermediate data exports, and helper scripts clutter `git status` and risk accidental commits during a `git add .`.

## Layout

- `.claude/skills/mental-model/` — shared mental model loaded by every agent. **Start here.**
- `.claude/skills/viz-quality-bar/` — viz principles, polish-in-proportion, hive-plot-specific rules, datashader specifics, empirical patterns.
- `.claude/skills/hiveplotlib-tutorial-notebook/` — tutorial-style notebook conventions.
- `.claude/skills/hiveplotlib-gallery-notebook/` — gallery-style notebook conventions.
- `.claude/agents/orchestrator.md` — produces plans (`initial-plan` and `amend-plan` modes).
- `.claude/agents/api-critic.md` — dual-role API ergonomics review (planning + post-impl).
- `.claude/agents/research-liaison.md` — wires the dev loop to the research wiki; owns ADR promotion.
- `.claude/agents/code-engineer.md` — implements workstreams.
- `.claude/agents/test-engineer.md` — writes pytest tests, applies optional-dep markers, maintains 100% coverage.
- `.claude/agents/docs-engineer.md` — writes docstrings, autodoc, notebook index entries.
- `.claude/agents/notebook-author.md` — creates or updates `examples/` notebooks. Defers style to the tutorial/gallery skills.
- `.claude/agents/viz-critic.md` — read-only review of rendered figures.
- `.claude/agents/editorial-critic.md` — read-only review of a notebook's structure, scope, dataset coherence, and genre against the notebook skills.
- `.claude/agents/qa-engineer.md` — runs tests/lint/type/doc-build, audits replace-and-sweep, checks Implementation log + CHANGELOG.
- `.claude/commands/` — harness-generic slash-command entry points distributed by `sync.sh`. Consumer-specific commands belong in `<consumer>/.claude/commands/`.
- `.claude/settings.json` — harness-managed Claude Code settings (permissions, enabled plugins). Distributed by `sync.sh`; the consumer's copy is overwritten every sync. See "Settings ownership" below.
- `.claude/templates/plan-template.md` — canonical plan template.
- `sync.sh` — copies skills, agents, commands, and settings.json into a consumer's `.claude/`.

## Settings ownership

`<consumer>/.claude/settings.json` is harness-managed: `sync.sh` overwrites it from `agent-harness/.claude/settings.json` every run. Consumer overrides (additional `enabledPlugins`, extra `Bash`/`Read` permissions) live in `<consumer>/.claude/settings.local.json`, which `sync.sh` never touches.

Currently shipped: `Edit`/`Write` on `agent-harness/.claude/expertise/**` (for rule-11 expertise updates), and `skill-creator@claude-plugins-official` enablement.

Defensive backup: if the consumer's pre-existing `.claude/settings.json` differs from the harness template at sync time, it's copied to `.claude/settings.json.pre-harness-sync.bak` with a warning. Migrate content to `.claude/settings.local.json` and delete the `.bak`.

## The dispatching session

The dispatching session is the consumer-repo Claude Code conversation the maintainer types into. Not a sub-agent, no agent definition. Dispatches sub-agents, surfaces their reports, asks for confirmation between workstreams.

### Invocation triggers

- **Task start (non-trivial).** Run research-liaison in pre-task mode, then invoke orchestrator in `initial-plan` mode with findings in the brief. The orchestrator writes the plan; surface the path and pause for review.
- **Plan produced or substantially amended (non-trivial).** After the orchestrator writes (`initial-plan`) or materially amends (`amend-plan`) a plan, and before dispatching any workstream, offer the maintainer a grill-me alignment pass (recommended for major/long plans). Record each wave in the plan's `## Alignment (grill)` section; route any resulting change to orchestrator `amend-plan`. When recommending the next dispatch, surface an unfilled `## Alignment (grill)` gate so the maintainer can run it or knowingly skip it.
- **Plan accepted.** Invoke the named specialist for each workstream as the maintainer green-lights it.
- **Workstream that adds or modifies user-facing API.** Invoke api-critic in post-impl mode after the implementing specialist finishes. Applies to mechanical propagations to sibling classes (e.g., `HivePlotMatrix` mirroring `HivePlot`).
- **Workstream that produces or changes a figure.** Invoke viz-critic in post-impl mode.
- **Workstream that adds or restructures a notebook.** Invoke editorial-critic in post-impl mode after the notebook-author finishes. It reviews the notebook's structure and scope (right notebook, dataset coherence, genre, section-worth); viz-critic covers the figures in the same notebook.
- **Workstream complete.** Invoke qa-engineer for release-readiness verification. If a critic post-impl section is still `Pending`, qa flags `must-fix` and the dispatching session invokes the missing critic before proceeding.
- **Mid-flight emergent work** (post-impl critic `must-fix` or `should-fix`, or any user ask that would change the workstream set per rule 14). Route to orchestrator in `amend-plan` mode before any other dispatch. The orchestrator edits the plan; the dispatching session does not edit the plan directly.
- **All workstreams complete, plan non-trivial.** qa-engineer surfaces a `worth-discussing` ADR-promotion concern. When the maintainer green-lights, invoke research-liaison.

### Sub-agent discipline

Sub-agents do not invoke other sub-agents. Every invocation comes from the dispatching session. This keeps each sub-agent's context clean, the topology simple, and preserves checkpoint moments between agent calls.

Apparent exception: the orchestrator's `initial-plan` step 2 references research-liaison's pre-task findings. The dispatching session runs research-liaison first and includes the findings in the orchestrator's brief; the orchestrator itself does not invoke anything.

### Between workstreams

Surface the completing agent's report (status, files touched, open questions), name the next dispatch, pause for the maintainer's confirmation. The dispatching session does not implement work itself — reading source, editing code, or running `make` from the dispatching session for a plan-driven task is a process violation.

## Plans

Hiveplotlib plans live in the wiki submodule at `hiveplotlib/wiki/wiki/plans/<topic>.md` (tracked in the wiki repo, survives across machines). Harness-self plans live at `agent-harness/.claude/plans/<topic>.md` (gitignored; the harness has no wiki dependency).

Path resolution per consumer:

- `hiveplotlib` → `hiveplotlib/wiki/wiki/plans/<topic>.md`
- `hiveplotlib-llm-wiki` (planning a wiki-structure change) → `<wiki-repo>/wiki/plans/<topic>.md` (same physical file as hiveplotlib's path)
- `agent-harness` (planning a harness change) → `agent-harness/.claude/plans/<topic>.md`

Plans are working scratch, not curated wiki content; `wiki/wiki/plans/README.md` carries the disclaimer for browsers. Major plans promote to ADRs at `wiki/wiki/adr/NNNN-topic.md` per `mental-model` rule 10. Harness-self plans don't promote; the harness CHANGELOG is their durable record.

**Active vs. archived (wiki plans only).** New plans start in `wiki/wiki/plans/`. Once a plan's work has fully shipped, it moves to `wiki/wiki/plans/archived/<topic>.md`, so the active directory shows only in-flight work. Listing active plans uses the top-level glob `wiki/wiki/plans/*.md` (excludes `archived/`); resolving a referenced plan checks `archived/` as a fallback. Research Liaison proposes the move; the user confirms and performs it (agents never move plan files). Harness-self plans stay flat.
