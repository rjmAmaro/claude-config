#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

command -v claude >/dev/null || { echo "claude CLI not found in PATH" >&2; exit 1; }
command -v jq >/dev/null || { echo "jq not found (brew install jq)" >&2; exit 1; }

# 1. Symlink the portable files/dirs into ~/.claude
for item in CLAUDE.md settings.json skills commands agents; do
  [ -e "$REPO/$item" ] || continue
  ln -sfn "$REPO/$item" "$CLAUDE_DIR/$item"
done

# 2. Register each MCP server from mcp.json at user scope
jq -r '.mcpServers | keys[]' "$REPO/mcp.json" | while IFS= read -r name; do
  json="$(jq -c --arg n "$name" '.mcpServers[$n]' "$REPO/mcp.json")"

  # add-json fails if the server exists, so remove first (ignore "not found")
  claude mcp remove "$name" --scope user </dev/null >/dev/null 2>&1 || true
  claude mcp add-json "$name" "$json" --scope user </dev/null

  echo "Registered MCP server: $name"
done

echo "Done. Restart Claude Code and run /mcp or 'claude mcp list' to verify."
