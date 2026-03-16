# agent-utils

My Claude Code setup — hooks, skills, configs, and MCP integrations. Everything here is what I actually run daily.

## Quick Setup

Clone and install everything:

```bash
git clone https://github.com/k3nnethfrancis/agent-utils.git
cd agent-utils
```

### 1. Hooks (persistent memory across compactions)

```bash
cp hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
```

Add to `~/.claude/settings.json` under `"hooks"`:

```json
{
  "hooks": {
    "PreCompact": [{ "command": "~/.claude/hooks/pre-compact-dump.sh" }],
    "SessionStart": [{ "matcher": "compact", "command": "~/.claude/hooks/session-context-inject.sh" }]
  }
}
```

Set `SESSIONS_DIR` to where you want conversation dumps (defaults to `~/sessions`). Works best pointed at an Obsidian vault — e.g. `export SESSIONS_DIR=~/notes/vault/sessions`.

**What this does**: Before context compaction, dumps the full conversation to markdown. After compaction, searches your vault via [QMD](https://github.com/tobilu/qmd) and re-injects relevant context. Claude doesn't lose track of what you were working on.

### 2. Skills

```bash
# All skills (user-level)
cp -r skills/* ~/.claude/skills/

# Or cherry-pick into a project
cp -r skills/harness-engineering .claude/skills/
```

| Skill | What it does |
|-------|-------------|
| `daily-planning` | Plan the day/week from tasks, notes, meetings, project state |
| `strategize` | Think through direction, trade-offs, priorities across projects |
| `harness-engineering` | Design agent environments using cybernetics + OpenAI's harness principles |
| `plan-interview` | Stress-test a plan through structured questioning |
| `project-kickoff` | Consistent project scaffolding |
| `git-tracking` | Smart commit bundling (PR-sized, not edit-sized) |
| `work-logging` | Timestamped daily note logging |
| `oss-prep` | Prepare a project for open source release |
| `lit-review` | Structured paper review with cybernetic analysis rubric |
| `research-note-writing` | Guidelines for substantive research notes |
| `research-log` | Experiment logging + published research logs |

### 3. Memory (QMD)

Local vault search — BM25, semantic vectors, and hybrid rerank. All local, no API calls. Powers the session-context-inject hook and runs as an MCP server for in-conversation vault queries.

```bash
bun install -g @tobilu/qmd
qmd index ~/path/to/your/vault
```

Register as MCP server:

```bash
claude mcp add qmd -- qmd mcp
```

See `memory/README.md` for full setup including auto-indexing via git hooks.

### 4. MCP Integrations

Setup guides in `mcps/` — each README has the exact install command and what keys/auth the user needs to provide.

| Service | Install |
|---------|---------|
| Notion | `claude mcp add notion -- npx -y @notionhq/notion-mcp-server` |
| Linear | `claude mcp add linear -- npx -y @linear/linear-mcp` |
| Granola | `claude mcp add granola --transport http https://mcp.granola.ai/mcp` |

Read each `mcps/*/README.md` for auth setup details.

### 5. Statusline

```bash
cp configs/statusline.sh ~/.claude/configs/statusline.sh
```

Add to `~/.claude/settings.json`:

```json
{
  "statusline": { "command": "~/.claude/configs/statusline.sh" }
}
```

Shows: `[dir] branch (NΔ) | Model | 73%` — the percentage is effective context remaining.

## How It Fits Together

The core loop: **notes vault + QMD + hooks = persistent memory**.

You keep a markdown vault (Obsidian recommended) with notes, daily logs, project docs, research. QMD indexes it locally. The hooks dump conversations before compaction and pull relevant vault context back in after. Your agent accumulates knowledge over time instead of starting fresh every session.

The skills layer on top — `daily-planning` pulls from your vault + connected MCPs to plan the day. `lit-review` writes structured reviews into the vault. `research-log` captures experiment results. Everything feeds back into the searchable vault.

The MCPs connect external sources — meeting notes from Granola, tasks from Linear, docs from Notion. More sources = richer context for planning and research skills.

## Reference Projects

Included as git submodules under `reference/`:

- **[Agent Skills for Context Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering)**
- **[Everything Claude Code](https://github.com/affaan-m/everything-claude-code)**

```bash
git submodule update --init --recursive
```
