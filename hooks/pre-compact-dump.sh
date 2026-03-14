#!/bin/bash
# Pre-compact hook: Append conversation history to session file as markdown
# Dumps to $SESSIONS_DIR/{session_id}.md
#
# Handles message types: user, assistant, summary
# Formats tool_use and tool_result cleanly
# Tracks processed lines to append incrementally across compactions
#
# Setup:
#   1. Set SESSIONS_DIR env var or edit the default below
#   2. Register in hooks config:
#      "hooks": { "PreCompact": [{ "command": "/path/to/pre-compact-dump.sh" }] }

# Don't use set -e - we need to handle jq errors gracefully

SESSIONS_DIR="${SESSIONS_DIR:-$HOME/sessions}"

mkdir -p "$SESSIONS_DIR"

input=$(cat)

session_id=$(echo "$input" | jq -r '.session_id // empty')
transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

if [ -z "$session_id" ] || [ "$session_id" = "null" ]; then
    exit 0
fi

if [ -z "$transcript_path" ] || [ "$transcript_path" = "null" ] || [ ! -f "$transcript_path" ]; then
    exit 0
fi

session_file="$SESSIONS_DIR/${session_id}.md"
marker_file="$SESSIONS_DIR/.${session_id}.lines"

if [ -f "$marker_file" ]; then
    processed_lines=$(cat "$marker_file")
else
    processed_lines=0
    {
        echo "# Session ${session_id}"
        echo ""
        echo "_Started: $(date '+%Y-%m-%d %H:%M')_"
        echo ""
        echo "---"
        echo ""
    } > "$session_file"
fi

total_lines=$(wc -l < "$transcript_path" | tr -d ' ')
new_lines=$((total_lines - processed_lines))

if [ "$new_lines" -le 0 ]; then
    exit 0
fi

temp_file=$(mktemp)
tail -n "$new_lines" "$transcript_path" > "$temp_file"

line_num=0
while IFS= read -r line || [ -n "$line" ]; do
    line_num=$((line_num + 1))

    msg_type=$(echo "$line" | jq -r '.type // empty' 2>/dev/null) || continue
    [ -z "$msg_type" ] && continue

    case "$msg_type" in
        user)
            content_type=$(echo "$line" | jq -r '.message.content | type' 2>/dev/null) || continue
            timestamp=$(echo "$line" | jq -r '.timestamp // empty' 2>/dev/null)

            if [ "$content_type" = "string" ]; then
                content=$(echo "$line" | jq -r '.message.content' 2>/dev/null) || continue
                if [ -n "$content" ] && [ "$content" != "null" ]; then
                    {
                        echo "## User"
                        [ -n "$timestamp" ] && [ "$timestamp" != "null" ] && echo "_${timestamp}_"
                        echo ""
                        echo "$content"
                        echo ""
                    } >> "$session_file"
                fi
            elif [ "$content_type" = "array" ]; then
                {
                    echo "## User (Tool Results)"
                    [ -n "$timestamp" ] && [ "$timestamp" != "null" ] && echo "_${timestamp}_"
                    echo ""
                } >> "$session_file"

                blocks_file=$(mktemp)
                echo "$line" | jq -c '.message.content[]' 2>/dev/null > "$blocks_file" || true

                while IFS= read -r block || [ -n "$block" ]; do
                    block_type=$(echo "$block" | jq -r '.type // empty' 2>/dev/null) || continue

                    if [ "$block_type" = "tool_result" ]; then
                        tool_use_id=$(echo "$block" | jq -r '.tool_use_id // "unknown"' 2>/dev/null)
                        is_error=$(echo "$block" | jq -r '.is_error // false' 2>/dev/null)

                        result_content_type=$(echo "$block" | jq -r '.content | type' 2>/dev/null)

                        if [ "$result_content_type" = "string" ]; then
                            result_content=$(echo "$block" | jq -r '.content' 2>/dev/null)
                        else
                            result_content=$(echo "$block" | jq -r '.content[]? | select(.type == "text") | .text' 2>/dev/null)
                        fi

                        {
                            echo "**Tool Result** (\`$tool_use_id\`)"
                            [ "$is_error" = "true" ] && echo "_Error_"
                            echo ""
                            echo '```'
                            echo "$result_content"
                            echo '```'
                            echo ""
                        } >> "$session_file"
                    fi
                done < "$blocks_file"
                rm -f "$blocks_file"
            fi
            ;;

        assistant)
            timestamp=$(echo "$line" | jq -r '.timestamp // empty' 2>/dev/null)
            model=$(echo "$line" | jq -r '.message.model // empty' 2>/dev/null)

            {
                echo "## Assistant"
                [ -n "$timestamp" ] && [ "$timestamp" != "null" ] && echo "_${timestamp}_"
                [ -n "$model" ] && [ "$model" != "null" ] && echo "_Model: ${model}_"
                echo ""
            } >> "$session_file"

            blocks_file=$(mktemp)
            echo "$line" | jq -c '.message.content[]?' 2>/dev/null > "$blocks_file" || true

            while IFS= read -r block || [ -n "$block" ]; do
                block_type=$(echo "$block" | jq -r '.type // empty' 2>/dev/null) || continue

                case "$block_type" in
                    text)
                        text=$(echo "$block" | jq -r '.text // empty' 2>/dev/null)
                        if [ -n "$text" ]; then
                            {
                                echo "$text"
                                echo ""
                            } >> "$session_file"
                        fi
                        ;;
                    thinking)
                        thinking=$(echo "$block" | jq -r '.thinking // empty' 2>/dev/null)
                        if [ -n "$thinking" ]; then
                            {
                                echo "<details>"
                                echo "<summary>Thinking</summary>"
                                echo ""
                                echo "$thinking"
                                echo ""
                                echo "</details>"
                                echo ""
                            } >> "$session_file"
                        fi
                        ;;
                    tool_use)
                        tool_name=$(echo "$block" | jq -r '.name // "unknown"' 2>/dev/null)
                        tool_id=$(echo "$block" | jq -r '.id // "unknown"' 2>/dev/null)
                        tool_input=$(echo "$block" | jq -r '.input // {}' 2>/dev/null)

                        {
                            echo "**Tool: \`$tool_name\`** (\`$tool_id\`)"
                            echo ""
                            echo '```json'
                            echo "$tool_input" | jq '.' 2>/dev/null || echo "$tool_input"
                            echo '```'
                            echo ""
                        } >> "$session_file"
                        ;;
                esac
            done < "$blocks_file"
            rm -f "$blocks_file"
            ;;

        summary)
            summary_text=$(echo "$line" | jq -r '.summary // empty' 2>/dev/null)
            if [ -n "$summary_text" ] && [ "$summary_text" != "null" ]; then
                {
                    echo "---"
                    echo ""
                    echo "## Summary (Compaction Point)"
                    echo ""
                    echo "> $summary_text"
                    echo ""
                    echo "---"
                    echo ""
                } >> "$session_file"
            fi
            ;;
    esac
done < "$temp_file"

rm -f "$temp_file"

echo "$total_lines" > "$marker_file"

exit 0
