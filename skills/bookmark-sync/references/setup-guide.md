# Bookmark Sync Setup Guide

One-time setup for the bookmark research pipeline.

## Prerequisites

- **Claude Code** installed
- **Python 3.11+**

## Step 1: Install BRE

```bash
pip install git+https://github.com/k3nnethfrancis/bookmark-research-engine.git
```

Verify: `bre --help`

## Step 2: Run Interactive Setup

```bash
bre setup
```

This will:
1. Prompt for your X authentication cookies (`auth_token`, `ct0`)
2. Test authentication by fetching 1 bookmark
3. Ask where to put your vault (default: `~/.config/bre/vault`)
4. Scaffold the vault directory structure with all required files
5. Write config to `~/.config/bre/config.yaml`

### Getting X Cookies

1. Open X (x.com) in your browser while logged in
2. Open DevTools → Application → Cookies → x.com
3. Copy these two cookie values:
   - `auth_token` — your session token
   - `ct0` — your CSRF token

These cookies rotate periodically. If the pipeline stops fetching, run `bre setup` again.

## Step 3: Edit Research Interests

The most important file is `bookmark-review-guidance.md` in your vault's `bookmarks/` directory. `bre setup` creates a template — edit it to define your research categories and tier heuristics. Without this, triage has nothing to rank against.

## Step 4: Verify

```bash
# Fetch a small batch to test
bre fetch -n 5

# Check status
bre status
```

## Step 5: Schedule (Optional)

For daily automated runs, create a `run.sh` that calls `bre fetch` followed by Claude headless invocations for inbox writing, triage, and deep dive.

**macOS (launchd)**:
```bash
launchctl load ~/Library/LaunchAgents/com.user.bookmark-sync.plist
```

**Linux (cron)**:
```bash
0 17 * * * /path/to/bookmark-sync/run.sh >> /path/to/sync.log 2>&1
```

## Troubleshooting

### "bre: command not found"
Ensure the package is installed: `pip install git+https://github.com/k3nnethfrancis/bookmark-research-engine.git`

### No new bookmarks fetched
X cookies expired. Run `bre setup` to update them.

### Query ID errors (404/422)
X rotates GraphQL query IDs. Run `bre refresh-ids`.

### Bookmarks fetched but not processed
Check `sync.log` for errors in the Claude headless invocation. Common issues:
- Missing API key (Claude Code needs `ANTHROPIC_API_KEY` in environment or OAuth session)
- Permission errors on vault files
