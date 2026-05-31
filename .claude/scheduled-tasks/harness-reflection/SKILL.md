---
name: harness-reflection
description: "Weekly local dream: mine the week's hiveplotlib sessions for recurring mistakes and update the harness gotchas. No commits."
schedule: "7 3 * * 6"
notifyOnCompletion: true
---
You are running a weekly self-reflection ("dream") over the past week's Claude Code work on the **hiveplotlib** project, to improve the agent harness. This is a fresh session with no memory of prior runs; everything you need is below.

## Environment (the only machine-specific block; resolve these first)
- **REPO** = the current working directory, which is the hiveplotlib checkout. Confirm with `git rev-parse --show-toplevel`. If you are not inside the hiveplotlib repo, stop and say so in the summary instead of guessing.
- **CLAUDE_HOME** = Claude Code's home directory, `~/.claude` (on native Windows this is `%USERPROFILE%\.claude`). All session logs and the memory store live under it.
- **PROJECT_LOGS** = the session-log directory for this repo: the subdirectory of `CLAUDE_HOME/projects/` whose name ends in `-hiveplotlib` (the name encodes REPO's path). Resolve by globbing `CLAUDE_HOME/projects/*-hiveplotlib`; if several match, take the one with the most recent activity.
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

## What to produce (edits, all uncommitted)
Work inside `REPO`.
1. **Harness gotchas.** For each durable, evidence-backed pattern you find, add or refine an entry in the right file under `REPO/agent-harness/.claude/expertise/`. **Route to the most specific home; `personal-gotchas.md` is a fallback, not a default:**
   - Role-specific code/test/docs/viz/qa mistakes -> the matching per-agent file (`code-engineer.md`, `test-engineer.md`, `docs-engineer.md`, `viz-critic.md`, `qa-engineer.md`, `orchestrator.md`, etc.), in its Patterns / Anti-patterns / Gotchas section. This is the preferred home even if the user personally hit the mistake.
   - Only gotchas with no single-role home -> `personal-gotchas.md`: either they span multiple roles, or they are environment/working-style flavored (WSL/Windows/PowerShell quirks, path/shell boundaries, repeated personal working-style corrections). When in doubt, prefer the role file.
   Edit the source files in `REPO/agent-harness/.claude/expertise/` (these are the source of truth, read directly from the submodule path by agents; `sync.sh` deliberately does not copy expertise into the consumer's `.claude/`).
2. **Memory consolidation.** Run a pass equivalent to the `consolidate-memory` skill over `MEMORY`: merge duplicates, fix stale/contradicted facts, prune the `MEMORY.md` index. Only make changes you're confident about.

## Summary + notification
Write a summary markdown to BOTH `REFLECTIONS_OUT/latest.md` (overwrite) and `REFLECTIONS_OUT/<YYYY-MM-DD>.md` (run `date` for the stamp). The summary must contain:
- The window reviewed and how many recent transcripts you examined.
- The recurring themes you found (or "quiet week, no durable patterns").
- A bullet per edit you made: `file -> one-line description`.
- Anything you noticed but were NOT confident enough to write (flagged for the user's judgment).
- A closing line: `Review with: git -C "<REPO>/agent-harness" diff  (then commit what you want).` (substitute the resolved REPO path).
End your run by stating the summary path so the completion notification points the user there.
