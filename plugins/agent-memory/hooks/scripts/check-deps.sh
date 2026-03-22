#!/bin/bash
# SessionStart hook: Check agent-memory dependencies and print setup guidance
# Runs on every session start (not just compaction)

export PATH="/opt/homebrew/bin:$HOME/.bun/bin:$HOME/.local/bin:$PATH"

MISSING=""

# Check jq
if ! command -v jq &>/dev/null; then
    MISSING="${MISSING}\n- jq: brew install jq"
fi

# Check qmd
if ! command -v qmd &>/dev/null; then
    MISSING="${MISSING}\n- qmd: npm install -g @tobilu/qmd (then: qmd index /path/to/your/vault)"
fi

# Check SESSIONS_DIR
if [ -z "$SESSIONS_DIR" ]; then
    MISSING="${MISSING}\n- SESSIONS_DIR not set: export SESSIONS_DIR=~/path/to/vault/sessions"
elif [ ! -d "$SESSIONS_DIR" ]; then
    mkdir -p "$SESSIONS_DIR"
fi

if [ -n "$MISSING" ]; then
    cat <<EOF
[agent-memory] Setup incomplete. Missing:
$(echo -e "$MISSING")

See: https://github.com/k3nnethfrancis/agent-utils/tree/main/plugins/agent-memory
EOF
fi

exit 0
