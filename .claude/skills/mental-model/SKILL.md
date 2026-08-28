---
name: mental-model
description: Mental model for working on hiveplotlib (network visualization Python library) — workflow rules including plan-then-execute, replace-and-sweep, naming-at-planning; library invariants including the 2-3 axis rule, NetworkX optional, 100% coverage; the two-skill viz bar (the external `agent-viz` general bar plus hiveplotlib's `viz-quality-bar` house-style layer); and prose voice (no em-dashes, no AI filler). Load whenever working on hiveplotlib code, tests, docs, notebooks, or research.
type: skill
---

# Mental model for hiveplotlib work

Shared knowledge every agent in the hiveplotlib harness loads. Source of truth for defaults, names, quality bars, and process choices. If you disagree with a rule, surface to the user before acting.

## Workflow rules

### 1. Plan before execute

Non-trivial work needs a plan. Hiveplotlib (and wiki-structure) plans live at `wiki/wiki/plans/<topic>.md` in the wiki submodule. Harness-self plans live at `agent-harness/.claude/plans/<topic>.md` (gitignored). Template: `agent-harness/.claude/templates/plan-template.md`. The Orchestrator owns plan production; specialists execute against accepted plans. Trivial tasks (one-line fixes, docstring tweaks) skip the plan.

New plans always start in the top-level `plans/` directory. Shipped wiki plans move to `wiki/wiki/plans/archived/<topic>.md` (see rule 10); listing *active* plans means the top-level glob `wiki/wiki/plans/*.md`, which excludes `archived/`. When resolving a referenced plan by name, check `archived/` as a fallback. Harness-self plans stay flat (no `archived/`).

Plans that add or modify user-facing API include an "API usage examples" section with runnable snippets, reviewed by the API Critic at planning time.

### 2. Replace-and-sweep is part of the change

A new API that wraps or replaces an existing pattern ships with all call sites swept in the same plan and PR: notebooks, docstring examples, README, install instructions, autodoc references, tests (some legitimately retain the old API for coverage). The Orchestrator greps during planning and lists hits in "Patterns this replaces". The QA Engineer greps post-execution; survivors fail unless listed in `Holdouts` with a reason.

### 3. Justify defaults from the user's workflow

Each user-facing default gets one sentence in the plan: what is the user trying to do when they reach for this code, and why does the default match? Library-internal symmetry is not a justification.

### 4. Walk the user-intended API against realistic data

Plans show the entry point exercised end-to-end against data the user actually has, not data engineered to satisfy the implementation. If the example requires inventing a convention the library doesn't document, either authorize the convention explicitly in the plan (naming, docstring, tests) or change the entry point. Test fixtures and notebook example data satisfy the same standard.

### 5. Naming follows user vocabulary, decided at planning time

Plans audit new parameter, method, class, and prose names against the vocabulary users would use, often borrowed from the dominant adjacent ecosystem (NetworkX for graphs, ML for embeddings). Internal module/package names stay engineer-flavored. Naming is expensive to change after shipping; settle it before code. Settled names are the shared vocabulary later sessions must reuse.

### 6. Plan-as-living-document

After each workstream, the executing agent writes one line to the plan's Implementation log in the same turn. QA Engineer flags missing entries.

### 7. Critics auto-fix deterministic issues, propose taste calls

Auto-fix without asking: lint, format, type, broken links, missing newlines, failing tests (with a real fix attempt, not removal). Propose only, with confidence tag (`must-fix` / `worth-discussing` / `low-confidence`): design choices, ergonomic suggestions, structural preferences, after-the-fact naming. When in doubt, propose.

**Provenance guard on in-place prose auto-fixes.** Before auto-fixing prose in place (a CHANGELOG entry, a docstring, notebook markdown), check `git diff` on the target: committed text may be fixed in place; uncommitted text the fixer did not author (the maintainer's or a co-running agent's, whose only copy is the working tree) is never edited — supply the ready-made fix as a proposed concern instead. Born of a real loss: an in-place compression of an uncommitted maintainer-written entry destroyed the only copy.

Critics participate in **both** planning and post-implementation review whenever a workstream touches their domain. Mechanical propagation of an existing surface to a sibling class still requires post-impl review — the propagation framing does not exempt the new surface from a user walkthrough.

### 8. Preserve user-friendly framing in rewrites

A docstring or prose rewrite with more information that's harder to read is a regression. Layer new info on top of the clear lede.

### 9. Halt on confusion; never self-recover or run destructive ops

When state doesn't match expectations, STOP and surface a `STATUS: BLOCKED` report. The first line is `STATUS: BLOCKED`; the routine `Status:` line is absent. Body describes the confusion and proposed recovery options.

**Triggers include:** a file you didn't modify is modified, code doesn't match the brief, an unfamiliar test failure shape, `pytest` output you can't classify, a plan claim that doesn't match source state, an obstacle to the brief (an unexpected cost, a name that doesn't fit, a constraint conflicting with the named entry point), or a sub-agent surface-back trigger.

**Why halt and not normalize:** multiple agents may be active in the same working tree. Unexpected state is the expected operating condition, not broken state to fix.

**Banned anti-actions when the rule fires** — any command that discards uncommitted work the agent did not read first, in any form:

- Working-tree discards: `git checkout -- <path>`, `git restore` without `--source`, `git reset --hard`, `git clean`, `git switch --discard-changes`, any `--force` / `-f` flag on `push`/`branch`/`tag`.
- Stash / history discards: `git stash drop`, `git stash clear`, `git branch -D`, `git reflog expire`, `git filter-branch`/`filter-repo`.
- Non-git: `rm -rf` on tracked files, `>` / `>>` overwriting tracked files, `mv` overwriting a tracked file, `Write` overwriting a file the agent did not just read.
- Silent substitution: when the brief specifies entry point X and X can't be executed, surface back; do not substitute Y and proceed.
- Rationalization prose bridging a substitution in a shipped artifact ("uses X rather than Y because..."). The bridging belongs in the plan or in the surface-back message, not in the artifact.
- Editing a `conftest.py` or modifying inputs to make a test pass.

The ban is absolute. User authorization to ship a workstream is not authorization to run destructive ops while shipping it. The enumeration is non-exhaustive; any command matching the category is banned.

### 10. Promote major plans to wiki ADRs

When a major plan finishes shipping (work complete, tests pass, user has reviewed), Research Liaison distills it into `wiki/wiki/adr/NNNN-topic.md`. Conventions: 4-digit sequential `NNNN`, kebab-case slug naming the decision, `Status: Proposed | Accepted | Superseded by NNNN`, append-only (supersede with a new record, link both directions). Concision per rule 17 (ADR shape).

**Scope:** hiveplotlib consumer-repo plans only. Harness-self plans use `agent-harness/CHANGELOG.md` as their durable record. Trivial plans skip.

**Triggers:** Orchestrator invokes Research Liaison at planning start to surface relevant prior ADRs. QA Engineer flags eligibility at task close as a `worth-discussing` concern; user green-lights; Research Liaison promotes.

**Archiving:** once a wiki plan has fully shipped, it moves to `wiki/wiki/plans/archived/<topic>.md` so the active `plans/` directory shows only in-flight work. Research Liaison *proposes* the move (at ADR promotion for ADR-eligible plans, or in its post-task pass for non-ADR plans); the user confirms and performs it. Agents never move plan files. A technically-done plan still bundled with unshipped work stays active until the bundle ships. Harness-self plans don't archive.

### 11. Agents grow their own expertise

Expertise files live under `agent-harness/.claude/expertise/` — curated playbooks, not logs. They come in two shapes: **per-role files** (`<agent>.md`), each read by that agent at task start, and **one cross-cutting file** (`personal-gotchas.md`) for gotchas owned by no single role (environment, shell, working-style). Every agent, and the dispatching session, reads the cross-cutting file at task start in addition to any role file. Route a new lesson to the most specific home; the cross-cutting file is a fallback, not a default. Expertise is where learned failure modes accumulate; mental-model and agent definitions carry invariants (rules that hold universally), expertise carries lessons (the specific shape that bit us, watch for it). Update by editing existing entries when refined, adding only when truly new ground is covered, removing when the entry no longer earns its place. Ratchet model: add constraints when you've seen a real failure, remove when the underlying issue is genuinely gone. The file should ratchet toward better, not bloat toward longer.

**Excuse+rebuttal ratchet.** When qa-engineer or the adversary catches a rule evaded via a rationalization, the ratchet fix records the excuse verbatim plus its rebuttal next to the evaded rule, not just a sterner restatement: a rule that names its own loophole is harder to argue past twice. Placement discipline: pairs live next to the rule only as one-liners; anything longer routes to the relevant role's expertise file (the mental-model ratchets, it doesn't bloat). Precedent: rule 7's propagation sentence, which names the "it's just mechanical propagation" excuse and rebuts it in place. Seeded pairs: rules 12 and 13.

**Standing allowance.** Updating expertise is not part of any per-task scope. A brief that says "edit only `examples/foo.ipynb`" or "no submodule files" scopes the *deliverable*; it never withdraws your rule-11 write to your role file or `personal-gotchas.md` (settings ship the `Edit`/`Write` allowance on `agent-harness/.claude/expertise/**` for exactly this). Record an earned lesson however narrowly the deliverable was scoped. The dispatching session scopes the deliverable surface without forbidding this standing write.

**Entry shape.** Each entry is composed of: (1) a **lead** — one bold sentence stating the rule in imperative voice, or a `### Subhead` when the entry needs a worked example with quoted artifacts; (2) a **body** of 1-3 sentences carrying the lesson, its trigger/test (what to watch for, how to apply it), and where it sharpens the lesson a brief concrete example, not a blow-by-blow incident recap. Ground each entry in a real failure or repeated success you actually hit, not invented advice. Keep the lesson, its specifics (file:line refs, code tokens, predicates, the trigger), and any illuminating example, but do **not** cite the originating plan, workstream, amendment, job, or branch: nobody looks it up, the git log and plan already hold provenance, and the reference is dead weight in a file re-read every task. The test on a draft: every sentence should be doing teaching work (stating the rule, naming the failure shape, or showing the example that demonstrates it). Keep it lean: soft target ~60-90 words per entry; an entry needing materially more is usually two lessons (split) or over-narrated (cut). Per-file headers point back here rather than restating the shape.

### 12. Stay release-ready continuously

Every merge is treated as if it could ship. Tests pass, coverage holds at 100%, warnings-as-errors enforced, docs build cleanly with zero warnings, notebooks run end-to-end, `CHANGELOG.rst` updated for user-visible work, ADRs filed for major design decisions. Pre-existing docs warnings are debt the current workstream surfaces. Ratchet pair (rule 11's excuse+rebuttal convention): "this warning is pre-existing, not mine" → fix it when it lives in a file or build the workstream touches; surface it as debt only when it doesn't. Release time is mechanical: semver bump, version-string update, git tag.

### 13. Changelog discipline during work

Specialists append CHANGELOG entries in the same workstream that introduces user-visible work. Don't defer; don't reconstruct.

**Routing by plan path:** plan at `wiki/wiki/plans/` → `hiveplotlib/CHANGELOG.rst`. Plan at `agent-harness/.claude/plans/` → `agent-harness/CHANGELOG.md`. Split cross-consumer plans at planning time.

**Sections (Keep a Changelog):** `Added`, `Changed`, `Fixed`, `Removed`, plus `Tooling Changes` for consumer dev-loop work.

**Entry style:** high-level abstraction of what changed. Not a recitation of mechanism. "Added support for X" beats a paragraph cataloguing every rule edit. Pointers to plan paths are welcome; verbatim restatement of the rule change is not. **Hard cap:** each unreleased-section entry (format-agnostic: `## Unreleased` in `CHANGELOG.md`, `Version X.Y.Z (unreleased)` in `CHANGELOG.rst`; both routing targets are covered) is at most four wrapped lines at a 120-character wrap width (the docstring convention), with no sub-bullets under an entry. No minimum; prefer the shortest phrasing that reads naturally. Anti-contortion: don't trade length for abbreviation soup to duck the cap; if natural phrasing needs a third or fourth line, use it. Exemplar corpus: the released, maintainer-written sections of the consumer CHANGELOGs (`agent-harness/CHANGELOG.md` released sections, `hiveplotlib/CHANGELOG.rst`); match or undershoot them for voice and abstraction level. The corpus's own over-cap entries are append-only history, not license for length. The cap binds the unreleased section of the target file only; released sections are never sweep targets. Ratchet pair (rule 11's excuse+rebuttal convention): "this entry needs the detail to be a complete record of everything the workstream did" → the plan, commit message, and git log hold the detail; the CHANGELOG entry is the few-line human summary.

**Altitude, not just length.** Length and altitude are separate failures; an entry can be under the cap and still wrong. Calibrate altitude against the rest of the target changelog: read the released entries around yours and match their register (the two consumers sit at slightly different altitudes, so the target file, not a universal voice, is the reference). Real before/after from the harness changelog. Compressed mechanism, still wrong: "`grill-me` brief mode: a pre-plan extraction interview, one question at a time, for briefs that underdetermine plan-shaping choices; ran-or-knowingly-skipped is recorded in each plan's Goal." Calibrated altitude, right: "`grill-me` brief mode: the harness can now interview the maintainer before planning when the ask is fuzzy, and each plan records whether we bothered." Shrinking the mechanism is not raising the altitude; state the behavior change a skimming reader cares about, then stop.

**In/out of scope for harness CHANGELOG:** behavioral changes are in scope (new rules, agent-workflow changes, report-format changes, trip-wires, new artifacts, `sync.sh` changes). Expertise updates, wording refinements with no behavior change, plan-file edits, typos, formatting-only changes are out. Heuristic: would this invalidate or introduce a contributor habit?

Per-role authorship: the executing specialist files the entry. QA Engineer verifies presence.

### 14. Route emergent work back through the Orchestrator

Scope-changing decisions surfacing mid-flight route to the Orchestrator in `amend-plan` mode, not directly to the user, not ad-hoc to the dispatching session.

**Triggers:** (a) a post-impl critic finding tagged `must-fix` always routes to amend-plan. A `worth-discussing` finding is **maintainer-gated, not auto-routing**: at the between-workstream checkpoint the dispatching session surfaces it with a recommendation (amend now / defer to a follow-up / decline), and routes to amend-plan only on the maintainer's call — with one override, a `worth-discussing` that bears on a downstream not-yet-run workstream routes regardless, so that workstream ships correct the first time. A `low-confidence` observation surfaces in the report but never triggers an amendment. (b) any user ask that would add a new workstream, modify an existing workstream's done-when, or defer an item to a follow-up. (c) quiet wrongness: something seems noticeably wrong, and the maintainer has never stood up for it as something they truly want. That is a pause-and-get-explicit-clarification trigger, never a design-around, and it is the explicit exception to this rule's headline: it goes straight to the maintainer, not through amend-plan, because it is not a scoping decision. Amend-plan follows only if the clarification changes scope. The domain is wrong-looking work the maintainer never asked for (agent-introduced choices); a critic finding about plan-specified work is not a (c) and stays on trigger (a)'s tiered routing.

The gate keeps the reflexive amend-plan round-trip off minor taste calls (the maintainer waves most through in a word) while never letting a downstream-relevant finding slip. It also makes default and auto-dispatch modes symmetric: same downstream-relevance filter, the only difference is who disposes a no-downstream-bearing `worth-discussing` — the maintainer at the checkpoint in default mode, an auto-batch to plan-end qa when the maintainer opted out of the pauses.

**Chain:** critic writes finding into the plan → dispatching session sees the trigger during routine dispatch → dispatching session invokes Orchestrator in `amend-plan` mode → Orchestrator edits the plan's "Plan amendments" section and returns a dispatch recommendation. QA Engineer's check that post-impl sections are filled is the gate; it is not a hop in the chain.

Routine dispatch decisions (which specialist runs which workstream, sequencing within the plan, retry on transient failures) stay with the dispatching session.

Under a plan's opt-in auto-dispatch mode (harness CLAUDE.md, "Between workstreams"), the maintainer is not at the checkpoint to dispose a `worth-discussing`, so the same downstream-relevance filter runs unattended: no downstream bearing → batches to plan-end qa; downstream bearing → routes immediately. `must-fix` always routes. This is the maintainer-out-of-the-loop shape of trigger (a) above, not a separate rule. A trigger-(c) clarification halts back to the maintainer when remaining workstreams depend on the item; otherwise it parks as a `## Maintainer questionnaire` item on the plan, surfaced in workstream-completion reports rather than waiting silently at plan-end.

### 15. No plan-internal scaffolding in shipped artifacts

Plan-management metadata belongs in the plan, commit message, and PR description, not in source, tests, notebooks, or docstrings — test docstrings included, which state the behavior under test, not the review history that produced it. Banned in shipped artifacts: workstream identifiers ("Workstream I"), phase numbers, plan-section references, "per Workstream X" provenance, and **process/role provenance** (a harness role, a review mode, a plan item number, a "user resolution"). Name section dividers by topic; the git log captures provenance. QA Engineer greps for survivors; auto-strip (delete or rename to topic) is "objective wrongness", not a taste call.

### 16. Scratch artifacts go to system `/tmp/`, not the project tree

Diagnostic dumps (PNG renderings for side-by-side comparison, intermediate data exports, helper scripts) go to `/tmp/<descriptive-subdir>/`, not under the consumer repo. The working tree is git-tracked space; even untracked artifacts there clutter `git status` and risk accidental commits during a `git add .`. `/tmp/` is OS-managed, outside git's view entirely. Notebook cell PNGs are also reachable in-memory from `cell.outputs[].data['image/png']` (base64) when the agent already has the `.ipynb` open; decoding from the notebook is usually faster than re-rendering anyway. When a working artifact legitimately belongs in the repo (a new test fixture, a new example image, a new dataset), name it under the canonical home (`tests/`, `examples/`, `docs/source/_static/`, `src/hiveplotlib/datasets/`); never under an ad-hoc top-level scratch directory. Applies to any agent with `Bash` or `Write` access — viz-critic, code-engineer, qa-engineer, notebook-author, anyone.

### 17. Long-form authored artifacts are directly readable

Plans, plan amendments, and ADRs are written to be read directly, not skimmed past in favor of a summary. One concision standard, cited from each authoring surface (the define-once-cite-everywhere mechanic of rule 11), with a shape per artifact:

- **Plans:** readable without a summary crutch. Cut narration, hedging, and over-justification; say each thing once (a decision stated in Goal is not restated in Default justifications or the workstream block); each section earns its length; done-whens terse and checkable; lists or tables over prose where clearer.
- **Amendments:** as tight as an expertise entry: delta, rationale, which done-whens it touches, the In-scope / Added / Deferred tag. Not a narration of how the ask arrived.
- **ADRs:** a distilled record, not a narrative. Keep it short, single screen typically.

Binds the Orchestrator (plans, amendments) and Research Liaison (ADRs) at authoring time.

### 18. Cold-context dissent is mandatory on every plan

Every plan that exists (non-trivial, per rule 1) gets the `adversary`: a cold pre-grill challenge before grill-me, and a post-impl attack on each shipped workstream. The adversary is a **sub-agent for independence**; grill-me runs inline in the agreeable dispatching session that produced the work and cannot supply the cold read. The full sequence: cold pre-grill challenge (rubric-free) → grill (with its failure-mode wave) → conditional post-grill rubric-check → dispatch → post-impl per workstream.

Why mandatory when grill-me is optional: the adversary is the harness being *intrinsically* self-critical on every plan, independent of whether the maintainer chooses to be in the loop; grill-me is the maintainer's *optional* way to put themselves in the loop. Different purposes justify the cheaper mechanism being optional and the costlier one mandatory.

- **Tiered disposition.** The planning challenge is the maintainer's to fight in the grill (resulting changes follow "Route emergent work back through the Orchestrator" like grill changes do); the orchestrator never silently disposes it. An adversary-self-tagged `existential-must-fix` (the could-this-not-exist angle landing as "this plan should not exist") surfaces *before* grill-me as a "reconsider before grilling" checkpoint, raised by the dispatching session, not the plan-authoring orchestrator. Only a **post-impl** `must-fix` / `worth-discussing` routes to amend-plan like the other critics (under a plan's opt-in auto-dispatch mode, a `worth-discussing` finding with no downstream bearing batches to plan-end qa instead, per rule 14), and the mode joins the critic-completeness gate (an unfilled "Adversary post-impl" section is a `must-fix`).
- **Planning mode is rubric-aware, not rubric-required.** The cold pre-grill pass works three mandated angles (premise, approach, size-and-maintenance / could-this-not-exist) and does not depend on the plan's "Failure modes" rubric, which the grill names *after* it. The post-grill rubric-check is the same mode's second invocation: a delta-check against the newly-named modes only, skipped when the cold pass already covered them.
- **Phase-aware authority.** On code the adversary subtracts (push toward less surface). In research it is a non-killing dissenting voice during divergence and the validation gate at convergence. Plan-section-as-memory carries between modes, blind-first: the post-impl context attacks the diff against the done-whens and rubric first, and only then reads its own challenge and the disposition to reconcile; no live continuity is designed.

### 19. Point, don't describe

When work hits a step only the maintainer can perform (a hosted-service setting, an account action, a one-time registration), find and hand over the exact link plus the concrete actions to take there, whenever that is cheaply findable, instead of describing settings for the maintainer to go figure out. The navigation is the agents' work; only the action itself is the maintainer's (the same principle as grill-me's facts-are-the-agents'-job invariant). Never handle or request credentials. When the exact destination is not cheaply findable, say so and hand the best pointer you have.

## Library invariants

**Hive plots have 3 axes, almost always.** Default mental model is 3 axes, often with repeat axes (karate club is canonical, 3 axes + repeats = 6 effective halves). 2 axes without repeats is essentially never useful (one toy pedagogical notebook). 4+ axes is a bug; use HivePlotMatrix instead. Partition design uses meaningful binary or ternary cuts, not numbered community-detection labels.

**Edge kwargs follow a configurable hierarchy.** Default order, lowest to highest priority: `all_edge_kwargs` → `clockwise_edge_kwargs` / `counterclockwise_edge_kwargs` / `repeat_edge_kwargs` (equal middle) → `non_repeat_edge_kwargs`. Stored on `HivePlot.edge_kwarg_hierarchy`, user-reorderable. `plot()` kwargs deprioritized below the hierarchy; `Edges` instance kwargs below those. `update_edges()` is the explicit per-pair override and bypasses the hierarchy without warning. Each backend's `rename_edge_kwargs()` handles translation. Canonical reference: `examples/edge_kwarg_hierarchy.ipynb`.

**Lightweight by design, optional extras for everything else.** Core: matplotlib + numpy + pandas. Optional extras: `hiveplotlib[networkx|bokeh|holoviews|plotly|datashader]`. Imports wrapped in try/except with helpful errors. Tests for optional-dep code are marker-gated (`@pytest.mark.networkx` etc.); CI verifies subset installs.

**Test discipline.** 100% coverage (`--cov=src/hiveplotlib`). All warnings as errors. 7 parallel workers. `tests/foo_test.py` mirrors `src/hiveplotlib/foo.py`. Test name = test body contract: `test_<method>_<scenario>` must call `<method>` in its body. If the named entry point can't be tested as-is, halt under rule 9.

**Test the programmatic consumer, not a rendering-only surface.** Before asserting on `__doc__`/`__name__`/`__qualname__`/introspection, ask who reads it. If library code does, test that consumer's output (the surface is covered transitively). If only rendering does (Sphinx, `help()`, tables), it's docs-engineer + human review, not pytest — and import usually already covers the lines, so the test adds nothing. Pinning docstring prose substrings protects nothing and fights rule-8 rewrites.

## Viz quality bar

Two skills, not one. The **general** figure bar is `agent-viz`, maintained outside this repo (`/plugin marketplace add gjkoplik/skills`, then `/plugin install agent-viz@gjkoplik`; enabling it in settings is not installing it): quantitative honesty, statistical honesty, accessibility, how a figure argues, production, and the pre-ship checks. It scopes itself by role, so an honesty-and-accessibility floor binds on every figure while narrative polish scales with the job, and a deliberately minimal API-demo figure is correct rather than unfinished. The **hiveplotlib layer** is `<harness>/.claude/skills/viz-quality-bar/SKILL.md`: house style, hive-plot-specific rules, datashader specifics, empirical patterns from the corpus. Load both before producing or reviewing a figure; the house-style layer does not restate the general bar.

## Prose voice

Applies to text the reader sees (notebook markdown, README/docs prose, PR descriptions, commit message bodies). Code comments exempt.

- **No em-dashes.** Use commas, parentheses, semicolons, periods. The em-dash is the biggest AI tell.
- **No AI filler:** "delve", "moreover", "furthermore", "underscore", "in essence", "it's worth noting that", "as we can see", "in the realm of".
- **No throat-clearing.** "First, let's discuss X" before discussing X adds nothing.
- **No hedging meta-commentary.** "It is important to note that X" is just "X".
- **Library helpers are tools, not characters.** Just use `flexitext`, `seaborn`, `numpy.random.default_rng`.
- **Direct, slightly informal.** "Let's look at what happens when we sort by degree" beats "We shall now examine the consequences."
- **Compression is the default.** Match or undershoot the length of sibling entries when adding to CHANGELOG, expertise, agent definitions, or in-place docs. Cut sentences that don't carry load-bearing information. The git log carries provenance, the wiki carries deep context, in-place prose carries only what the reader needs at hand. When in doubt, less. Long-form authored artifacts (plans, amendments, ADRs) follow rule 17's per-shape standard.

## Pointers

- `hiveplotlib/CLAUDE.md` — architecture, commands, entry points
- `<harness>/.claude/skills/hiveplotlib-tutorial-notebook/SKILL.md` — tutorial style
- `<harness>/.claude/skills/hiveplotlib-gallery-notebook/SKILL.md` — gallery style
- `wiki/wiki/` — research, prior thinking, ADRs at `wiki/wiki/adr/`
- `<harness>/.claude/templates/plan-template.md` — the plan template
