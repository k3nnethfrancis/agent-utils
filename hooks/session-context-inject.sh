#!/bin/bash
# SessionStart hook (compact matcher): Re-inject relevant context after compaction
# Uses QMD to search a notes vault for context relevant to the current conversation.
#
# Requires:
#   - qmd (https://github.com/tobilu/qmd) installed and indexing your vault
#   - SESSIONS_DIR set to match pre-compact-dump.sh output location
#
# Setup:
#   Register in hooks config:
#   "hooks": { "SessionStart": [{ "matcher": "compact", "command": "/path/to/session-context-inject.sh" }] }
#
# Output goes to stdout and is added to Claude's context as additionalContext

export PATH="/opt/homebrew/bin:$HOME/.bun/bin:$PATH"

SESSIONS_DIR="${SESSIONS_DIR:-$HOME/sessions}"

input=$(cat)

session_id=$(echo "$input" | jq -r '.session_id // empty')
hook_source=$(echo "$input" | jq -r '.source // empty')

# Only run after compaction
if [ "$hook_source" != "compact" ]; then
    exit 0
fi

SESSION_FILE="$SESSIONS_DIR/${session_id}.md"

if [ ! -f "$SESSION_FILE" ]; then
    exit 0
fi

# Extract meaningful text from session dump for QMD query
# Strategy: grab user messages, strip markdown noise, take last ~500 chars
QUERY=$(grep -A5 "^## User$" "$SESSION_FILE" \
    | grep -v "^## User" \
    | grep -v "^--$" \
    | grep -v "^_[0-9]" \
    | grep -v "^$" \
    | tail -20 \
    | sed 's/[#*>]//g' \
    | tr '\n' ' ' \
    | sed 's/  */ /g' \
    | tail -c 500)

# Fallback: extract from assistant text
if [ -z "$QUERY" ] || [ ${#QUERY} -lt 20 ]; then
    QUERY=$(tail -c 5000 "$SESSION_FILE" \
        | grep -v '^```' \
        | grep -v "^##" \
        | grep -v "^_" \
        | grep -v "tool_" \
        | sed 's/[#*>{}]//g' \
        | tr '\n' ' ' \
        | sed 's/  */ /g' \
        | tail -c 500)
fi

if [ -z "$QUERY" ] || [ ${#QUERY} -lt 20 ]; then
    exit 0
fi

QUERY=$(echo "$QUERY" | xargs)

# Run QMD keyword search — fast, no model loading
RESULTS=$(qmd search "$QUERY" --files -n 5 </dev/null 2>/dev/null || true)

# Prefer non-session results
NON_SESSION=$(echo "$RESULTS" | grep -v "/sessions/" || true)
if [ -n "$NON_SESSION" ]; then
    RESULTS="$NON_SESSION"
fi

if [ -z "$RESULTS" ]; then
    exit 0
fi

cat <<EOF
## Vault Context (auto-injected after compaction)

The following vault notes are relevant to this session's conversation. Use them to maintain continuity.

$RESULTS

_To search for more vault context, use the qmd MCP tools (search, vector_search, deep_search, get)._
EOF

exit 0
