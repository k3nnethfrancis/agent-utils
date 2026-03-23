---
name: bookmark-sync
description: Manage a bookmark research pipeline — fetch new bookmarks, triage against research interests, spawn parallel deep-dive agents, and review results. Use when the user says "bookmark sync", "check bookmarks", "review bookmarks", "triage bookmarks", "deep dive bookmarks", "run bookmark pipeline", or asks about setting up the bookmark system.
---

# Bookmark Sync

Research pipeline that turns X bookmarks into ranked, analyzed research briefs. Supports both automated (launchd/cron) and interactive (in-session) workflows.

## Configuration

Before using this skill, set up two things:

1. **Paths** — update the paths table below to match your workspace layout
2. **Research interests** — create a `bookmark-review-guidance.md` file defining your research categories and tier heuristics (see Customization section)

## Modes

### Status
Check pipeline health and pending work. **Use this first** when the user mentions bookmarks.

1. Check for errors in recent sync log:
   ```bash
   tail -30 $BOOKMARK_SYNC_DIR/sync.log
   ```
2. Count pending bookmarks:
   ```bash
   cat $BOOKMARK_TOOL_DIR/.state/pending-bookmarks.json | python3 -c "import json,sys; d=json.load(sys.stdin); print(f'Pending: {d.get(\"count\", len(d.get(\"bookmarks\", [])))}')"
   ```
3. Check latest triage and reports:
   ```bash
   ls -lt $BOOKMARKS_DIR/triage/ | head -5
   ls -lt $BOOKMARKS_DIR/reports/ | head -10
   ```
4. Report: last sync date, any errors, pending count, latest triage date, latest report date.

### Fetch
Pull new bookmarks from X into the pending queue. Uses the [bookmark-research-engine](https://github.com/k3nnethfrancis/bookmark-research-engine) (`bre` CLI).

```bash
bre fetch -n 50
```

Or with a specific folder:
```bash
bre fetch -n 50 --folder research
```

First-time setup: `bre setup` (prompts for X cookies, tests auth, scaffolds vault).

Then check what came in and summarize — authors, topics, link count.

### Triage
Rank pending bookmarks against your research interests. Two sub-modes:

**Interactive triage** (preferred when user is present):
1. List all pending bookmarks with author, text snippet, and link count
2. Rank them by relevance to the user's research interests (from guidance doc)
3. Present ranked list in tiers: Tier 1 (deep dive), Tier 2 (skim), Tier 3 (skip)
4. Get user confirmation or adjustments
5. Write approval file to `$BOOKMARKS_DIR/triage/YYYY-MM-DD-approved.md`

**Automated triage** (for unattended runs):
Follow the triage prompt at `$BOOKMARK_SYNC_DIR/TRIAGE_PROMPT.md`. Read the guidance doc at `$BOOKMARKS_DIR/bookmark-review-guidance.md` for category definitions and tier heuristics.

**Ranking heuristics** (customize in guidance doc):
- Cross-category items get bumped up one tier
- Empirical results > theoretical frameworks
- Novel methods > incremental improvements
- Surprising findings > confirmatory results

### Deep Dive
Spawn parallel research agents for approved bookmarks. This is the core value — turning bookmarks into analyzed research briefs.

1. Read the approval file from `$BOOKMARKS_DIR/triage/`
2. Read research guidance from `$BOOKMARKS_DIR/bookmark-review-guidance.md`
3. Check existing reports in `$BOOKMARKS_DIR/reports/` — skip duplicates
4. For each approved item, spawn a background Agent with:
   - The bookmark source material (tweet text, expanded URLs, fetched content from pending JSON)
   - Matched research categories and context from the guidance doc
   - Instructions to investigate via WebSearch/WebFetch, then write report
   - Report destination: `$BOOKMARKS_DIR/reports/{slug}.md`

**Agent prompt template** — see `references/deepdive-agent-prompt.md` for the full template. Each agent gets the bookmark content, matched categories, and instructions to investigate and write a structured report.

**Report format** — see `references/report-format.md` for the full template.

**Parallelism**: Up to 7 agents concurrently. Use `run_in_background=true` on all Agent calls.

5. As agents complete, summarize findings to the user
6. Mark approval file as processed (append `processed: true`)

### Review
Discuss completed reports and connect findings to active projects.

1. Read recent reports from `$BOOKMARKS_DIR/reports/`
2. Summarize key findings, cross-cutting themes, and project implications
3. If the user wants a research queue note for a project, write one to the relevant project directory

### Setup
Guide through initial setup of the bookmark pipeline. Only needed once per machine.

```bash
# Install the bookmark research engine
pip install git+https://github.com/k3nnethfrancis/bookmark-research-engine.git

# Interactive setup — prompts for X cookies, tests auth, scaffolds vault
bre setup
```

See `references/setup-guide.md` for the full walkthrough.

## Paths

Update these to match your workspace:

| What | Where |
|------|-------|
| Pipeline scripts | `$BOOKMARK_SYNC_DIR` (e.g. `automations/bookmark-sync/`) |
| Pending bookmarks | `$BOOKMARK_TOOL_DIR/.state/pending-bookmarks.json` |
| Inbox | `$BOOKMARKS_DIR/inbox.md` |
| Research guidance | `$BOOKMARKS_DIR/bookmark-review-guidance.md` |
| Triage reports | `$BOOKMARKS_DIR/triage/` |
| Triage log | `$BOOKMARKS_DIR/triage-log.md` |
| Deep dive reports | `$BOOKMARKS_DIR/reports/` |
| Engagement log | `$BOOKMARKS_DIR/engagement-log.md` |
| Feedback reports | `$BOOKMARKS_DIR/feedback/` |
| Sync log | `$BOOKMARK_SYNC_DIR/sync.log` |

## Customization

### Research Categories

Create `$BOOKMARKS_DIR/bookmark-review-guidance.md` with your research interests organized into categories. Example categories:

```markdown
## Categories

### multi-agent-systems
Papers, tools, and findings about multi-agent coordination, communication, and orchestration.

### reinforcement-learning
RL training methods, reward design, RLHF/RLAIF, policy optimization.

### developer-tooling
Agent frameworks, IDE integrations, evaluation harnesses, developer experience.
```

Define as many or few categories as match your interests. These become the canonical slugs used in report frontmatter.

### Tier Heuristics

In the same guidance doc, define what makes something Tier 1 vs Tier 2 vs Tier 3:
- **Tier 1**: Directly relevant to active projects, novel methodology, actionable
- **Tier 2**: Interesting context, worth skimming, may become relevant
- **Tier 3**: Tangentially related, skip unless slow day

## Rules

- Always use `date` command for timestamps — never guess
- Update engagement log when reading reports: `- **read**: \`reports/{filename}.md\` — {context}`
- Mark approval files as processed after deep dive completes
- Reports use slugified filenames: lowercase, hyphens, no special characters

## Gotchas

- **X cookie expiry**: `auth_token` and `ct0` rotate periodically. If fetch returns 0 new bookmarks, run `bre setup` to update cookies.
- **Query ID rotation**: X rotates GraphQL query IDs. If `bre fetch` returns 404/422, run `bre refresh-ids`.
- **Deep dive agent count**: 7 concurrent agents works well. Higher risks rate limits.
- **Approval file format**: Must end with `processed: true` on its own line to be skipped by subsequent runs. Append it, don't rewrite.
- **Guidance doc is required**: Without `bookmark-review-guidance.md`, triage has nothing to rank against. `bre setup` creates a template.
