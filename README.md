# Claude Code Utils

A collection of utilities and scripts for getting the most out of [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## What's Here

### Statusline (`statusline/`)

A custom statusline script that shows git context and session info at a glance.

```
[project] main (3Δ) | Opus 4.6 | 88%
```

See [`statusline/README.md`](statusline/README.md) for setup.

### Notion MCP Setup (`mcp/notion/`)

Step-by-step guide for connecting Claude Code to your Notion workspace via the Model Context Protocol.

See [`mcp/notion/README.md`](mcp/notion/README.md) for the full setup guide.

### Scripts (`scripts/`)

- **`granola-export.sh`** — Exports Granola meeting transcripts for use in Obsidian.

## Repository Structure

```
agent-utils/
├── statusline/          # Custom statusline for Claude Code
├── mcp/
│   └── notion/          # Notion MCP setup guide
└── scripts/             # Automation scripts
```

## Contributing

Contributions welcome — utilities, scripts, or improvements to existing content. Focus on things that help people work more effectively with Claude Code.
