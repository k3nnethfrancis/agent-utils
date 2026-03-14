---
name: work-logging
description: Log work to daily notes with timestamps. Use proactively after completing tasks, reaching milestones, or finishing research sessions. High signal, no redundancy.
---

# Work Logging

Log work to daily notes with timestamps. High signal, no redundancy.

## When to Use (Proactive)

Trigger this skill when:
- Completing a task
- Finishing significant work
- Reaching a milestone in a project
- Completing a research session or investigation

Use judgment - not every tiny action, but meaningful work.

## Format

Log entries in daily note (`YYYY-MM-DD.md`):

```markdown
[HH:MM] Description of work #tags
	- Detail or sub-item
	- Another detail
```

Use `#tags` for categorization (e.g., `#project-setup`, `#research`, `#engineering`).
Use indented bullets for details when helpful.

Examples:
```markdown
[15:55] Created new simulations project #project-setup
	- Set up project structure in `projects/simulations/`
	- Created README.md with overview and goals

[16:12] Simplified to trace-based submission system #data-structure
	- Core insight: It's just a form submission with proof of execution
	- Standard event schema defined

[12:16] Finished vault reorganization #organization
	- New entities/ structure with agents/, humans/, orgs/
	- Created 3 new skills
	- 267 files moved
```

## Actions

### 1. Get Current Time

```bash
date "+%H:%M"
```

Never guess the time.

### 2. Ensure Daily Note Exists

Check for `YYYY-MM-DD.md` in your notes directory. Create if missing.

### 3. Append Log Entry

Add the log entry with timestamp, description, tags, and details.

## Principles

- **Timestamps required** - always use `date` command, never assume
- **High signal** - log meaningful work, not every edit
- **Descriptive** - what was done + relevant details
- **Tagged** - use #tags for filtering and lookup later

## Output

Brief confirmation: "Logged: [timestamp] [description]"
