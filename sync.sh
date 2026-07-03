#!/usr/bin/env bash
# Sync the harness's skills, agents, commands, and settings.json into a
# consumer repo's .claude/.
#
# Layout: this script lives at the harness root. The harness is intended to
# live at <consumer-repo>/agent-harness/ as a gitignored folder. Without an
# explicit argument, sync.sh syncs into the parent directory if it looks
# like a consumer (has pyproject.toml or .claude/); otherwise pass the
# consumer path explicitly.
#
# Why copies and not symlinks: WSL symlinks are not followed by Windows-side
# tools accessing via UNC paths, which Claude Code uses on at least one of
# the user's setups. Copies are the cross-boundary workaround.
#
# Usage:
#   bash sync.sh                       # auto-detects parent as consumer
#   bash sync.sh /path/to/consumer     # explicit consumer path

set -e

HARNESS_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -n "$1" ]; then
  CONSUMER="$1"
elif [ -f "$HARNESS_DIR/../pyproject.toml" ] || [ -d "$HARNESS_DIR/../.claude" ]; then
  CONSUMER="$HARNESS_DIR/.."
else
  echo "Cannot detect a consumer repo at $HARNESS_DIR/.. (no pyproject.toml or .claude/)." >&2
  echo "Pass the consumer path explicitly: bash sync.sh /path/to/consumer" >&2
  exit 1
fi

if [ ! -d "$CONSUMER" ]; then
  echo "Consumer repo not found at $CONSUMER" >&2
  exit 1
fi

# Skills that document how to USE the installed hiveplotlib package. They must
# NOT sync into the hiveplotlib library repo itself: inside the library the
# source tree is the source of truth, and a usage skill (which lags in-flight
# API changes and mirrors the possibly-stale llms.txt files) would fight active
# API development. They DO sync into downstream consumer repos (research /
# analysis / notebook repos that depend on the published package).
DOWNSTREAM_ONLY_SKILLS=("hiveplotlib-api-usage")

# Detect the library repo itself by its source package.
IS_LIBRARY_REPO=0
if [ -d "$CONSUMER/src/hiveplotlib" ]; then
  IS_LIBRARY_REPO=1
fi

# Is a skill excluded for this consumer? (Only ever excluded in the library repo.)
skill_excluded() {
  [ "$IS_LIBRARY_REPO" -eq 1 ] || return 1
  local name="$1"
  local s
  for s in "${DOWNSTREAM_ONLY_SKILLS[@]}"; do
    [ "$s" = "$name" ] && return 0
  done
  return 1
}

mkdir -p "$CONSUMER/.claude/skills" "$CONSUMER/.claude/agents" "$CONSUMER/.claude/commands"
# Note: .claude/plans/ is no longer auto-created here. Plans for hiveplotlib
# (and for the wiki itself) live in the wiki submodule at wiki/wiki/plans/.
# Only the agent-harness-self consumer still uses .claude/plans/ (gitignored);
# that directory is created on demand by the orchestrator when needed.

# Auto-discover skills (directories) and agents (.md files) under .claude/.
# Add a new skill or agent in the harness, sync.sh picks it up automatically.
#
# NOTE: .claude/expertise/ is INTENTIONALLY NOT synced. Agents read AND write
# their expertise files directly from the harness submodule path (per
# mental-model rule 11). If sync.sh started copying expertise into the
# consumer's .claude/, agent updates to expertise would land in the consumer
# copy and get clobbered on the next sync — losing accumulated lessons.
# Don't add expertise to the sync loop without solving that problem first.

if [ -d "$HARNESS_DIR/.claude/skills" ]; then
  for skill_dir in "$HARNESS_DIR/.claude/skills"/*/; do
    [ -d "$skill_dir" ] || continue
    skill=$(basename "$skill_dir")
    if skill_excluded "$skill"; then
      rm -rf "$CONSUMER/.claude/skills/$skill"   # remove any prior copy
      echo "skipped skill (downstream-only, not for library repo): $skill"
      continue
    fi
    rm -rf "$CONSUMER/.claude/skills/$skill"
    cp -r "$skill_dir" "$CONSUMER/.claude/skills/"
    echo "synced skill: $skill"
  done
fi

if [ -d "$HARNESS_DIR/.claude/agents" ]; then
  for agent_file in "$HARNESS_DIR/.claude/agents"/*.md; do
    [ -f "$agent_file" ] || continue
    agent=$(basename "$agent_file")
    rm -f "$CONSUMER/.claude/agents/$agent"
    cp "$agent_file" "$CONSUMER/.claude/agents/"
    echo "synced agent: $agent"
  done
fi

if [ -d "$HARNESS_DIR/.claude/commands" ]; then
  for command_file in "$HARNESS_DIR/.claude/commands"/*.md; do
    [ -f "$command_file" ] || continue
    command=$(basename "$command_file")
    rm -f "$CONSUMER/.claude/commands/$command"
    cp "$command_file" "$CONSUMER/.claude/commands/"
    echo "synced command: $command"
  done
fi

# Sync settings.json. Consumer overrides live in settings.local.json (sync
# never touches that file). Defensive backup: if the consumer's existing
# settings.json differs from the harness template, copy it aside first so
# content is recoverable.

if [ -f "$HARNESS_DIR/.claude/settings.json" ]; then
  if [ -f "$CONSUMER/.claude/settings.json" ] && \
     ! cmp -s "$HARNESS_DIR/.claude/settings.json" "$CONSUMER/.claude/settings.json"; then
    BACKUP="$CONSUMER/.claude/settings.json.pre-harness-sync.bak"
    cp "$CONSUMER/.claude/settings.json" "$BACKUP"
    echo
    echo "WARNING: $CONSUMER/.claude/settings.json differed from harness template; backed up to .pre-harness-sync.bak."
    echo "         Migrate consumer-specific settings to .claude/settings.local.json, then delete the .bak."
    echo
  fi
  cp "$HARNESS_DIR/.claude/settings.json" "$CONSUMER/.claude/settings.json"
  echo "synced settings.json"
fi

# Prune orphans: items WE placed previously but no longer place. We track
# what we placed via a manifest at $CONSUMER/.claude/.harness-managed.
# Consumer-specific skills and agents (never in our manifest) are NEVER
# touched. Only items we placed before and don't place now get removed —
# this handles renames and deletions of harness-owned content while
# leaving consumer content alone.

MANIFEST="$CONSUMER/.claude/.harness-managed"

# Read previous manifest (the items we placed in a previous run).
PREV_MANAGED=()
if [ -f "$MANIFEST" ]; then
  while IFS= read -r line; do
    [ -n "$line" ] && PREV_MANAGED+=("$line")
  done < "$MANIFEST"
fi

# Build the current set: what we placed in this run.
CURRENT_MANAGED=()
if [ -d "$HARNESS_DIR/.claude/skills" ]; then
  for skill_dir in "$HARNESS_DIR/.claude/skills"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name=$(basename "$skill_dir")
    skill_excluded "$skill_name" && continue
    CURRENT_MANAGED+=("skills/$skill_name")
  done
fi
if [ -d "$HARNESS_DIR/.claude/agents" ]; then
  for agent_file in "$HARNESS_DIR/.claude/agents"/*.md; do
    [ -f "$agent_file" ] || continue
    CURRENT_MANAGED+=("agents/$(basename "$agent_file")")
  done
fi
if [ -d "$HARNESS_DIR/.claude/commands" ]; then
  for command_file in "$HARNESS_DIR/.claude/commands"/*.md; do
    [ -f "$command_file" ] || continue
    CURRENT_MANAGED+=("commands/$(basename "$command_file")")
  done
fi
if [ -f "$HARNESS_DIR/.claude/settings.json" ]; then
  CURRENT_MANAGED+=("settings.json")
fi

# Remove items we managed before but no longer manage (renames or deletions).
for prev in "${PREV_MANAGED[@]}"; do
  found=0
  for curr in "${CURRENT_MANAGED[@]}"; do
    if [ "$prev" = "$curr" ]; then
      found=1
      break
    fi
  done
  if [ "$found" -eq 0 ]; then
    target="$CONSUMER/.claude/$prev"
    if [ -d "$target" ]; then
      rm -rf "$target"
      echo "removed orphan: $prev"
    elif [ -f "$target" ]; then
      rm -f "$target"
      echo "removed orphan: $prev"
    fi
  fi
done

# Write the new manifest for the next run.
{
  for entry in "${CURRENT_MANAGED[@]}"; do
    echo "$entry"
  done
} > "$MANIFEST"

echo
echo "Sync complete to $CONSUMER/.claude/"
echo "(plans for hiveplotlib live in the wiki submodule at wiki/wiki/plans/; harness-self plans at agent-harness/.claude/plans/)"
