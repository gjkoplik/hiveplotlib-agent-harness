# Spec: <topic>

<!--
Guidance. Every comment block in this file is for whoever drafts the spec, this
one included. Delete each section's block as you fill that section in, and this
one when the draft is complete; what renders is the spec, and a filled spec
carries no comments.

Three audiences, and the test for where a line goes. The drafter reads these
comments. The signer reads only what renders and never sees a comment. A later
agent reads a filled spec whose comments are all gone. So guidance for the
drafter goes in a comment, anything the signer must act on renders, and
anything that has to bind a later agent renders. A rule that lives only in a
comment is gone the moment the spec is filled in. The one carve-out is a check,
not a permission. A rule may stay in a comment only when three things hold: the
rule is already written in a durable home outside this file, the comment names
that home, and whoever leaves it there has opened that home and read the
sentence. Candidate homes are the harness CLAUDE.md section "Specs and plans",
the grill-me skill, and the definition of the agent that performs the act.
Where the home does not carry the rule yet, the check fails: render the rule
here instead, or hand it to whoever owns the home, and never name a home on the
strength of intending to add it. Those two branches are not equally available.
Handing a rule to a home's owner supplies the home later and never supplies the
name, because naming it is an edit to this file, so on any pass that is the
last one over this file a rule with no home today has to render.

Location, lifecycle and archive triggers, the issue body, and the many-to-many
relationship to plans are all stated in the harness CLAUDE.md under "Specs and
plans", which carries the path table per consumer. Wiki specs go to
wiki/wiki/specs/<topic>.md, harness-self specs to
agent-harness/.claude/specs/<topic>.md.

Authorship. Agent-transcribed from the maintainer's own words. The maintainer
signs; the maintainer does not write.

Length. One page, counted in rendered non-blank lines: what is left once every
comment is deleted, with blank lines not counted, so the short email-style
paragraphs this artifact is written in are never taxed. Past 100 such lines,
ask whether this is two specs, since the links carry a many-to-many
relationship and splitting costs nothing. Split, or say why not on the rendered
"Length:" line under the title; that line is present only when the prompt
fired, so delete its stub in a spec that stays under. It sits under the title
rather than down in the sign-off block on purpose: a reader about to pay for
the length meets the reason first, and a justification read afterwards is
worth nothing. "It needs this content" is a legitimate answer, and content wins
over the number: this is a prompt, never a constraint.

The 100 was checked against the first real spec, which came in at roughly
half of it on a skeleton that spends roughly a third. No skeleton count is
recorded here: every figure written down for it has gone stale inside the batch
of edits that recorded it.

The register is the real bar: a spec that reads like a plan (approach,
sequencing, file lists, done-when criteria) has become a document people skip,
which is the only way this artifact fails outright.
-->

Length: <why this ran long and was not split; delete this line if the spec came in under the prompt>

## Outcome

<!--
What is true for a user once this ships, in the vocabulary that user would use,
stated so that a plausible wrong implementation contradicts it. A few sentences
at most.

"Rendering is faster" cannot be contradicted by reading a diff. "A million-edge
graph renders from a `HivePlot` the user built the usual way, with no
hand-assembly underneath it" can: an implementation reachable only from
somewhere else makes that sentence false on sight.

A user-facing deliverable that ships with the work belongs here too, named at
the altitude of the deliverable and not its contents: "one gallery example on
synthetic data", never a section outline.
-->

<outcome statement>

## Call shape

<!--
The literal code a user types to obtain each claimed benefit, starting from
nothing: imports, data construction, the call. Not a fragment. New or changed
signatures in full.

Draft against the current API. Actually attempt the snippet, and where it needs
something that does not exist yet, name that thing here ("this needs `X` on
`Y`, which does not exist today"). Write it from the class a user would reach
for.

Whether the snippet runs is not the test; whether it delivers the outcome above
is. A `Path:` line follows each fence, and that line is where it gets settled:
name the class and the call chain that snippet actually takes. The two
mismatches it exists to catch are a benefit reachable only from some other
class, and a snippet that runs fine today while quietly taking a path that gives
none of the outcome. Say either one on that line, in that many words.

One snippet per claimed benefit, as many as the outcome needs. The skeleton
shows the fence-and-`Path:` pair twice: delete the spare, or copy it again for a
third.

No writability tag and no per-snippet status field: nearly every spec is about
API being written, so a tag would read "requires this change" every time and
carry nothing.
-->

```python
# <one-line context>
<runnable code, no placeholders>
```

Path: <the class and call chain this snippet takes>

```python
# <one-line context>
<runnable code, no placeholders>
```

Path: <the class and call chain this snippet takes; delete this line and the snippet above it if the outcome claims only one benefit>

## Out of scope

<!--
What this deliberately does not do, and in particular the adjacent thing a
reader would otherwise assume it covers. "None." is a normal answer.
-->

- <thing this does not do>

## Alternatives considered

<!--
Directions weighed and not chosen, one sentence each on why. "None yet." is a
normal answer, and the usual one at first signature. Distinct from "Out of
scope": out of scope is what this work does not deliver, while an alternative is
a different way of delivering the same outcome, rejected.

The displaced-wording rule renders under the heading rather than sitting here,
because the agent that displaces wording and the maintainer who later reads the
trail both work from a filled spec. The reason the "re-sign, narrowed from:"
lines are append-only: they are the only record that a capitulation happened,
and the trail has to read on its own without a join against the sign-off block.

The "re-sign, narrowed from:" line in the skeleton is an empty stub, not a
record: delete it in a spec that has never been re-signed, the same as the
"Length:" line, and append-only starts at the first real one.
-->

Wording a re-sign displaces from the outcome statement moves here rather than being deleted, on a dated "re-sign, narrowed from:" line. Those lines are append-only: add one as each re-sign happens, and never edit or drop an earlier one. Revising the rest of this list is normal.

- <direction not taken>: <why not>
- YYYY-MM-DD re-sign, narrowed from: <the outcome wording that change replaced; delete this line if this spec has never been re-signed>

## Failure modes

<!--
The ways this could be hollow, wrong, or fake even with everything shipped and
green (a feature no user needs, a default that silently corrupts a common case,
a result that is an artifact of how it was measured). The maintainer names
them, in their words. One line each.

The stub below has two exits, and drafting takes neither. Between drafting and
signing the wave has not run yet, and the stub stays put until one exit fires:
the wave runs and fills it, or whoever knowingly skips the wave deletes it.
Empty is legitimate on exactly that second branch, and the "Intent extraction:"
line under "Sign-off" is what says so. A section left empty cannot be told from a wave that ran and
surfaced nothing, which is why the wave's outcome rides that line instead of a
marker here. The grill-me skill states the same discriminator, which is what
lets this sit in a comment.
-->

- <failure mode>: <what makes it hollow, wrong, or fake; this stub stays until the failure-mode wave runs, and is deleted only if the wave was knowingly skipped>

## Open questions

<!--
Questions that would change this spec if they resolved differently. "None." is
a normal answer.

Entry gate: in if the question cannot be stated precisely yet, with a note on
what would clear it; out if statable (a statable question is a decision to
settle now). The plan template states the same gate for its "Not yet plannable"
section. A spec can be signed with a named open feasibility question attached;
clearing it later is a re-sign, which the harness CLAUDE.md under "Specs and
plans" states.
-->

- <question>: <what is unclear, and what would clear it>

## Sign-off

<!--
Before the first signature this file is a draft agents write. What renders
below is the human minimum: the intent-extraction line, the invariant, a marker
clause, a pointer, and the append-only fence. Everything else that binds a
party working from a filled spec (the marker's form and its one-line-only rule,
which writes fire it and which do not, re-signing as the only way to clear it,
any change to a signed spec being a re-sign, how a re-sign is recorded, and the
weakening tag on a proposal that narrows the outcome) is written in the harness
CLAUDE.md under "Specs and plans", which the rendered pointer names.

"Intent extraction:" records how the intent behind this spec was obtained, on
one line carrying both halves, brief mode and the failure-mode wave, each of
them either "ran" or "knowingly skipped". The party running the failure-mode
wave writes it at spec stage, before the signature; where that wave was
knowingly skipped, whoever skips it writes the line. That same harness
CLAUDE.md section states the line's form and its writer, which is what lets
this sit in a comment.
-->

Intent extraction: <brief mode ran | knowingly skipped>; <failure-mode wave ran | knowingly skipped>.

No agent ever signs a spec change, autonomous runs included. An agent whose write can change what this spec promises marks it on an "Unapproved modifications:" line here; only the maintainer clears that marker, by re-signing. The full governance rules live in the harness CLAUDE.md under "Specs and plans".

The fence below is append-only: one line per event, in the form `Re-signed YYYY-MM-DD by <name(s)>: <one paragraph on what changed and why>.` or, once the outcome statement above is true, `Closed YYYY-MM-DD by <name(s)>.`

```
Signed YYYY-MM-DD by <name(s)>.
```

## Plans

<!--
Bidirectional links to the plans serving this spec, "None yet." until one
exists. A wiki spec's plans sit at wiki/wiki/plans/<topic>.md, a harness-self
spec's at agent-harness/.claude/plans/<topic>.md. The orchestrator appends a
path here as it writes each plan against this spec, one line per plan; that
instruction lives in the orchestrator's own definition, on the initial-plan step
that transcribes the spec. The append is bookkeeping and cannot change what this
spec promises, so it does not add the "Unapproved modifications:" line, which
the harness CLAUDE.md under "Specs and plans" states.

Every plan can ship with the outcome still false. What a plan closing does and
does not trigger is rendered under the heading, because the party running that
check reads a filled spec.
-->

A plan closing never closes this spec. The last plan listed here closing is the trigger to check the outcome statement above, which stays the arbiter; plan-end QA runs that check.

- <plan path>
