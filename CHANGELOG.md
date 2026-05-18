# Changelog

Tracks substantive behavioral changes to the agent harness. The harness has no
release cadence (it's a submodule pinned per-consumer via `make bump-harness`);
the `[WIP]` umbrella below is permanent. Dated entries accrue beneath it as work
accrues. See `mental-model` rule 13 for in-scope vs. out-of-scope criteria.

The heuristic for filing an entry: would the change invalidate or update a habit
a contributor has already formed, or introduce a new habit a contributor should
form? If yes, file an entry. If no (expertise-file updates, rule-internal
wording refinements that don't change behavior, plan-file edits, single-typo
fixes, formatting-only changes), do not file.

Entries are grouped by ISO date (`### YYYY-MM-DD`). Sub-sections under each date
use Keep a Changelog conventions: `Added`, `Changed`, `Fixed`, `Removed`. Plans
that span both consumer and harness surfaces should be split into two plan files
at planning time; the plan file path routes the entry destination
(`wiki/wiki/plans/` files to `CHANGELOG.rst`; `agent-harness/.claude/plans/`
files to this file).

## [WIP]

### 2026-05-18

#### Added
- `mental-model` rule 4 restored as a real rule (previously `(Removed)`):
  "Walk the user-intended API against realistic data." Every plan that adds or
  modifies user-facing API must show the entry point exercised end-to-end
  against the data the user actually has, not just the call site. If the data
  construction requires inventing a convention the library doesn't already
  document, the entry point is wrong as specified; either authorize the
  convention explicitly in the plan or change the entry point. Test fixtures
  and notebook example data must satisfy the same realism standard. Plan:
  `agent-harness/.claude/plans/data-shape-audit-and-feasibility-checks.md`.
- The Orchestrator's `initial-plan` workflow gained a new "Feasibility audit"
  step (step 8) between "API usage examples" and "Decompose into workstreams";
  subsequent steps renumbered. Scope: net-new entry points, behavior changes
  that read/write new attributes of user input data, and surface-restructure
  work where data-shape contracts change. Restates the two recoveries inline
  (authorize-and-document in the plan, or change the entry point). Mirrored
  into `amend-plan` mode with no "if applicable" qualifier.
- The dispatching-session trip-wire in `hiveplotlib/CLAUDE.md` ("Plan
  execution means harness dispatch") gained a pre-dispatch sanity-check
  clause: before dispatching code-engineer for a new workstream, skim the
  workstream's "API usage examples" section; if the data construction is
  missing or invents an unauthorized convention, route to the Orchestrator in
  `amend-plan` mode for a feasibility check before dispatching.
- Three follow-on amendments from the post-impl api-critic review on the
  same plan: (1) the api-critic agent's planning-mode workflow step 3 now
  carries an explicit sixth bullet asking whether the snippet walks
  realistic data construction with `# Example data:` runnable Python or
  skips straight to the call site, closing the gap between the restored
  rule 4's data-construction requirement and the agent's checklist;
  (2) the plan template's `# Example N:` placeholder line no longer carries
  em-dashes inside its angle-bracket seeds, so the project voice rule is
  preserved by default across every plan generated from the template;
  (3) the Orchestrator's Feasibility audit step (both initial-plan and
  amend-plan modes) now names the canonical documented data shapes the
  audit grep against (for hiveplotlib: the `Node` / `NodeCollection` /
  `Edges` constructors plus the `from_*` classmethods on `HivePlot` /
  `HivePlotMatrix` / `P2CP`; for other consumers: the equivalent surface
  identified in the consumer's `CLAUDE.md`).

#### Changed
- The plan template's "API usage examples" / "Proposed (from planner /
  Orchestrator)" subsection now requires a three-part
  `# Example N: <context>` / `# Example data:` / `# Call site:` structure.
  Instruction prose explicitly requires runnable Python with no placeholders
  (ellipses, incomplete constructs, "imagine the user has..." comments fail
  the check). Carve-out for ecosystem inputs: when the input parameter is a
  data object the user constructs themselves (an `nx.Graph`, a DataFrame),
  the `# Example data:` block constructs that object using realistic
  dominant-ecosystem calls; when the input is library-produced, the block can
  reference the producing call. Either way the example must be runnable.
- Vocabulary unified on "authorize / authorized" across the four touched
  files when the meaning is "make the convention an officially supported
  library behavior." Rejected alternatives: "bless / unblessed," "sanctioned,"
  "approved," "documented" (the last in the supported-behavior sense, not the
  has-documentation sense).

### 2026-05-18 (retrospective)

#### Added
- Agents encountering state that doesn't match their expectations now STOP and
  surface a `STATUS: BLOCKED` report rather than self-recovering. Destructive
  git operations (`git reset --hard`, `git clean`, `git restore` without
  `--source`, `--force` flags, `rm -rf` on tracked files, `Write` over an
  un-read file) are banned absolutely under any framing. Codified as
  `mental-model` rule 16 with rule 9 as the destructive-op corollary. Plan:
  `agent-harness/.claude/plans/halt-on-confusion-and-ban-destructive-ops.md`.
- When rule 16 fires, agents emit a `STATUS: BLOCKED` out-of-band report that
  replaces the routine report instead of returning a routine `Status:` value.
  Shape propagated to all 9 agent definitions.
- Line endings are now normalized to LF across both repos regardless of host
  platform; new `.gitattributes` files at the hiveplotlib and agent-harness
  repo roots enforce `* text=auto eol=lf`. Closes a CRLF-vs-LF drift between
  the two `CLAUDE.md` files that masked their byte-for-byte identical
  trip-wire content.
- The harness now tracks substantive behavioral changes in a living
  `agent-harness/CHANGELOG.md` (`## [WIP]` umbrella with dated entry groups,
  `Added` / `Changed` / `Fixed` / `Removed` sub-sections) gated by qa-engineer.
  Per-role authorship mirrors `mental-model` rule 13's consumer table. Plan:
  `agent-harness/.claude/plans/harness-changelog-and-line-endings.md`.
- Emergent scope changes (post-impl critic must-fix / should-fix findings;
  user asks that change the workstream set) now route through the Orchestrator
  in `amend-plan` mode rather than being applied ad-hoc by the dispatching
  session. The Orchestrator edits the plan's "Plan amendments" section in
  place; the dispatching session does not edit the plan directly. Codified as
  `mental-model` rule 14. Plan:
  `agent-harness/.claude/plans/orchestrator-on-emergent-work.md`.
- The plan template now carries a "Plan amendments" section with three
  subsections (Added workstream / In-scope tweak / Deferred follow-up)
  matching rule 14's trigger taxonomy. The Orchestrator populates this section
  in `amend-plan` mode; the section is append-only within a plan's lifetime.
- The Orchestrator now operates in two modes (`initial-plan` for net-new
  plans, `amend-plan` for mid-flight scope changes), with a consumer parameter
  (`hiveplotlib` / `agent-harness` / `hiveplotlib-llm-wiki`) orthogonal to
  mode. The dispatching session names the mode at invocation.
- Plan-internal scaffolding (workstream labels, phase numbers) is no longer
  allowed to leak into shipped artifacts; source, tests, notebooks, and
  docstrings now use topic names instead. qa-engineer audits for survivors on
  every workstream. Codified as `mental-model` rule 15. Plan:
  `agent-harness/.claude/plans/qa-engineer-docs-warning-posture.md` (rule 15
  landed in this plan's workstream alongside the docs-warning posture).

#### Changed
- ADR promotion is now hiveplotlib-only; harness-self plans no longer promote
  to ADRs because their durable record is this CHANGELOG. Propagated through
  `mental-model` rule 10, qa-engineer's ADR-eligibility check (now emits an
  explicit `n/a (harness-self)` token in the report rather than skipping
  silently), and research-liaison's ADR-promotion workflow (out-of-scope
  surface-back).
- CHANGELOG filing now routes by plan-file path: plans under
  `wiki/wiki/plans/` file to `CHANGELOG.rst`, plans under
  `agent-harness/.claude/plans/` file to `agent-harness/CHANGELOG.md`.
  Per-role responsibility table is unchanged; only the target file moves.
  Codified in `mental-model` rule 13 and qa-engineer's CHANGELOG-currency
  check.
- qa-engineer reports now carry an explicit ADR-promotion-eligibility token
  (`eligible | n/a (trivial plan) | n/a (harness-self)`) parallel to the
  existing `CHANGELOG:` line. Replaces the previous silent-skip behavior; the
  audit trail now records that ADR promotion was considered.
- `hiveplotlib/CLAUDE.md` line endings normalized from CRLF to LF.
- The docs build is now gated at zero-warnings-zero-errors for release
  readiness rather than green-with-warnings. Pre-existing warnings count as
  debt the current workstream must surface (with file:line citations, not a
  count) and are tagged `must-fix` unless the workstream itself is docs-scope,
  in which case warnings drop to `worth-discussing`. Diff-newly-introduced
  warnings are always `must-fix` regardless of scope.

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
