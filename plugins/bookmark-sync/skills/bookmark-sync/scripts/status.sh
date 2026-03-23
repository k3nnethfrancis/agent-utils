#!/bin/bash
# Quick status check for bookmark sync pipeline
# Configure these paths for your setup:
SYNC_LOG="${BOOKMARK_SYNC_DIR:-$HOME/automations/bookmark-sync}/sync.log"
PENDING="${BOOKMARK_TOOL_DIR:-$HOME/bookmark-tool}/.state/pending-bookmarks.json"
TRIAGE_DIR="${BOOKMARKS_DIR:-$HOME/notes/bookmarks}/triage"
REPORTS_DIR="${BOOKMARKS_DIR:-$HOME/notes/bookmarks}/reports"

echo "=== Bookmark Sync Status ==="
echo ""

# Last sync
if [ -f "$SYNC_LOG" ]; then
    LAST_SYNC=$(grep "Starting bookmark sync" "$SYNC_LOG" | tail -1 | sed 's/\[//' | sed 's/\].*//')
    echo "Last sync: $LAST_SYNC"

    # Check for errors in last run
    LAST_ERROR=$(grep -E "command not found|Error|error|FAIL" "$SYNC_LOG" | tail -1)
    if [ -n "$LAST_ERROR" ]; then
        echo "Warning: Last error: $LAST_ERROR"
    else
        echo "No errors in last run"
    fi
else
    echo "No sync log found"
fi

echo ""

# Pending count
if [ -f "$PENDING" ]; then
    COUNT=$(python3 -c "import json; d=json.load(open('$PENDING')); print(d.get('count', len(d.get('bookmarks', []))))" 2>/dev/null)
    echo "Pending bookmarks: ${COUNT:-0}"
else
    echo "Pending bookmarks: 0 (no state file)"
fi

echo ""

# Latest triage
echo "Latest triage:"
ls -lt "$TRIAGE_DIR"/*.md 2>/dev/null | head -3 | awk '{print "  " $6, $7, $8, $9}'

echo ""

# Latest reports
echo "Latest reports:"
ls -lt "$REPORTS_DIR"/*.md 2>/dev/null | head -5 | awk '{print "  " $6, $7, $8, $9}'

echo ""

# Report count
TOTAL=$(ls "$REPORTS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "Total reports: $TOTAL"
