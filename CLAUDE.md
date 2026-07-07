# hiveplotlib-agent-harness

Skills, agents, commands, and shared mental model for developing hiveplotlib and running research against it. Mounted as a git submodule of hiveplotlib at `hiveplotlib/agent-harness/` (pinned per-consumer, bumpable via `make bump-harness`). Tuned for hiveplotlib's stack (pytest `-n 7`, ruff/ty, 100% coverage, optional-backend markers). Also drives meta-work on itself and on the wiki repo; the orchestrator's Consumer parameter section names the three known consumers.

Distributed into the consumer's `.claude/` by `bash sync.sh`. Defaults to syncing into the parent directory when it looks like a consumer (has `pyproject.toml` or `.claude/`); pass the consumer path explicitly otherwise. Sync uses file copies because WSL symlinks aren't followed by Windows-side tools accessing via UNC paths.

## Trip-wires

- **Halt on confusion; never self-recover or run destructive ops.** See `mental-model` rule 9 for the trigger taxonomy and the absolute ban on destructive operations (no `git checkout -- <path>`, no `git reset --hard`, no `Write` over an un-read file, no silent substitution, etc.).
- **Every plan gets a cold adversarial read.** The `adversary` sub-agent (`.claude/agents/adversary.md`) is mandatory on every plan (it rides on rule 1: a plan exists iff the work is non-trivial). The dispatching session invokes it in planning mode for a cold pre-grill challenge *before* grill-me, then for a conditional post-grill rubric-check, and in post-impl mode on each shipped workstream. It is the structural fix for model sycophancy (grill-me is inline and run by the agreeable dispatching session). Sequencing lives under "Invocation triggers" below.
- **Test name = test body contract.** Shipped artifacts must not carry rationalization prose bridging a substitution against the brief. If an obstacle to the brief surfaces, halt under rule 9.
- **Scratch artifacts go to `/tmp/`, not the project tree.** See `mental-model` rule 16. The working tree is git-tracked space; even untracked PNG dumps, intermediate data exports, and helper scripts clutter `git status` and risk accidental commits during a `git add .`.
- **Workstreams touching CI, publishing, or dependency configuration get qa-engineer's security audit; it must not report `n/a` for them** (`n/a` is the honest default only when no security-relevant surface is touched).
- **Workstreams touching the consumer's library source get qa-engineer's performance check; it must not report `n/a (no executable change)` unless the diff is verifiably docstring/comment-only.**

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
- `.claude/commands/` — harness-generic slash-command entry points distributed by `sync.sh` (currently empty; grill-me ships as a skill, and the research track is conversational by design). Consumer-specific commands belong in `<consumer>/.claude/commands/`.
- `.claude/settings.json` — harness-managed Claude Code settings (permissions, enabled plugins). Distributed by `sync.sh`; the consumer's copy is overwritten every sync. See "Settings ownership" below.
- `.claude/templates/plan-template.md` — canonical plan template.
- `audit.sh` — deterministic qa audits (plan-scaffolding, test-name contract, rationalization markers, CHANGELOG cap) as a script qa-engineer runs and interprets; the prose specs in `qa-engineer.md` define the audits.
- `sync.sh` — copies skills, agents, commands, and settings.json into a consumer's `.claude/`.

## Settings ownership

`<consumer>/.claude/settings.json` is harness-managed: `sync.sh` overwrites it from `agent-harness/.claude/settings.json` every run. Consumer overrides (additional `enabledPlugins`, extra `Bash`/`Read` permissions) live in `<consumer>/.claude/settings.local.json`, which `sync.sh` never touches.

Currently shipped: `Edit`/`Write` on `agent-harness/.claude/expertise/**` (for rule-11 expertise updates) in both the consumer-relative and harness-relative forms (`.claude/expertise/**`), so the allowance holds whether a session is rooted at the consumer or at the harness repo itself; and `skill-creator@claude-plugins-official` enablement.

Defensive backup: if the consumer's pre-existing `.claude/settings.json` differs from the harness template at sync time, it's copied to `.claude/settings.json.pre-harness-sync.bak` with a warning. Migrate content to `.claude/settings.local.json` and delete the `.bak`.

## The dispatching session

The dispatching session is the consumer-repo Claude Code conversation the maintainer types into. Not a sub-agent, no agent definition. Dispatches sub-agents, surfaces their reports, asks for confirmation between workstreams.

### Invocation triggers

- **Task start (non-trivial).** First, the **brief-mode gate**: on every non-trivial brief, name whether grill-me's brief mode (pre-orchestrator extraction interview, one question at a time) ran or was knowingly skipped, so a silent non-offer is visible after the fact; the gate outcome lands as a line in the plan's `## Goal` at plan creation (the orchestrator writes it from the dispatch brief), so the record survives the transcript. Offer it when the brief underdetermines plan-shaping choices; the maintainer can also invoke it directly. Then run research-liaison in pre-task mode, then invoke orchestrator in `initial-plan` mode with the interview record (when one exists) and the liaison findings in the brief; the interview record lands in the plan's Goal/non-goals. The ordering (brief-mode interview → research-liaison pre-task → orchestrator) is deliberate: extraction sharpens what the liaison searches for; if planning judgment prefers another order for a given task, record why. The orchestrator writes the plan; surface the path and pause for review.
- **Research run against a consumer (conversational).** When the maintainer asks to research something for a consumer ("research whether X"), this is a research run, not a code task. It is invoked **conversationally** (no slash command; a slash command is a deferred option, not built). Invoke orchestrator in `research-plan` mode for the light research-plan shape, then run the bounded shallow-panel research per the `research-track` skill (the conventions home: N disjoint lenses fired as parallel Agent calls, the two standing lenses, two-layer grounding, the hard agent cap, and the durable `analyses/` landing via research-liaison). The shared adversary/grill spine applies (rule 18's phase-aware authority; grill-me's research failure-mode branch), same as any plan.
- **Plan produced or substantially amended (non-trivial).** After the orchestrator writes (`initial-plan`) or materially amends (`amend-plan`) a plan, invoke the **adversary in planning mode for its cold pre-grill challenge** (a did-not-author read) *before* offering grill-me. This is the plan's legitimacy pass: the plan is challenged before the maintainer invests any grilling. The adversary writes the plan's `### Adversary's challenge`. **Then** offer the maintainer a grill-me alignment pass (recommended for major/long plans), now armed with the adversary's challenge so the grill interrogates its items instead of re-deriving them. Record each grill wave in the plan's `## Alignment (grill)` section; route any resulting change to orchestrator `amend-plan`. When recommending the next dispatch, surface an unfilled `## Alignment (grill)` gate so the maintainer can run it or knowingly skip it. **Pre-grill escalation checkpoint:** when the adversary self-tags a finding `existential-must-fix` (the could-this-not-exist angle landing as "this plan should not exist"), the **dispatching session** surfaces a "reconsider before grilling" checkpoint to the maintainer *before* grill-me, a chance to abort without grilling. Two safety catches: the trigger is the adversary's own tag, not the dispatching session's judgment (so the agreeable hub cannot bury a banger), and the dispatching session surfaces it, not the plan-authoring orchestrator.
- **Grill's failure-mode wave ran (non-trivial).** After the grill's failure-mode wave names the modes into the plan's `## Failure modes` subsection, invoke the **adversary's light conditional post-grill rubric-check** (the same planning mode's second invocation) before dispatching any workstream: a delta-check of the plan against the *newly-named* modes only, appended to `### Adversary's challenge`. **Skip it** when the cold pre-grill pass already covered what the grill named (`Status: clean — no new modes to check`).
- **Plan accepted.** Invoke the named specialist for each workstream as the maintainer green-lights it. When the plan opted into auto-dispatch at acceptance (see "Between workstreams" below), the green-light is the one-time "run it through"; proceed workstream to workstream from there without per-workstream confirmation.
- **Workstream that adds or modifies user-facing API.** Invoke api-critic in post-impl mode after the implementing specialist finishes. Applies to mechanical propagations to sibling classes (e.g., `HivePlotMatrix` mirroring `HivePlot`).
- **Workstream that produces or changes a figure.** Invoke viz-critic in post-impl mode.
- **Workstream that adds or restructures a notebook.** Invoke editorial-critic in post-impl mode after the notebook-author finishes. It reviews the notebook's structure and scope (right notebook, dataset coherence, genre, section-worth); viz-critic covers the figures in the same notebook.
- **Workstream ships.** Invoke the **adversary in post-impl mode** on the shipped artifact, alongside the api-critic / viz-critic / editorial-critic post-impl passes. It attacks the diff blind first, then reads its own `### Adversary's challenge` and the orchestrator's disposition of it (plan-section-as-memory) and reconciles, writing `### Adversary post-impl`. Blind-first is **structural, via a two-message dispatch**: message 1 hands the diff scope plus a scratch extract the dispatching session copies to `/tmp/` (the workstream block under review, its done-when criteria, `## Failure modes`, and `## Holdouts` expected-survivor lists) and **withholds the plan path**; after the adversary reports its raw blind findings, message 2 (SendMessage continuation) hands the plan path for the reconcile and the final `### Adversary post-impl` write. `### Adversary's challenge`, its disposition in `## Plan amendments`, and prior `### Adversary post-impl` history stay off-limits until message 2. (Fallback when the extract was skipped: the adversary honors the contract by Grep offsets + ranged Reads, never a full-file Read in step 1.) A post-impl `must-fix` / `worth-discussing` routes to orchestrator `amend-plan` like the other critics (the planning challenge does not; the maintainer fights that in the grill).
- **Workstream complete.** Invoke qa-engineer for release-readiness verification. If a critic post-impl section is still `Pending` (api-critic, viz-critic, editorial-critic, or the adversary, whose post-impl attack is mandatory on every plan), qa flags `must-fix` and the dispatching session invokes the missing critic before proceeding.
- **Mid-flight emergent work** (post-impl critic finding, or any user ask that would change the workstream set per rule 14). A `must-fix` routes to orchestrator `amend-plan` before any other dispatch. A `worth-discussing` is maintainer-gated: surface it at the checkpoint with a recommendation (amend now / defer / decline) and route only on the maintainer's call, unless it bears on a downstream not-yet-run workstream (then it routes regardless). Under auto-dispatch the maintainer is absent, so a no-downstream-bearing `worth-discussing` batches to plan-end qa instead (see "Between workstreams" below). The orchestrator edits the plan; the dispatching session does not edit the plan directly.
- **All workstreams complete, plan non-trivial.** qa-engineer surfaces a `worth-discussing` ADR-promotion concern. When the maintainer green-lights, invoke research-liaison.

Net sequence with the adversary woven in: grill-me brief mode (optional first step, when a non-trivial brief underdetermines plan-shaping choices) → plan written/amended → adversary cold pre-grill challenge → grill-me post-plan grill (with its failure-mode wave) → conditional adversary post-grill rubric-check → dispatch workstreams → adversary post-impl per shipped workstream → qa-engineer.

### Sub-agent discipline

Sub-agents do not invoke other sub-agents. Every invocation comes from the dispatching session. This keeps each sub-agent's context clean, the topology simple, and preserves checkpoint moments between agent calls.

Apparent exception: the orchestrator's `initial-plan` step 2 references research-liaison's pre-task findings. The dispatching session runs research-liaison first and includes the findings in the orchestrator's brief; the orchestrator itself does not invoke anything.

### Between workstreams

Surface the completing agent's report (status, files touched, open questions), name the next dispatch, pause for the maintainer's confirmation. The dispatching session does not implement work itself — reading source, editing code, or running `make` from the dispatching session for a plan-driven task is a process violation.

**Auto-dispatch mode (opt-in, per plan).** Default off; the pause-per-workstream behavior above is unchanged unless the plan opted in. At plan acceptance the maintainer can say "run it through"; the utterance is recorded in the plan's `## Alignment (grill)` section (there is no plan-template marker; the recorded utterance is the opt-in). The dispatching session then proceeds workstream to workstream without the per-workstream confirmation. The per-workstream gate battery (critic post-impl passes, adversary post-impl, qa-engineer) still runs in full; only the pauses are removed. Halt back to the maintainer on:

- any `must-fix`;
- any `STATUS: BLOCKED`;
- any finding, `worth-discussing` included, that affects downstream not-yet-run workstreams. The downstream-relevance check is explicit: before proceeding, the dispatching session checks each non-`must-fix` finding (`worth-discussing` and `low-confidence`) against the remaining workstream surfaces. Findings with no downstream bearing accumulate and come back as one batch at plan-end qa; each batched finding is named in the between-workstream report with a one-line rationale for its lack of downstream bearing, so the check is auditable in the mode that removes the maintainer's read.
- **Pre-proceed security check:** for workstreams matching the security trip-wire (CI, publishing, or dependency configuration touched), verify the *checklist component* of qa's `Security audit:` field is not `n/a` before proceeding; a checklist `n/a` there halts back to the maintainer like a `must-fix`. Check the checklist component specifically, not the field as a whole: the tool-run component always carries a result, so a bare field-level check passes vacuously. This check belongs to the dispatching session because it is the party with the trip-wire in context (qa-engineer does not declare this file as an input), and auto-dispatch removes the maintainer's between-workstream read that otherwise catches a mistaken `n/a`.

Fit guidance: mechanical plans (propagations, sweeps, config changes) are good candidates; taste-heavy plans (doc notebooks) keep the pauses. Auto-dispatch is only offered on plans whose grill failure-mode wave ran (a named `## Failure modes` rubric exists); grill-skipped or otherwise rubric-free plans keep per-workstream pauses, since the post-impl attacks lean on that rubric.

## Plans

Hiveplotlib plans live in the wiki submodule at `hiveplotlib/wiki/wiki/plans/<topic>.md` (tracked in the wiki repo, survives across machines). Harness-self plans live at `agent-harness/.claude/plans/<topic>.md` (gitignored; the harness has no wiki dependency).

Path resolution per consumer:

- `hiveplotlib` → `hiveplotlib/wiki/wiki/plans/<topic>.md`
- `hiveplotlib-llm-wiki` (planning a wiki-structure change) → `<wiki-repo>/wiki/plans/<topic>.md` (same physical file as hiveplotlib's path)
- `agent-harness` (planning a harness change) → `agent-harness/.claude/plans/<topic>.md`

Plans are working scratch, not curated wiki content; `wiki/wiki/plans/README.md` carries the disclaimer for browsers. Major plans promote to ADRs at `wiki/wiki/adr/NNNN-topic.md` per `mental-model` rule 10. Harness-self plans don't promote; the harness CHANGELOG is their durable record.

**Write choreography.** The plan file is a single shared file with many writers (grill captures, failure modes, four critic blocks, two adversary subsections, the Implementation log, amendments). Each agent writes only its own named section(s) and never rewrites another agent's; the dispatching session avoids concurrently dispatching two agents that write the same section and serializes Implementation-log appends when workstreams run concurrently. The convention is restated in the plan template where the writers see it.

**Active vs. archived (wiki plans only).** New plans start in `wiki/wiki/plans/`. Once a plan's work has fully shipped, it moves to `wiki/wiki/plans/archived/<topic>.md`, so the active directory shows only in-flight work. Listing active plans uses the top-level glob `wiki/wiki/plans/*.md` (excludes `archived/`); resolving a referenced plan checks `archived/` as a fallback. Research Liaison proposes the move; the user confirms and performs it (agents never move plan files). Harness-self plans stay flat.
