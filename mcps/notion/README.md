# Notion MCP Setup for Claude Code

## Quick Setup

1. **Get Notion API Key**
   - Go to https://www.notion.so/my-integrations
   - Create new integration → copy the token (starts with `ntn_`)
   - Share pages with your integration (click "..." → Add Connections)

2. **Add to Claude Code**
   ```bash
   claude mcp add notion -s user \
     --env OPENAPI_MCP_HEADERS='{"Authorization": "Bearer YOUR_API_KEY", "Notion-Version": "2022-06-28"}' \
     -- npx -y @notionhq/notion-mcp-server
   ```
   Replace `YOUR_API_KEY` with your actual token.

3. **Test**
   - Restart Claude Code: `exit` then `claude`
   - Run `/mcp` - should show `notion: connected ✓`

## Troubleshooting

**"notion: failed" in `/mcp`**
- Most common issue: malformed JSON in command
- Solution: Remove and re-add with proper quotes
```bash
claude mcp remove notion -s user
# Then re-run the add command above
```

**No pages accessible**
- Make sure you shared specific Notion pages with your integration
- Go to page → "..." menu → Add Connections → select your integration

**API key issues**
- Test your key works:
```bash
curl -X GET 'https://api.notion.com/v1/users/me' \
  -H 'Authorization: Bearer YOUR_TOKEN' \
  -H 'Notion-Version: 2022-06-28'
```

## What You Can Do

Once connected, Claude can:
- Read Notion page content
- Search your workspace
- Access page properties and databases
- Summarize notes, extract action items, etc.

---

*[Official Notion MCP docs](https://developers.notion.com/docs/mcp)*