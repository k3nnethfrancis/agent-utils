---
name: evolve-context
description: Update project context files when reality has drifted from docs. Use when a milestone is hit, the plan has changed, CLAUDE.md feels stale, or the user says "update the docs", "sync context", "evolve context". Walks through plan.md, CLAUDE.md, progress ledger, README, and architecture docs.
---

# Evolve Context

Sync project documentation with current reality. Context files drift — plans change, features ship, decisions get made in conversation but never written down. This skill walks through each context file and updates it.

## When to Use

- After hitting a milestone or shipping a phase
- When the plan has changed but docs haven't
- When CLAUDE.md feels stale (key files list is wrong, conventions have shifted)
- When starting a session and context feels off
- User says "update the docs", "sync context", "evolve context"
- Before a handoff to another agent or collaborator

## The Context System

Projects maintain these context files (created by `project-kickoff`):

```
project/
├── CLAUDE.md           # Agent entry point — map of the project
├── README.md           # Human-facing overview and status
├── docs/
│   ├── plan.md         # Living implementation plan
│   ├── resources.md    # Reference links and data sources
│   └── architecture.md # System design (when applicable)
└── research-log.md     # Experiment tracking (when applicable)
```

If a vault/notes directory exists for the project, it also has:
```
vault/projects/{project-name}/
├── progress-ledger.md  # Chronological implementation log
└── research-log.md     # Research narrative (when applicable)
```

## Process

### 1. Read Current State

Read all context files that exist. Don't assume — check what's actually there.

Also check:
- Recent git log (what actually shipped since docs were last updated)
- Current file tree (has the structure changed?)
- Any in-session decisions that haven't been captured

### 2. Identify Drift

For each file, ask: **does this still reflect reality?**

| File | Drift signals |
|------|--------------|
| `CLAUDE.md` | Key files list is wrong, new conventions not captured, related paths changed, project description outdated |
| `docs/plan.md` | Phases completed but not marked, new phases emerged, decisions made but not recorded, open questions resolved |
| `docs/architecture.md` | New modules added, data flow changed, boundaries shifted |
| `docs/resources.md` | New dependencies, new reference links discovered during work |
| `README.md` | Status checklist outdated, quick start commands changed |
| `progress-ledger.md` | Last entry is stale, recent work not logged |
| `research-log.md` | Experiments run but not recorded |

### 3. Update Each File

Work through files in this order:

1. **`docs/plan.md`** first — this is the source of truth for direction
   - Mark completed phases
   - Add new phases that emerged
   - Record decisions made since last update (with rationale)
   - Update open questions (close resolved, add new)
   - If the goal itself has shifted, update that too

2. **`CLAUDE.md`** second — the map must match the territory
   - Update key files list (new files, removed files, renamed files)
   - Update conventions if they've changed
   - Update related paths if project relationships shifted
   - Keep it under 100 lines — if it's growing, move detail to docs/

3. **`docs/architecture.md`** — if it exists and structure changed
   - Update module boundaries
   - Update data flow diagrams
   - Add new components

4. **`docs/resources.md`** — add anything discovered during work
   - New libraries, APIs, papers referenced
   - New related projects

5. **`README.md`** — update status and quick start
   - Check off completed items
   - Add new status items
   - Verify quick start commands still work

6. **`progress-ledger.md`** — append recent progress
   - What was done since last entry
   - What's blocked
   - What's next

### 4. Report Changes

Summarize what was updated and why. Flag anything that needs a decision (e.g., "plan.md says we're in Phase 2 but the code looks like Phase 3 — should I update?").

## Principles

- **Match reality, don't aspirate** — update docs to reflect what IS, not what you wish were true
- **Decisions are the most valuable thing to capture** — the "why" behind choices is what future sessions need most
- **Don't bloat** — if a file is growing past its purpose, split or trim
- **CLAUDE.md is a map** — it points to docs/, not replaces them
- **Ledger is append-only** — don't edit old entries, add new ones
- **Plan changes are normal** — updating the plan isn't failure, it's learning

## Gotchas

_Empty — add failure modes here as they're discovered in real use._

## Output

Brief summary:
- Files updated (with one-line description of what changed in each)
- Decisions captured
- Open questions added or resolved
- Anything that needs user input
