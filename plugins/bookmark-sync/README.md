# bookmark-sync

Turn X bookmarks into ranked, analyzed research briefs via parallel deep-dive agents.

## What's Included

- **bookmark-sync skill** — triage pending bookmarks, spawn parallel research agents, review results
- **SessionStart hook** — auto-installs the `bre` Python CLI if not found
- **arxiv MCP server** — full paper text for research agents (optional, degrades gracefully)

## Install

```bash
claude plugin add ./plugins/bookmark-sync
```

Or from the marketplace:
```bash
claude plugin marketplace add k3nnethfrancis/agent-utils
claude plugin install bookmark-sync@agent-utils
```

## Setup

On first session, the hook installs the `bre` CLI. Then run:

```bash
bre setup
```

This prompts for X cookies, tests auth, and scaffolds the vault (inbox, reports, triage dirs, guidance template).

## How It Works

```
bre fetch → pending.json → skill triage → approval file → skill deep dive → reports/
```

The `bre` CLI handles fetching and enrichment (link expansion, GitHub READMEs, article content). The skill handles the intelligence — triage ranking, spawning parallel research agents, report writing.

## Requirements

- Python 3.11+
- Claude Code
- X account with bookmarks

## Source

The Python CLI lives in its own repo: [bookmark-research-engine](https://github.com/k3nnethfrancis/bookmark-research-engine)
