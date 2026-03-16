---
name: session-memory
description: Persistent memory system for Claude Code. Understands the session dump + vault search + re-injection pipeline. Use when discussing memory architecture, debugging context loss, or explaining how the agent-memory plugin works.
user-invocable: false
---

# Session Memory

This plugin provides persistent memory across context compactions using three components:

## How It Works

### 1. Pre-Compact Dump (PreCompact hook)

Before Claude Code compacts context, the hook dumps the full conversation to a markdown file at `$SESSIONS_DIR/{session_id}.md`. It tracks how many lines have been processed so subsequent compactions append incrementally.

**Configuration**: Set `SESSIONS_DIR` env var (defaults to `~/sessions`). Works best pointed at a directory inside a markdown vault so the notes become searchable.

### 2. Vault Search (QMD MCP)

QMD indexes your markdown vault locally (BM25 keyword search, semantic vector search, hybrid rerank). Runs entirely on-device using Metal GPU. The MCP server exposes search tools Claude can use during sessions.

**Requires**: `qmd` installed (`bun install -g @tobilu/qmd` or `npm install -g @tobilu/qmd`), vault indexed (`qmd index /path/to/vault`).

### 3. Context Re-Injection (SessionStart hook)

After compaction, this hook extracts key terms from the dumped session, queries QMD for relevant vault notes, and injects the results back into Claude's context. The agent maintains continuity without manual re-prompting.

**Only fires after compaction** (matcher: "compact"), not on fresh session starts.

## The Loop

```
Session active → context fills up → PreCompact dumps to markdown →
Claude compacts → SessionStart fires → QMD searches vault →
relevant context re-injected → session continues with memory
```

## Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `SESSIONS_DIR` | `~/sessions` | Where session dumps are written |

## Setup

1. Install QMD: `bun install -g @tobilu/qmd`
2. Index your vault: `qmd index /path/to/vault`
3. Set `SESSIONS_DIR` to a directory inside your vault (recommended)
4. Enable this plugin — hooks and MCP server register automatically

## Tips

- Point `SESSIONS_DIR` at a vault subdirectory (e.g., `~/notes/sessions/`) so session dumps become searchable by QMD
- Add a git post-commit hook in your vault to keep the QMD index fresh: `qmd index /path/to/vault &`
- Session files are markdown — they're readable in Obsidian or any markdown editor
