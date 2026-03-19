# agent-utils

My Claude Code setup — hooks, skills, configs, and MCP integrations. Everything here is what I actually run daily.

## Workspace Structure

Before installing anything, set up the workspace layout everything else builds on. Copy the template `CLAUDE.md` to your workspace root:

```bash
mkdir -p workspace/{projects,notes/vault/{sessions,logs,projects}}
cp templates/CLAUDE.md workspace/CLAUDE.md
touch workspace/notes/vault/{tasks,goals}.md
```

This gives you:
- `projects/` — code lives here, each project has its own repo
- `notes/vault/` — markdown vault with `tasks.md`, `goals.md`, daily notes, session dumps, and per-project planning docs
- A `CLAUDE.md` that teaches your agent how to navigate it all

See `templates/CLAUDE.md` for the full structure, protocols (progress ledgers, daily notes format, session memory), and setup instructions.

## Install

```bash
git clone https://github.com/k3nnethfrancis/agent-utils.git
cd agent-utils
```

### 1. Memory Plugin

The memory system bundles hooks + QMD MCP as a plugin since they work together:

```bash
claude plugin add ./plugins/agent-memory
```

Or install manually — see `plugins/agent-memory/README.md`.

### 2. Skills

Copy all skills or cherry-pick:

```bash
# All skills
cp -r skills/* ~/.claude/skills/

# Or pick what you need
cp -r skills/strategize ~/.claude/skills/
```

### 3. Hooks (if not using plugin)

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

Set `SESSIONS_DIR` to where you want conversation dumps (defaults to `~/sessions`). Works best pointed at a markdown vault — e.g. `export SESSIONS_DIR=~/notes/vault/sessions`. [Obsidian](https://obsidian.md) recommended but any markdown directory works.

**What this does**: Before context compaction, dumps the full conversation to markdown. After compaction, searches your vault via [QMD](https://github.com/tobilu/qmd) and re-injects relevant context. Claude doesn't lose track of what you were working on.

### Skills Reference

**Knowledge Management:**

| Skill | What it does |
|-------|-------------|
| `strategize` | Orient, plan day/week, think through direction, stress-test plans — pulls from all available context |
| `evolve-context` | Update project docs when reality drifts from plan — syncs CLAUDE.md, plan.md, ledger, README |
| `vault-tracking` | Commit your notes to git when substantial work accumulates |
| `log-work` | Timestamped entries in daily notes |
| `skill-improver` | Mine session logs for skill corrections and failures, propose improvements |

**Research:**

| Skill | What it does |
|-------|-------------|
| `lit-review` | Structured paper review with cybernetic analysis rubric |
| `log-research` | Experiment logging + published research logs |
| `write-research` | Guidelines for substantive research notes |
| `autoresearch` | Turn any research question into an automated experiment loop on small models |

**Engineering:**

| Skill | What it does |
|-------|-------------|
| `harness-engineering` | Design agent environments using cybernetics + OpenAI's harness principles |
| `project-kickoff` | Consistent project scaffolding with plan.md, resources, architecture docs |
| `oss-prep` | Prepare a project for open source release |

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

The core loop: **markdown vault + QMD + hooks = persistent memory**.

You keep a markdown vault (Obsidian recommended) with notes, daily logs, project docs, research. QMD indexes it locally. The hooks dump conversations before compaction and pull relevant vault context back in after. Your agent accumulates knowledge over time instead of starting fresh every session.

The skills layer on top — `strategize` pulls from your vault + connected MCPs to plan the day. `lit-review` writes structured reviews into the vault. `log-research` captures experiment results. Everything feeds back into the searchable vault.

The MCPs connect external sources — meeting notes from Granola, tasks from Linear, docs from Notion. More sources = richer context for planning and research skills.

## Reference Projects (Optional)

Included as git submodules under `reference/`. These are not required for any functionality — just useful reading.

- **[Agent Skills for Context Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering)**
- **[Everything Claude Code](https://github.com/affaan-m/everything-claude-code)**

```bash
git submodule update --init --recursive
```
