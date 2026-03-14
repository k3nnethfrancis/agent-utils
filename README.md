# agent-utils

Hooks, skills, configs, and MCP guides for working with Claude Code. Built through daily use — everything here solves a real problem.

**New here?** Read **[WORKFLOW.md](WORKFLOW.md)** for how all the pieces fit together — the vault structure, memory layer, research flow, and why Obsidian.

## What's Here

### hooks/

Shell scripts that plug into Claude Code's hook system for automated workflows.

- **`pre-compact-dump.sh`** — Saves conversation history to markdown before context compaction. Enables session persistence across compactions. Set `SESSIONS_DIR` to control where dumps land.
- **`session-context-inject.sh`** — After compaction, searches your notes vault (via [QMD](https://github.com/tobilu/qmd)) and re-injects relevant context. Requires QMD indexing a markdown vault.

These two hooks together give Claude Code persistent memory across compactions: dump the conversation, then pull relevant vault context back in when the session resumes.

### skills/

Claude Code skills (SKILL.md format) — drop into your `.claude/skills/` directory.

**Planning & Strategy:**
- **`daily-planning`** — Pull context from all sources (tasks, notes, meetings, projects) to plan the day or week
- **`strategize`** — Strategic thinking mode for direction, trade-offs, and priorities across projects

**Workflow:**
- **`plan-interview`** — Stress-test a plan through structured one-question-at-a-time interrogation
- **`project-kickoff`** — Consistent project scaffolding with agent-efficient structure
- **`git-tracking`** — Smart commit bundling (think PR-sized, not edit-sized)
- **`work-logging`** — Timestamped daily note logging
- **`oss-prep`** — Scan, discuss, and transform a project for open source release

**Research:**
- **`lit-review`** — Structured paper review with cybernetic analysis rubric, templates, and examples
- **`research-note-writing`** — Guidelines for substantive research notes (analysis, not inventory)
- **`research-log-writing`** — Published research log style (plain documentation, not performance)
- **`research-log`** — Durable experiment logging with quality bar for writeup-ready entries

### memory/

- **`qmd/`** — Local markdown vault search via [QMD](https://github.com/tobilu/qmd). BM25 keyword search, semantic vector search, and hybrid query+rerank — all local on Metal GPU. Powers the session-context-inject hook and serves as an MCP server for in-session vault queries.

### mcps/

Setup guides for MCP servers that connect Claude to external services. Each README is agent-actionable — contains the exact install command, what the user needs to provide (API keys, OAuth), and how to verify.

- **`notion/`** — Notion workspace access
- **`linear/`** — Linear issue tracking
- **`granola/`** — Meeting notes via Granola's official MCP server

### configs/

- **`statusline.sh`** — Custom statusline showing `[dir] branch (NΔ) | Model | effective_%` where the percentage reflects usable context remaining (adjusted for auto-compact threshold)

## Setup

### Hooks

```bash
# Copy hooks to Claude Code hooks directory
cp hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
```

Configure in your Claude Code settings or `hooks.json`:
```json
{
  "hooks": {
    "PreCompact": [{ "command": "~/.claude/hooks/pre-compact-dump.sh" }],
    "SessionStart": [{ "matcher": "compact", "command": "~/.claude/hooks/session-context-inject.sh" }]
  }
}
```

Set `SESSIONS_DIR` environment variable to your preferred dump location (defaults to `~/sessions`).

### Skills

Copy skill directories into your project or user-level `.claude/skills/`:

```bash
cp -r skills/* ~/.claude/skills/
# or for project-level
cp -r skills/* .claude/skills/
```

### Statusline

```bash
cp configs/statusline.sh ~/.claude/configs/statusline.sh
```

Then in `~/.claude/settings.json`:
```json
{
  "statusline": { "command": "~/.claude/configs/statusline.sh" }
}
```

## Philosophy

- **Built from use, not theory** — everything here came from solving actual workflow problems
- **Shell scripts over complexity** — hooks are bash, skills are markdown, configs are plain text
- **Composable** — pick what you need, ignore the rest
- **No personal data** — paths use env vars or `$HOME`, no hardcoded user directories
