# Linear MCP Setup for Claude Code

## Quick Setup

1. **Get Linear API Key**
   - Go to Settings > API > Personal API keys
   - Create a new key, copy it

2. **Add to Claude Code**
   ```bash
   claude mcp add linear -s user \
     --env LINEAR_API_KEY='YOUR_API_KEY' \
     -- npx -y @anthropic/linear-mcp-server
   ```
   Replace `YOUR_API_KEY` with your actual token.

3. **Test**
   - Restart Claude Code: `exit` then `claude`
   - Run `/mcp` - should show `linear: connected`

## What You Can Do

Once connected, Claude can:
- Search issues and projects
- Create and update issues
- Read project status and roadmaps
- Manage labels, assignees, and priorities

---

*[Linear API docs](https://developers.linear.app/docs)*
