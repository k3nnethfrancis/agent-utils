# agent-memory

Persistent memory across context compactions. Your agent accumulates knowledge instead of starting fresh every session.

## What's Included

- **PreCompact hook** — dumps full conversation to markdown before compaction
- **SessionStart hook** — searches your vault via QMD and re-injects relevant context after compaction
- **QMD MCP server** — local vault search (BM25, semantic vectors, hybrid rerank) available as tools during sessions
- **Dependency check** — prints setup guidance on session start if anything is missing

## Install

```bash
# From the agent-utils marketplace
claude plugin marketplace add k3nnethfrancis/agent-utils
claude plugin install agent-memory@agent-utils

# Or directly
claude plugin add ./plugins/agent-memory
```

## Setup

The plugin checks dependencies on every session start and tells you what's missing. But here's the full flow:

### 1. Install QMD

```bash
npm install -g @tobilu/qmd
```

> **bun users:** If installed via bun, edit `~/.bun/bin/qmd` to use `exec node` instead of `exec bun` (sqlite-vec native extension issue).

### 2. Index your vault

```bash
qmd index /path/to/your/vault
```

### 3. Set SESSIONS_DIR

Point this at a directory **inside** your vault so session dumps become searchable by QMD:

```bash
export SESSIONS_DIR=~/notes/vault/sessions
```

Add this to your `.zshrc`/`.bashrc` to persist it.

### 4. (Optional) Auto-index on commit

If your vault is a git repo, add a post-commit hook to keep the QMD index fresh:

```bash
# In your vault's .git/hooks/post-commit
#!/bin/bash
qmd index /path/to/your/vault &
```

## How It Works

```
Session active → context fills up → PreCompact dumps to markdown →
Claude compacts → SessionStart fires → QMD searches vault →
relevant context re-injected → session continues with memory
```

### The loop

1. **PreCompact** fires before every compaction. Dumps the full conversation (user messages, assistant responses, tool calls) to `$SESSIONS_DIR/{session_id}.md` as readable markdown. Appends incrementally across multiple compactions in the same session.

2. **SessionStart** fires after compaction. Extracts recent user messages from the session dump, searches the vault via QMD (BM25 keyword search), and injects the top 5 matching notes as additional context. Prioritizes vault notes over session dumps to avoid circular injection.

3. **QMD MCP** provides `search`, `vsearch` (semantic), and `query` (hybrid + rerank) tools that Claude can use anytime during a session to search the vault.

## Requirements

- [QMD](https://github.com/tobilu/qmd) — local search engine over markdown
- `jq` — used by hooks for JSON parsing
- A markdown vault (Obsidian, plain files, anything)
