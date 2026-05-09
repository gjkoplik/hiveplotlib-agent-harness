#!/usr/bin/env bash
# Sync the harness's skills and agents into a consumer repo's .claude/.
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

mkdir -p "$CONSUMER/.claude/skills" "$CONSUMER/.claude/agents" "$CONSUMER/.claude/plans"

# Auto-discover skills (directories) and agents (.md files) under .claude/.
# Add a new skill or agent in the harness, sync.sh picks it up automatically.

if [ -d "$HARNESS_DIR/.claude/skills" ]; then
  for skill_dir in "$HARNESS_DIR/.claude/skills"/*/; do
    [ -d "$skill_dir" ] || continue
    skill=$(basename "$skill_dir")
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

echo
echo "Sync complete to $CONSUMER/.claude/"
echo "(plans dir at $CONSUMER/.claude/plans/ is ready for use)"
