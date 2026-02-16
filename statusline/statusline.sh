#!/bin/bash
# Claude Code custom statusline
# Output: [dir] branch (NΔ) | Model | effective_%
#
# Displays:
#   - Current directory name in brackets
#   - Git branch (if in a repo)
#   - Uncommitted change count with delta symbol (hidden when 0)
#   - Model display name
#   - Effective remaining context (scaled so 0% = auto-compact fires)

input=$(cat)

CWD=$(echo "$input" | jq -r '.cwd // "."')
DIR=$(basename "$CWD")
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')

# Git info
BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null)
CHANGES=$(git -C "$CWD" status --porcelain 2>/dev/null | wc -l | tr -d ' ')

OUT="[${DIR}]"
if [ -n "$BRANCH" ]; then
  OUT="$OUT $BRANCH"
  if [ "$CHANGES" -gt 0 ] 2>/dev/null; then
    OUT="$OUT (${CHANGES}Δ)"
  fi
fi
OUT="$OUT | $MODEL"

# Effective context remaining (adjusted for auto-compact threshold ~17%)
COMPACT_THRESHOLD=17
REMAINING=$(echo "$input" | jq -r '.context_window.remaining_percentage // 100' | cut -d. -f1)
EFFECTIVE=$(( REMAINING - COMPACT_THRESHOLD ))
if [ "$EFFECTIVE" -lt 0 ] 2>/dev/null; then EFFECTIVE=0; fi
# Scale to 0-100 range so 100% = full usable context
SCALED=$(( EFFECTIVE * 100 / (100 - COMPACT_THRESHOLD) ))
if [ "$SCALED" -gt 100 ] 2>/dev/null; then SCALED=100; fi
OUT="$OUT | ${SCALED}%"

echo "$OUT"
