# How This All Fits Together

This isn't just a collection of scripts and skills — it's a system for doing knowledge work with AI. Here's how the pieces connect and why they're shaped the way they are.

## The Setup

Everything runs from a single workspace directory:

```
lab/
├── notes/
│   └── vault/              # your thinking (Obsidian, more on this below)
│       ├── projects/        # project planning docs
│       ├── lit-reviews/     # paper reviews
│       ├── sessions/        # auto-dumped conversation history
│       └── YYYY-MM-DD.md    # daily notes
├── projects/
│   ├── your-project-a/
│   ├── your-project-b/
│   └── agent-utils/         # this repo
└── CLAUDE.md                # workspace-level instructions
```

You open Claude Code (or Codex, or whatever) from `lab/`. This gives the agent access to both your code (`projects/`) and your thinking (`notes/`). That's the key move — **your notes and your code live in the same tree**.

## Why Obsidian

*(You could use any markdown editor. But you should use [Obsidian](https://obsidian.md).)*

Obsidian is a local-first markdown editor with a plugin ecosystem. The reason it matters here:

- **Local files** — your vault is just a folder of `.md` files. No API needed, no sync service in the way. Claude reads them directly with the Read tool. QMD indexes them locally.
- **Backlinks and graph** — `[[double-bracket]]` links between notes create a knowledge graph you can traverse visually. When your AI dumps session history into `sessions/` and you link those to project notes, you get a web of connected thinking that persists across conversations.
- **Daily notes** — Obsidian has a built-in daily note system. The `work-logging` skill writes to these. Over time they become a searchable log of everything you've done.
- **Community plugins** — Git backup, Dataview for querying frontmatter, Templates, Kanban boards. The vault becomes your operating system for thinking.
- **No lock-in** — it's markdown. If you leave Obsidian, your notes come with you.

The vault is where rough thinking lives. It's not published, it's not pretty, it's where you figure things out. Some notes graduate to published artifacts. Most don't. That's fine.

## The Memory Layer

**QMD** indexes your vault and provides search — keyword (BM25), semantic (vector), and hybrid (query + rerank). All local, all on Metal GPU, no API calls.

Two hooks connect QMD to Claude Code:

1. **`pre-compact-dump.sh`** — Before Claude compacts your conversation (when context runs low), it dumps the full transcript to `vault/sessions/{session_id}.md`. This means your conversation history persists even after compaction.

2. **`session-context-inject.sh`** — After compaction, this hook takes your recent conversation, searches QMD for relevant vault notes, and injects them back into Claude's context. The agent doesn't lose track of what you were working on.

Together: **dump before compact, search and re-inject after**. Claude Code gets persistent memory across a session, even through multiple compactions.

QMD also runs as an MCP server, so Claude can search your vault mid-conversation anytime. The hooks handle the automatic case; the MCP handles the "let me look something up" case.

## The Research Flow

If you do research (papers, literature, experiments), the skills chain together:

1. **Bookmarks arrive** — whatever your source (Twitter, RSS, colleagues), new things to read accumulate
2. **`lit-review`** — structured paper review with frontmatter metadata and analysis
3. **`research-log`** — after running experiments, log what happened and what it means
4. **`research-note-writing`** — when enough understanding accumulates, write a substantive note
5. **`research-log-writing`** — periodic published logs synthesizing across work streams

All of these write to your vault. QMD indexes them. Next time you're working on a related topic, the context-inject hook or a manual QMD search surfaces them. **Your past research informs your current work automatically.**

## The Planning Flow

Two skills handle orientation:

- **`daily-planning`** — pulls from task lists, recent notes, meetings, and project state to propose what to focus on today
- **`strategize`** — a slower mode for thinking through direction, trade-offs, and priorities across projects

Both work better the more context sources you have connected. Meeting notes from Granola, tasks from Linear, docs from Notion — each MCP adds another surface the planning skills can draw from.

## The Meta-Skills

- **`plan-interview`** — before committing to build something, stress-test the plan through structured questioning
- **`project-kickoff`** — consistent scaffolding when starting something new
- **`git-tracking`** — smart commit bundling (PR-sized, not edit-sized)
- **`work-logging`** — timestamp what you did in daily notes
- **`oss-prep`** — when a project is ready to share, scan and transform it

## Connecting MCP Sources

The MCPs in `mcps/` connect Claude to where your work lives:

| Source | What it gives Claude |
|--------|---------------------|
| **QMD** (memory/) | Your entire vault — notes, research, project docs, session history |
| **Granola** | Meeting transcripts and action items |
| **Linear** | Tasks, projects, priorities |
| **Notion** | Docs, wikis, shared knowledge bases |

You don't need all of them. QMD is the foundation. Add others as they become relevant to your workflow.

## The Statusline

A small thing that matters: `configs/statusline.sh` shows you `[dir] branch (NΔ) | Model | 73%` at a glance. The percentage is effective context remaining — when it hits 0%, auto-compact fires. Knowing where you are in the context window changes how you work (wrap up vs. keep going, compact manually vs. let it auto-fire).

## Starting from Scratch

If you're setting up from zero:

1. Create a vault directory with Obsidian (or just `mkdir`)
2. Install QMD, index your vault
3. Copy the two hooks to `~/.claude/hooks/`
4. Set `SESSIONS_DIR` to `your-vault/sessions/`
5. Pick the skills you want, copy to `.claude/skills/`
6. Start working — the system builds value over time as your vault grows

The first few sessions feel like any other Claude Code session. After a few weeks of daily notes, session dumps, and research notes accumulating, the vault becomes genuinely useful context that makes every session smarter.
