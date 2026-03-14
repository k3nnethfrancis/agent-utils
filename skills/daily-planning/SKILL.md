---
name: daily-planning
description: Plan the day or week by pulling context from all available sources — vault notes, meeting transcripts, task lists, bookmarks, and calendar. Use when the user says "plan my day", "what should I focus on", "weekly plan", or at session start when orientation is needed.
---

# Daily Planning

Pull context from all available sources to help the user orient and prioritize.

## When to Use

- Start of a work session ("what should I work on?")
- Explicit planning request ("plan my day", "plan my week")
- After a break or context switch when re-orientation is needed

## Context Gathering

Before proposing a plan, pull from every available source:

### 1. Task List
Read the active task list. What's in progress? What's blocked? What's due?

### 2. Recent Notes
Check recent daily notes (last 2-3 days) for momentum — what was the user working on? What threads are open?

### 3. Calendar / Meetings
If meeting transcripts are available (Granola, etc.), check:
- What meetings happened recently? Any action items?
- What meetings are coming up? Any prep needed?

### 4. Bookmarks / Reading Queue
Check if there's a triage queue or reading backlog that's accumulating.

### 5. Project State
For active projects, check progress ledgers or recent commits. What's close to done? What's stalled?

## Planning Output

Don't dump everything found. Synthesize into:

```markdown
## Today

**Focus:** [the one thing that matters most and why]

**Do:**
- [ ] Specific actionable item
- [ ] Another item
- [ ] Third item (3-5 max)

**Consider:**
- Thing that could wait but is worth noting

**Open threads:**
- Brief note on something in progress from yesterday
```

## Principles

- **One focus, not ten priorities** — if everything's a priority, nothing is
- **Pull, don't guess** — always check actual task lists and notes before suggesting
- **Name the trade-offs** — if suggesting X over Y, say why
- **Time-aware** — if it's 4pm, don't plan a full day
- **Respect existing commitments** — check for meetings, deadlines, promises before suggesting deep work blocks

## Weekly Planning

For weekly planning, add:
- Review of what shipped last week (from daily notes / git history)
- Identify the 2-3 things that would make the week a success
- Flag anything that's been deferred multiple times
