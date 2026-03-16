# QMD MCP Setup for Claude Code

[QMD](https://github.com/tobilu/qmd) is a local search engine over markdown files. It indexes a vault and provides BM25 keyword search, semantic vector search, and hybrid query+rerank — all running locally on Metal GPU.

Used here as an MCP server so Claude Code can search your notes vault during sessions.

## Install

```bash
npm install -g @tobilu/qmd
# or
bun install -g @tobilu/qmd
```

**Note:** If installed via bun, the `qmd` binary must run under Node (not bun) due to `sqlite-vec` native extension path resolution issues with bun's module cache. Edit the launcher script at `~/.bun/bin/qmd` to use `exec node` instead of `exec bun`. If you install via npm, this doesn't apply — it works out of the box.

## Index Your Vault

```bash
qmd index /path/to/your/markdown/vault
```

This creates embeddings locally using `embeddinggemma-300M` on Metal GPU. First run takes a few minutes; subsequent runs are incremental.

## Add to Claude Code

```bash
claude mcp add qmd -s user -- qmd mcp
```

Or manually in `~/.claude/.mcp.json`:
```json
{
  "mcpServers": {
    "qmd": {
      "command": "qmd",
      "args": ["mcp"]
    }
  }
}
```

## What You Get

MCP tools for:
- **search** — BM25 keyword search (fast, exact terms)
- **vector_search** — Semantic search via local embeddings
- **deep_search** — Hybrid query with reranking
- **get** — Retrieve a specific document by path

## Auto-Indexing

Add a post-commit hook to keep the index fresh:

```bash
# .git/hooks/post-commit
#!/bin/sh
qmd index /path/to/your/vault &
```

## Pairs Well With

- **`hooks/session-context-inject.sh`** — Uses QMD to re-inject relevant vault context after context compaction
- **`hooks/pre-compact-dump.sh`** — Dumps session history that QMD can then index and search
