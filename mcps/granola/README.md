# Granola MCP Setup for Claude Code

[Granola](https://granola.ai) records and transcribes meetings. Their official MCP server gives Claude access to your meeting notes.

## What the User Needs

- A Granola account with existing meeting notes
- Free plan: only last 30 days of notes accessible
- Paid plan: full history + transcript access

## Install

```bash
claude mcp add granola --transport http https://mcp.granola.ai/mcp
```

## Authenticate

1. Restart Claude Code (open new terminal, run `claude`)
2. Run `/mcp`, select `granola`, select **Authenticate**
3. Complete the browser OAuth flow
4. Done — ask Claude to reference your meetings

## What You Get

Once connected, Claude can:
- Search meeting notes by date, topic, or participant
- Pull action items and decisions from meetings
- Use meeting context when writing code, tickets, or docs

## Limits

- OAuth only (no API key method)
- ~100 requests/minute rate limit
- You can only access notes where you're the owner

---

*[Granola MCP docs](https://docs.granola.ai/help-center/sharing/integrations/mcp)*
