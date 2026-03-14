---
name: plan-interview
description: Stress-test a plan through structured questioning. Use when the user says "interview me about", "stress test this", "let's think through X", or when a plan needs interrogation before committing.
---

# Plan Interview

Refine plans through structured questioning. One question at a time, going deep on uncertainty and untested assumptions. The goal is clarity before commitment.

## When to Use

When the user:
- Has a rough idea that needs pressure-testing
- Wants to think through a plan before building
- Says "interview me about X" or "stress test this"
- Is about to start something significant

NOT for: trivial tasks, pure research/exploration, or when the path is already clear.

## Interview Structure

Ask **one question at a time**. Go deep on answers that reveal uncertainty or assumptions. Don't ask obvious questions - push on things not fully thought through.

### 1. Systems & Implementation

- What's the core mechanism? How does it actually work?
- Where does complexity live? What are the moving parts?
- How does this fit with existing systems?
- What are the feedback loops? How do you know if it's working?
- What could break? What dependencies exist?

### 2. Human Impact

- Who else is affected by this?
- What does success look like? How will you measure it?
- What's the failure mode? What's the manual fallback?
- Does this increase or decrease your control/understanding?

### 3. Direction & Priority

- Why now? What's the cost of waiting?
- What's the simplest version that delivers value?
- What would make you regret building this?
- How does this connect to your larger goals?

## Interview Style

- **One question at a time** - let answers breathe
- **Go deep on uncertainty** - follow threads that reveal untested assumptions
- **Capture quotable moments** - off-the-cuff explanations often beat formal requirements
- **Challenge fuzzy thinking** - if something sounds good but isn't precise, push on it
- **Before finishing, ask**: "What did I forget to ask about?"

## Closing

When the interview feels complete:

1. Summarize key decisions made
2. List open questions or risks identified
3. Propose next action (often: should this become a project?)

## Output

Write refined spec:

```markdown
# {Plan Name}

## Context
Why this exists, what problem it solves.

## Core Mechanism
How it actually works.

## Key Decisions
- Decision 1: rationale
- Decision 2: rationale

## Open Questions
- Question 1
- Question 2

## Simplest Valuable Version
What we'd build first.

---

*Interviewed: YYYY-MM-DD*
```

## Principles

- **Clarity over speed** - better to think now than build wrong
- **Capture the thinking** - the interview is as valuable as the output
- **Honest pressure** - the point is to find holes, not validate
