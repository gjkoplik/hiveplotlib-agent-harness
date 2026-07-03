# Expertise: Adversary

Curated playbook of what this role has learned. **Not a log.** Edit existing entries when a new observation refines or supersedes them; add new entries only when truly new ground is covered; remove entries that no longer earn their place. Every entry comes from a real failure or repeated success (not invented advice), follows the entry shape (lead + body, no originating-plan citation), and stays lean (soft target ~60-90 words) per mental-model rule 11.

Read the cross-cutting `agent-harness/.claude/expertise/personal-gotchas.md` at task start in addition to this file.

## Patterns to reach for

- **A skip reason written as prose is not enforcement; demand a mechanical arming trigger for any dormant or skip-marked gate.** When a plan marks a gate skipped or dormant ("run this once X lands", "n/a until the rubric exists"), the recorded reason re-arms nothing: no one re-checks it when the condition flips, and the gate stays off indefinitely. Push for a named trigger someone will actually hit (a done-when bullet, a dispatch-time check, a grep target) that fires when the condition arrives. Trigger: any "skipped for now" without a stated un-skip mechanism.
- **On harness-self plans, diff the routing vocabulary across every surface the plan touches before trusting its wiring.** Tag and trigger vocabularies drift between surfaces (one rule said findings route on `must-fix` or `should-fix`, a tag no critic emits, while the adversary's own spec routes `worth-discussing`); a new mode built on "halts on any amend-plan trigger" inherits whichever reading the implementer happens to hold. Two blind spots: a workstream shipping *before* the reconciling one can mint fresh taxonomy statements its surface list never named, and a sweep anchored on the retired token cannot find statements that never contained it. Trigger: any plan whose behavior keys off tags, triggers, or sequence phrases stated in more than one file.

- **When a workflow conditions a capability on existence ("when X exists"), check the output grammar and the pass gate for the absent branch.** A conditional workflow step paired with an unconditional report field or gate makes the honest report unrepresentable: a dependency-audit run gated "when tooling exists" shipped with only `clean | unresolved` in the field grammar and "tool run clean" required for pass, so a consumer without the tooling could neither report truthfully nor pass. Trigger: any `<a | b>` report grammar next to a "when/if it exists" workflow clause.

## Anti-patterns

_Specific failure modes seen in this role, each tied to a real incident or repeated mistake. Empty until earned._

## Gotchas

- **In a same-run timing ratio, check which side pays first-call cost before trusting the ratio.** Two workloads timed in the same process are not symmetric: whichever runs first absorbs one-time import, JIT/compile, and cache-warming overhead, and the ratio silently inherits that bias. Before accepting or attacking a ratio as evidence (a regression threshold, an "X is 2x slower" claim), ask which side paid the first-call cost; a warm-up call or an order swap is the cheap control that settles it.
