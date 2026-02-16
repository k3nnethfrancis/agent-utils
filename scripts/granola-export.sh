#!/bin/bash
# Export Granola meeting transcripts
# Usage: ./granola-export.sh [command] [args]
#
# Commands:
#   list          List meetings from local cache
#   list-api      List all meetings from API
#   export <id>   Export single meeting to stdout
#   export-api N  Export N most recent meetings from API
#   recent N      Export N most recent meetings (shortcut)

GRANOLA_DIR="/Users/kenneth/Desktop/lab/projects/granola-extractor"

cd "$GRANOLA_DIR" || { echo "Error: granola-extractor not found at $GRANOLA_DIR"; exit 1; }

case "${1:-help}" in
    list)
        go run . list
        ;;
    list-api)
        go run . list-api
        ;;
    export)
        if [ -z "$2" ]; then
            echo "Usage: granola-export.sh export <document-id>"
            exit 1
        fi
        go run . export "$2"
        ;;
    export-api)
        go run . export-api "${2:-10}"
        ;;
    recent)
        go run . export-api "${2:-10}"
        ;;
    help|--help|-h)
        echo "Granola Export - Extract meeting transcripts"
        echo ""
        echo "Usage: granola-export.sh <command> [args]"
        echo ""
        echo "Commands:"
        echo "  list          List meetings from local cache"
        echo "  list-api      List all meetings from API (389+ docs)"
        echo "  export <id>   Export single meeting to stdout"
        echo "  export-api N  Export N most recent meetings to outputs/"
        echo "  recent N      Shortcut for export-api"
        echo ""
        echo "Examples:"
        echo "  granola-export.sh list-api | head -20"
        echo "  granola-export.sh export 1b02f020-c045-4c80-8975-8f71435ee063"
        echo "  granola-export.sh recent 5"
        echo ""
        echo "Note: Token expires after ~6h. Open Granola app to refresh."
        ;;
    *)
        echo "Unknown command: $1"
        echo "Run 'granola-export.sh help' for usage"
        exit 1
        ;;
esac
