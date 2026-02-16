# Claude Code Statusline

A custom statusline script for [Claude Code](https://claude.ai/code) that shows git context and session info at a glance.

## Output

```
[project] main (3Δ) | Opus 4.6 | 88%
```

- `[project]` — current directory name
- `main` — active git branch (hidden outside git repos)
- `(3Δ)` — number of uncommitted changes (hidden when clean)
- `Opus 4.6` — active model
- `88%` — remaining context window

## Setup

1. Copy the script to your Claude config directory:

```bash
cp statusline.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

2. Add to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

3. Restart Claude Code.

## Requirements

- `jq` — for parsing the JSON payload Claude Code pipes to the script
- `git` — for branch and change detection
