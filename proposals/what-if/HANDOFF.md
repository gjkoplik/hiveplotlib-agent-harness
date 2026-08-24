# Handoff: `what-if`

Written to close out a Claude Code cloud session so a local one can pick up without redoing the work. Point a local
session at this file plus `README.md` and `skill/SKILL.md`.

## Where things stand

Branch `claude/if-i-did-it-skill-jybbd4` in `hiveplotlib-agent-harness`.

- `skill/SKILL.md` written, cheap-only, ~78 lines.
- `skill/assets/report-template.html` **not written.** The old one was built for the long-form design and does not
  fit. This is the next concrete piece of work.
- Nothing wired in. No grill, no adversary pass, no plan. `sync.sh` cannot reach `proposals/`.

Two published reports, both design documents about the skill rather than outputs of it:

- Second pass, current: <https://claude.ai/code/artifact/d5b4e5e2-7918-426c-8aee-617bbc4656c3>
- First pass, superseded but holds the long-form research: <https://claude.ai/code/artifact/5dea2991-db3a-48af-9901-8775f73e3ece>

## Settled, do not re-litigate

- **Name is `what-if`.** Chosen for readability when invoking. `if-i-did-it` dropped (an O.J. joke is wrong for
  anything public). `scout` considered and declined.
- **Cheap is the only mode.** No escalation, no deep pass. Anything that would make you hesitate before firing this
  at a shower thought is a bug. What the reader does next is theirs.
- **No handoff artifact and no plan.** A plan is the sunk cost in another form and prejudges the decision the skill
  exists to keep open.
- **Brevity is the product, not a style preference.** It is what stops a polished report substituting for the hour of
  actually using the thing, which was the strongest objection to the whole idea.
- **Progressive disclosure is the calibration device**, not a UI nicety. The opening interview decides what opens by
  default. Adjacent to what the reader knows stays collapsed; genuinely new opens with a short explainer.
- **Reports are written, never staged.** HTML for reading plus a markdown twin for diffing. The maintainer chooses
  what to keep, and that choice is part of the triage.
- **Not a plugin.** Cheap-only removed the advocate/skeptic agents, so it is a plain skill directory. Packaging can
  be decided later without changing the files.

## Open

**Placement, and it is the only real one.** Prior recommendation was a personal marketplace repo with skills as
separate plugins, and explicitly not this harness (which is hiveplotlib-tuned, reaches three consumers, and
distributes by file copy). That recommendation predates knowing about `gjkoplik/agent-viz`.

**Read this before answering it.** The cloud session cloned the agent-viz *remote*, which holds one commit and a
two-line README ("Collating modern data viz concepts into a Karpathy wiki and LLM skill"). The maintainer reports
substantial uncommitted local work that was never visible. Nothing about restructuring agent-viz should be inferred
from that remote. Look at the working tree first.

The unfinished thought, offered as a starting point and not a conclusion: agent-viz as described is a *subject* repo
(a domain wiki plus a skill distilled from it, the same shape as `hiveplotlib-llm-wiki` plus `hiveplotlib-api-usage`),
while `what-if` is a *procedure* skill with no subject. Those may want different homes. A marketplace can list
plugins sourced from other repos, so one marketplace across several source repos is available and may get
consolidation without forcing unlike things into one tree. Test that against the actual working tree.

## What a local session can do that the cloud one could not

1. Read the agent-viz working tree, which is what the placement question turns on.
2. Read hiveplotlib and its wiki submodule locally rather than through pushed remotes.
3. Actually run the thing. The first real subject should be something genuinely unfamiliar with a real integration
   surface. The failure to watch for is a nice-looking report where "go try it for an hour" was the honest answer.

## Findings worth not re-deriving

**Prior art** (swept the large registries and the official Anthropic skills repo):

- **GSD Spike** (`/gsd-spike` in the GSD system) is the closest. Two to five experiments, each a Given/When/Then
  hypothesis written before any code, working code not pseudocode, a validated / invalidated / partial verdict.
  Lands in `.planning/spikes/`, and `--wrap-up` packages findings into a project skill later sessions auto-load.
  No calibration, no education, no decision.
- **Premortem skills**, several published. The most developed runs parallel helpers over six angles, persists to
  `docs/premortem/<plan>.md` with a snapshot in `history/`, and fires a *reverse* premortem when the recommendation
  is abort, because past-tense framing biases toward no. That counterweight is the best thing the sweep found and it
  survives in `SKILL.md` as the "check whether the honest answer is not-yet" line.
- **superpowers**: `brainstorming` (one question at a time, same shape as `grill-me` brief mode and this skill's
  calibration, which is four independent designs converging), `preserving-productive-tensions`, and
  `tracing-knowledge-lineages` (source of the local-lineage check).
- **Nothing** calibrates a report to the reader's existing knowledge, and nothing marks per-claim confidence. Those
  are the two differentiators and they survived the sweep.

**Prospective hindsight.** The 30% figure is Mitchell, Russo and Pennington, *Back to the future: temporal
perspective in the explanation of events*, J. Behavioral Decision Making 2:25-38 (1989). Klein made it a method in
2007. The primary source's wrinkle matters: temporal perspective mattered less than outcome *certainty*, so the lever
is treating the outcome as settled, not the grammar. The skill keeps past tense in the report body even though the
name is now conditional.

**Distribution mechanics**, from the Claude Code docs, so the placement call is made on facts:

- One marketplace per name per user. A repo-per-skill multiplies the install step for nothing.
- A marketplace can source plugins from other repos (`github`, `git-subdir`); `git-subdir` sparse-clones one
  subdirectory of a monorepo.
- `renames` maps an old plugin name to its new one, so moving or renaming migrates existing installs. Placement is
  reversible in both directions.
- Plugins are copied to a cache and cannot reference files outside their own directory (`../shared`). Symlinks are
  the documented workaround.
- The skill listing is budgeted at 1% of the context window; on overflow, descriptions are truncated starting with
  least-invoked skills. Matters less for a user-invoked skill. Tunable via `skillListingBudgetFraction`.
- claude.ai, the Skills API, and `package_skill.py` accept only six frontmatter fields: `name`, `description`,
  `license`, `compatibility`, `metadata`, `allowed-tools`. Anything else is a hard error. So
  `disable-model-invocation` (currently set) pins this to Claude Code.

## Mistakes made here, so they are not repeated

- **Read a remote and nearly reported on a working tree.** The agent-viz clone showed one commit and I was one step
  from telling the maintainer there was nothing to restructure. Check the tree before drawing conclusions about a
  repo someone is actively working in.
- **Over-engineered the first design**, and the over-engineering was self-defeating: six phases, blind subagent
  pairs, quote-level grounding, and a probe made a skill nobody would fire at a half-formed idea, which is the only
  thing it is for. When cost and purpose fight, cost loses.
- **Fought yes-bias hard and never considered no-bias.** Found only by reading what people who run this method a lot
  decided to add.

## Next

1. Write `skill/assets/report-template.html`: disclosures, expand and collapse controls, both themes, `ran` and
   `sourced` marks only, calibration strip up top. The second-pass artifact above is a working example of the format.
2. Settle placement against the real agent-viz tree.
3. Run it once on a genuinely unfamiliar subject and see whether the brevity holds under pressure.
