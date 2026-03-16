# agent-memory

Persistent memory across context compactions. Your agent accumulates knowledge instead of starting fresh every session.

## What's Included

- **PreCompact hook** — dumps full conversation to markdown before compaction
- **SessionStart hook** — searches your vault via QMD and re-injects relevant context after compaction
- **QMD MCP server** — local vault search (BM25, semantic vectors, hybrid rerank) available as tools during sessions

## Requirements

- [QMD](https://github.com/tobilu/qmd) installed and indexing a markdown vault
- `jq` (used by hooks)

## Setup

1. Install QMD:
   ```bash
   bun install -g @tobilu/qmd
   ```

2. Index your vault:
   ```bash
   qmd index /path/to/your/vault
   ```

3. Set `SESSIONS_DIR` to a directory inside your vault (recommended):
   ```bash
   export SESSIONS_DIR=~/notes/sessions
   ```

4. Enable the plugin in Claude Code

## How It Works

```
Session active → context fills up → PreCompact dumps to markdown →
Claude compacts → SessionStart fires → QMD searches vault →
relevant context re-injected → session continues with memory
```

Point `SESSIONS_DIR` at a vault subdirectory so session dumps become searchable by QMD. Add a git post-commit hook in your vault to keep the index fresh.
