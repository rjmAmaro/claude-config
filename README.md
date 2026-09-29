# claude-config

My personal [Claude Code](https://docs.claude.com/en/docs/claude-code) configuration: global instructions, settings, skills, commands, agents, and MCP servers.

An install script symlinks the portable files into `~/.claude/` and registers the MCP servers at user scope with `claude mcp add-json`.

## Repo layout

```
claude-config/
├── CLAUDE.md        # global instructions
├── settings.json    # permissions, hooks, env, etc.
├── skills/
├── commands/
├── agents/
├── mcp.json         # MCP servers (source of truth)
├── install.sh
└── .gitignore
```

Anything missing from this list is simply skipped by the installer.

## Prerequisites

- macOS with zsh (the default shell)
- [Claude Code](https://docs.claude.com/en/docs/claude-code) installed, with `claude` on your `PATH`
- `jq`: `brew install jq`
- Node.js, only if you switch Context7 to the `npx` (stdio) variant

## Installation

1. Clone the repo anywhere. Avoid spaces in the path and iCloud-synced folders such as `~/Documents` or `~/Desktop`:

   ```bash
   git clone <your-repo-url> ~/my-repos/claude-config
   cd ~/my-repos/claude-config
   ```

2. If `~/.claude/` already contains a real `skills/`, `commands/`, or `agents/` directory, move its contents into the repo first. The installer replaces symlinks but will not overwrite real directories.

3. Set your Context7 API key (see the next section). Do this before launching Claude Code.

4. Run the installer:

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

5. Restart Claude Code and verify:

   ```bash
   claude mcp list
   claude mcp get context7
   ```

   Or run `/mcp` inside a Claude Code session.

The installer is safe to re-run after any change. For each server in `mcp.json` it removes the existing user-scope entry and adds it again, so manual edits to those entries will be overwritten.

> **Don't move the repo after installing.** The symlinks store the absolute path. If you move or rename the folder, re-run `./install.sh` from the new location.

## Setting the Context7 API key with `~/.zshrc.local`

`mcp.json` references the key as `${CONTEXT7_API_KEY}`, so the secret never lives in this repo. Claude Code expands the variable at runtime from your shell environment.

1. Get a key from your Context7 dashboard at <https://context7.com>. The key is optional but gives higher rate limits.

2. Store it in a local, untracked file:

   ```bash
   echo 'export CONTEXT7_API_KEY="your-key-here"' >> ~/.zshrc.local
   chmod 600 ~/.zshrc.local
   ```

3. Make zsh load that file by adding this to `~/.zshrc`:

   ```bash
   echo '[ -f ~/.zshrc.local ] && source ~/.zshrc.local' >> ~/.zshrc
   source ~/.zshrc
   ```

4. Check that it is set (prints only the first 6 characters):

   ```bash
   echo "${CONTEXT7_API_KEY:0:6}..."
   ```

5. Restart Claude Code from that terminal.

### Notes

- **GUI-launched apps don't read `~/.zshrc`.** If you start Claude Code from an IDE opened via Spotlight or the Dock, it won't see the variable. Launch the IDE from a terminal (for example `code .`).
- **Unset variable.** If `CONTEXT7_API_KEY` is not set, the server may fail to load or send an empty header. Either make sure it is exported, or remove the `headers` block from `mcp.json` to run without a key.
- **Never commit the key.** `~/.zshrc.local` lives in your home directory, outside this repo. If you version your dotfiles too, add it to that repo's `.gitignore`.

## Adding another MCP server

Add an entry under `mcpServers` in `mcp.json`, then re-run `./install.sh`:

```json
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    }
  }
}
```

## What is not tracked

Do not commit any of these:

- `~/.claude.json` (account data, per-project history, caches)
- `settings.local.json`, `projects/`, session history
- Anything containing credentials

## Troubleshooting

| Symptom | Likely cause |
| --- | --- |
| `claude CLI not found in PATH` | Claude Code isn't installed, or your shell doesn't have it on `PATH` |
| `jq not found` | Run `brew install jq` |
| Server missing from `claude mcp list` | Installer ran without `--scope user` support, or you're checking from a different config dir; run `claude mcp get context7` |
| Server fails to connect | `CONTEXT7_API_KEY` not exported in the shell that launched Claude Code |
| Symlinks broken | Repo was moved; re-run `./install.sh` |
