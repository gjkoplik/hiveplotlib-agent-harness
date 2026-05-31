# Scheduled tasks (canonical source)

Version-controlled source of truth for the desktop **scheduled tasks** (routines) run against this project. The Claude desktop app keeps its own runtime copy of each task in its internal store (`~/.claude/scheduled-tasks/<id>/SKILL.md` plus an internal record of the schedule and notify flag). These files here are the canonical copies so the routines are versioned, reviewable, and travel with the harness submodule.

The task bodies are written to be machine-agnostic: they derive the repo from the current working directory (`git rev-parse`) and everything else from `~/.claude` plus a glob, so porting to another machine should need no edits. The one assumption is that `~/.claude` resolves to Claude Code's home on the target machine. A first real run is what confirms that.

## How a task file is structured

Each `<task-id>/SKILL.md` has YAML frontmatter and a prompt body:

```yaml
---
name: <task-id>
description: <one-line summary>
schedule: "<5-field cron, local time>"   # documentation of the live schedule
notifyOnCompletion: true                  # documentation of the live notify flag
---
<the prompt body the routine runs>
```

The frontmatter is **documentation only**. The desktop app does not read these files; it reads its own store. The bridge is the `scheduled-tasks` MCP tool.

- **`name` / `description`** match what the app shows.
- **`schedule` / `notifyOnCompletion`** record the live registration so this file is self-describing. They are not enforced by anything; if you change them here, push the change live (below).
- **The body** (everything after the frontmatter) is the literal `prompt` argument passed to the MCP tool.

## Push-live ritual (MCP push, manual)

The app store and these files are kept in sync by hand through the MCP tool. After editing a task file and committing it in the harness repo:

- **New task:** `create_scheduled_task(taskId=<name>, description=<description>, cronExpression=<schedule>, notifyOnCompletion=<flag>, prompt=<body>)`
- **Prompt-only change:** `update_scheduled_task(taskId=<name>, prompt=<body>)`
- **Schedule / notify change:** `update_scheduled_task(taskId=<name>, cronExpression=<schedule>)` or `(notifyOnCompletion=<flag>)`

Ask Claude in any session to "push the harness-reflection task live" and it will read the body here and make the call. The cron and notify flag live only in the app store, so they must go through the tool; there is no file in the store that carries them.

When porting the whole setup to a new machine, re-register each task once with `create_scheduled_task` (the bodies here are the `prompt`, the frontmatter carries the `schedule` and `notifyOnCompletion`). Nothing in the bodies is machine-specific, so no per-machine editing of the prompts should be needed.

## Notes

- Tasks run only while the desktop app is open. If it was closed when a task was due, it runs on next launch.
- Each run is a fresh session with no memory of prior runs or of the conversation that created it. The prompt body must be fully self-contained.
- Routines never commit. They leave edits in the working tree for the user to review (`git diff`) and commit.
- **Run mode must be set in the desktop UI, per task, per machine.** For a routine to run unattended it needs auto / bypass-permissions mode; otherwise it stalls on "allow once" prompts mid-run. This mode is app-local state, not captured in these files and not settable via the `scheduled-tasks` MCP tools, so it does not travel with the harness. Set it in the app's Scheduled section after registering each task (and again when porting to a new machine). The alternative, allowlisting the needed tools in `settings.json` / `settings.local.json`, is version-controlled and portable but a broader permission grant.

## Tasks

Both run weekly in the middle of the night, Saturday ~3am local (`7 3 * * 6`), timed to land before the weekly token reset.

- **`harness-reflection`** — local "dream": mines the week's hiveplotlib session transcripts for recurring mistakes and updates the harness gotchas (the per-role `expertise/<agent>.md` files by preference, the cross-cutting `expertise/personal-gotchas.md` as a fallback) plus a memory-consolidation pass. Writes a digest to `~/.claude/reflections/`.
- **`wiki-update`** — review of the project's changes, updates the research wiki, writes a digest to `~/.claude/reflections/`.
