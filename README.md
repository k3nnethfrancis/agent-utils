# agent-utils

A collection of plugins, skills, hooks, and configs that I use daily with Claude Code. Everything here is designed to be easy to point your agents at and install — either all together or à la carte.

This isn't just a dotfiles repo. It's the scaffolding for how I think about building a personal AI operating system: a workspace where agents can see everything you're working on, remember what happened across sessions, and operate with real context about your projects, research, and goals.

## The Philosophy

I work from a single folder on my desktop called `lab/`. It has two subdirectories:

```
lab/
├── projects/    # every repo lives here
└── notes/       # markdown vaults (Obsidian)
```

**`projects/`** is where all code lives. Each project is its own git repo. Agent orchestration happens from the `lab/` root, which gives top-down visibility into everything.

**`notes/`** is where thinking happens. I keep one or more markdown vaults here — some public, some private. Daily notes, project planning docs, research working files, task lists, session history. I use [Obsidian](https://obsidian.md) as a frontend, but the file structure is designed for agents first: flat, greppable, cross-referenced with `[[links]]` and `#tags`.

The key insight: **agents work better when they can see your whole workspace**. A `CLAUDE.md` at the root teaches the agent how to navigate the structure — where to find tasks, how to log work, where project docs live, what the research arc is. The vault gives the agent long-term memory. The projects give it things to build.

Everything in this repo — the plugins, skills, hooks, configs — exists to make that loop work: **context in → work done → context preserved → better work next time**.

## Install

### Plugin Marketplace (recommended)

Register the marketplace, then install plugins by name:

```bash
# Add the marketplace
claude plugin marketplace add k3nnethfrancis/agent-utils

# Install plugins
claude plugin install agent-memory@agent-utils
claude plugin install bookmark-research-engine@agent-utils
```

| Plugin | What it does |
|--------|-------------|
| `agent-memory` | Persistent memory across compactions — session dumps, QMD vault search, auto-injection |
| `bookmark-research-engine` | Turn X bookmarks into ranked research briefs via parallel deep-dive agents |

Both plugins check dependencies on session start and tell you what's missing. No silent failures.

### Manual install

```bash
git clone https://github.com/k3nnethfrancis/agent-utils.git
cd agent-utils

# Memory plugin
claude plugin add ./plugins/agent-memory

# Bookmark plugin (from its own repo)
claude plugin install k3nnethfrancis/bookmark-research-engine
```

### Skills (non-plugin)

Skills are standalone — copy all or cherry-pick:

```bash
# All skills
cp -r skills/* ~/.claude/skills/

# Or pick what you need
cp -r skills/strategize ~/.claude/skills/
```

## Workspace Setup

The workspace template gives you the starting structure. Copy it and adapt to your setup:

```bash
mkdir -p lab/{projects,notes/vault/{sessions,logs,projects}}
cp templates/CLAUDE.md lab/CLAUDE.md
touch lab/notes/vault/{tasks,goals}.md
```

This gives you:
- `projects/` — repos go here, each with its own `CLAUDE.md`
- `notes/vault/` — markdown vault with `tasks.md`, `goals.md`, daily notes, session dumps, and per-project planning docs
- A root `CLAUDE.md` that teaches your agent the layout, protocols, and how to navigate

See `templates/CLAUDE.md` for the full structure, protocols (progress ledgers, daily notes format, session memory), and setup instructions.

## Plugins

### agent-memory

Persistent memory across context compactions. Before Claude compacts, the full conversation is dumped to markdown. After compaction, relevant vault context is searched via [QMD](https://github.com/tobilu/qmd) and re-injected. Your agent accumulates knowledge over time.

Includes: PreCompact hook, SessionStart re-injection hook, QMD MCP server, dependency checker.

See `plugins/agent-memory/README.md` for setup.

### bookmark-research-engine

Turns X bookmarks into ranked, analyzed research briefs. Fetches bookmarks via X's GraphQL API (no external CLI dependencies), enriches links, then uses Claude Code agents in parallel to triage against your research interests and produce structured reports.

Includes: `bre` Python CLI (auto-installed), bookmark-sync skill, arxiv MCP server.

See the [bookmark-research-engine repo](https://github.com/k3nnethfrancis/bookmark-research-engine) for details.

## Skills

**Knowledge Management:**

| Skill | What it does |
|-------|-------------|
| `strategize` | Orient, plan day/week, think through direction — pulls from all available context |
| `evolve-context` | Update project docs when reality drifts from plan — syncs CLAUDE.md, plan.md, ledger, README |
| `vault-tracking` | Commit your notes to git when substantial work accumulates |
| `log-work` | Timestamped entries in daily notes |
| `skill-improver` | Mine session logs for skill corrections and failures, propose improvements |

**Research:**

| Skill | What it does |
|-------|-------------|
| `lit-review` | Structured paper review with analysis rubric |
| `log-research` | Experiment logging + published research logs |
| `write-research` | Guidelines for substantive research notes |
| `autoresearch` | Turn any question into an automated (code → run → score) optimization loop |
| `bookmark-sync` | Turn X bookmarks into ranked, analyzed research briefs via parallel agents |

**Engineering:**

| Skill | What it does |
|-------|-------------|
| `harness-engineering` | Design agent environments using cybernetics + harness engineering principles |
| `project-kickoff` | Consistent project scaffolding with plan.md, resources, architecture docs |
| `oss-prep` | Prepare a project for open source release |

## MCP Integrations

Setup guides in `mcps/` — each README has the exact install command and auth setup.

| Service | Install |
|---------|---------|
| Notion | `claude mcp add notion -- npx -y @notionhq/notion-mcp-server` |
| Linear | `claude mcp add linear -- npx -y @linear/linear-mcp` |
| Granola | `claude mcp add granola --transport http https://mcp.granola.ai/mcp` |

## Configs

### Statusline

```bash
cp configs/statusline.sh ~/.claude/configs/statusline.sh
```

Shows: `[dir] branch (NΔ) | Model | 73%` — the percentage is effective context remaining.

## How It Fits Together

The core loop: **markdown vault + QMD + hooks = persistent memory**.

You keep a markdown vault with notes, daily logs, project docs, research. QMD indexes it locally. The hooks dump conversations before compaction and pull relevant vault context back in after. Your agent accumulates knowledge over time instead of starting fresh every session.

The skills layer on top — `strategize` pulls from your vault + connected MCPs to plan the day. `lit-review` writes structured reviews into the vault. `autoresearch` runs autonomous experiment loops. Everything feeds back into the searchable vault.

The MCPs connect external sources — meeting notes from Granola, tasks from Linear, docs from Notion. More sources = richer context for planning and research skills.

## Reference Projects

Included as git submodules under `reference/`. Not required — just useful reading.

- **[Agent Skills for Context Engineering](https://github.com/muratcankoylan/Agent-Skills-for-Context-Engineering)**
- **[Everything Claude Code](https://github.com/affaan-m/everything-claude-code)**

```bash
git submodule update --init --recursive
```
