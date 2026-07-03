---
name: harness-reflection
description: "Weekly local dream: mine the week's sessions for recurring mistakes; update the harness gotchas plus the hiveplotlib-api-usage skill and llms docs. No commits."
schedule: "7 3 * * 6"
notifyOnCompletion: true
---
You are running a weekly self-reflection ("dream") over the past week's Claude Code work on the **hiveplotlib** project, to improve the agent harness. This is a fresh session with no memory of prior runs; everything you need is below.

## Environment (the only machine-specific block; resolve these first)
- **REPO** = the current working directory, which is the hiveplotlib checkout. Confirm with `git rev-parse --show-toplevel`. If you are not inside the hiveplotlib repo, stop and say so in the summary instead of guessing.
- **CLAUDE_HOME** = Claude Code's home directory, `~/.claude` (on native Windows this is `%USERPROFILE%\.claude`). All session logs and the memory store live under it.
- **PROJECT_LOGS** = the session-log directory for this repo: the subdirectory of `CLAUDE_HOME/projects/` whose name ends in `-hiveplotlib` (the name encodes REPO's path). Resolve by globbing `CLAUDE_HOME/projects/*-hiveplotlib`; if several match, take the one with the most recent activity.
- **CONSUMER_LOGS** = the session-log directories for *all* hiveplotlib-family repos, not just the library: resolve by globbing `CLAUDE_HOME/projects/*hiveplotlib*`. This catches the library plus the downstream / satellite repos that actually drive the API (for example `*-hiveplotlib-nn-viz`, `*-hiveplotlib-spectral`, `*-hiveplotlib-futbol`, `*-hiveplotlib-bioinformatics-examples`). Used **only by step 3** below; steps 1-2 stay scoped to `PROJECT_LOGS`.
- **MEMORY** = `PROJECT_LOGS/memory` (curated memory markdown files plus `MEMORY.md`).
- **REFLECTIONS_OUT** = `CLAUDE_HOME/reflections` (create it if missing).

If any path fails to resolve, stop and report it in the summary rather than guessing.

## Goal
Reflect on recent hiveplotlib sessions, find recurring mistakes / friction / corrections, and turn the durable ones into curated gotchas in the agent harness. Leave all edits UNCOMMITTED for review and commit by the user. Then write a human-readable summary and let the completion notification surface it.

## Hard rules (read first)
- **Never commit, stage, push, or run any destructive git op** (no reset, restore, checkout of paths, clean, stash). The user reviews `git diff` and commits. Agents in this repo never touch git working-tree state.
- **Read the mental-model skill** at `REPO/agent-harness/.claude/skills/mental-model/SKILL.md`, especially **rule 11** (expertise-file discipline). Every gotcha entry must come from a REAL observed incident, not invented advice. Cite the date or session when you can. Keep entries lean (~60-90 words), lead + body shape. Edit/refine existing entries rather than duplicating; remove entries that no longer earn their place.
- **Match the repo's writing-voice conventions** (see the project and global CLAUDE.md): no em-dashes, no AI filler.
- **If you are confused or evidence is thin, do nothing and say so in the summary.** A quiet week is a valid outcome. Do not pad the gotchas to look productive.

## Inputs
1. **Session transcripts** (the "past conversations"): the `*.jsonl` files in `PROJECT_LOGS`. Only consider files modified in the **last 8 days**. These are large; do NOT read them whole. Instead grep each recent transcript for correction/friction signals and read only the surrounding excerpts. Useful signals: `STATUS: BLOCKED`, "no, ", "actually", "don't ", "you should have", "that's wrong", "revert", "undo", "stop", "I told you", "again", repeated identical error strings, ty/ruff/pytest failures that recurred, permission denials. If the `search_session_transcripts` MCP tool is available, use it too.
2. **Memory dir**: `MEMORY`. This is the existing curated memory.
3. **Consumer-repo transcripts (for step 3 only)**: the `*.jsonl` files across `CONSUMER_LOGS`, last 8 days. The blind API-usage mistakes step 3 targets happen in downstream / satellite repos, not in the library's own dev sessions (where people know the API), so this wider net is where the signal is. The `search_session_transcripts` MCP tool searches every repo's sessions in one query and is the preferred way to mine here; fall back to globbing and grepping `CONSUMER_LOGS` directly. Same friction/correction signals as Input 1, plus API-shaped ones: `AttributeError`, `TypeError`, "unexpected keyword", "no attribute", "from_networkx", "positional", hairball/datashader mentions, "unify".

## What to produce (edits, all uncommitted)
Work inside `REPO`.
1. **Harness gotchas.** For each durable, evidence-backed pattern you find, add or refine an entry in the right file under `REPO/agent-harness/.claude/expertise/`. **Route to the most specific home; `personal-gotchas.md` is a fallback, not a default:**
   - Role-specific code/test/docs/viz/qa mistakes -> the matching per-agent file (`code-engineer.md`, `test-engineer.md`, `docs-engineer.md`, `viz-critic.md`, `qa-engineer.md`, `orchestrator.md`, etc.), in its Patterns / Anti-patterns / Gotchas section. This is the preferred home even if the user personally hit the mistake.
   - Only gotchas with no single-role home -> `personal-gotchas.md`: either they span multiple roles, or they are environment/working-style flavored (WSL/Windows/PowerShell quirks, path/shell boundaries, repeated personal working-style corrections). When in doubt, prefer the role file.
   Edit the source files in `REPO/agent-harness/.claude/expertise/` (these are the source of truth, read directly from the submodule path by agents; `sync.sh` deliberately does not copy expertise into the consumer's `.claude/`).
2. **Memory consolidation.** Run a pass equivalent to the `consolidate-memory` skill over `MEMORY`: merge duplicates, fix stale/contradicted facts, prune the `MEMORY.md` index. Only make changes you're confident about.
3. **Library-usage docs.** Separately from the harness gotchas above, mine the consumer-repo transcripts (Input 3, spanning `CONSUMER_LOGS`) for recurring mistakes agents make *using the hiveplotlib API* (wrong construction path, positional `graph=`, cramming more than three groups onto one plot, not reaching for the datashader backend, un-unified axis ranges or colors, guessed kwarg names). Focus on the downstream / satellite repos, where agents drive the API blind; the library's own sessions rarely show these. These are library-usage facts, not harness-process gotchas, so they have three homes, all of which should stay in sync:
   - `REPO/agent-harness/.claude/skills/hiveplotlib-api-usage/SKILL.md` (the auto-loading usage skill),
   - `REPO/docs/source/_llms/llms.txt` (the concise, standalone-actionable index),
   - `REPO/docs/source/_llms/llms-full.txt` (the full usage reference).
   When you add a newly-observed trap, add it to whichever of the three fit and keep the wording consistent across them. **Higher bar for the two llms files:** they are public shipped docs, not internal notes, so only touch them for a genuinely recurring, verified trap, and verify the corrected API against current source before writing it (the transcript may show the wrong call *and* a wrong fix). Every claim in these files must be a real call signature, not a plausible guess.

## Summary + notification
Write a summary markdown to BOTH `REFLECTIONS_OUT/latest.md` (overwrite) and `REFLECTIONS_OUT/<YYYY-MM-DD>.md` (run `date` for the stamp). The summary must contain:
- The window reviewed and how many recent transcripts you examined.
- The recurring themes you found (or "quiet week, no durable patterns").
- A bullet per edit you made: `file -> one-line description`.
- Anything you noticed but were NOT confident enough to write (flagged for the user's judgment).
- A closing line telling the user where the uncommitted edits live: `Review harness edits with: git -C "<REPO>/agent-harness" diff  and library-usage doc edits with: git -C "<REPO>" diff -- docs/source/_llms  (then commit what you want).` (substitute the resolved REPO path).
End your run by stating the summary path so the completion notification points the user there.
