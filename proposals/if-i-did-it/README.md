# Proposal: `if-i-did-it`

A **strawman**, not an accepted change. Nothing here is wired into the harness: `sync.sh` only ever touches
`.claude/skills`, `.claude/agents`, `.claude/commands`, and `.claude/settings.json`, so this directory cannot reach a
consumer repo by accident. It exists to make the open questions concrete enough to argue with.

## What it is

A user-invoked skill for contemplating a capability you have not used before, without building it. It calibrates to
what you already know, explores the thing, works out what integrating it would actually mean in the repo it is pointed
at, prices the exit, has the case for and the case against written by two independent contexts, and lands a
self-contained HTML report plus either a planning brief (adopt) or a breadcrumb (do not adopt / not yet).

Shipped as a **plugin** rather than a bare skill because it bundles two agents whose independence is structural: the
advocate and the skeptic must not see each other's work.

```
plugin/
  .claude-plugin/plugin.json
  agents/skeptic.md                              case against, written first, blind
  agents/advocate.md                             case for, written second, blind
  skills/if-i-did-it/SKILL.md                    the six phases
  skills/if-i-did-it/reference/report-anatomy.md report structure, epistemic tiers, diagram rules
  skills/if-i-did-it/assets/report-template.html self-contained HTML skeleton
```

## Placement

The recommendation is that this does **not** live in this repo. The harness is tuned for hiveplotlib (its `sync.sh`
carries library-repo exclusion logic, its skills are either hiveplotlib-specific or harness-process-specific), and this
skill is domain-general. Recommended home is a personal marketplace repo holding several plugins, consumed with
`/plugin marketplace add`. The decision is reversible either way: marketplace `renames` migrates existing installs, and
a `git-subdir` source can pull a plugin out of a monorepo without moving it.

The full argument, the tradeoffs, and the open questions are in the design report that accompanies this proposal.

## Status

**Superseded in direction, not yet rewritten.** Maintainer feedback reframed the skill: it is a cheap
sunk-cost circuit breaker for half-formed ideas, not a rigorous adoption report. Brief by design, with
progressive disclosure as the calibration device (what stays collapsed depends on what the reader already
knows), renamed to `what-if`. The files here still encode the expensive first design: six phases, a blind
advocate/skeptic pair by default, quote-level grounding, a probe.

The rewrite is mostly deletion, and it is held pending confirmation rather than done twice. Nothing here
is wired in: no grill, no adversary pass, no plan.
