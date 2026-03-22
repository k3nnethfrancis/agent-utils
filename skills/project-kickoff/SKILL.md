---
name: project-kickoff
description: Create a new project with consistent structure and documentation. Use when the user says "new project" or "start a project" or when building something new. Sets up for agent-assisted development from day one.
---

# Project Kickoff

Create a new project with consistent structure, smart dependency choices, and agent-efficient documentation. The goal is a project that's ready for agent-assisted development from the first commit.

## When to Use

When the user says "new project" or "start a project" or you agree to build something new.

## Inputs Required

1. **Project name** (kebab-case)
2. **One-line description**
3. **Key resources** (links, references, related files)
4. **Method/approach** (what we're building and how)

## Step 1: Language & Dependency Decisions

Before writing code, decide:

**Language selection based on agent proficiency:**
- **TypeScript** — web apps, APIs, tooling
- **Go** — CLI tools (agents excel at Go's simple type system)
- **Swift** — macOS/iOS native UI
- **Python** — ML, data processing, scripts, research

**Dependency selection:**
- Prioritize packages with strong community adoption (more training data = better agent output)
- Verify maintenance status, peer dependencies, popularity before adding
- Boring technology wins — agents know React better than your custom framework

## Step 2: Create Project Structure

```
projects/{project-name}/
├── CLAUDE.md              # Agent entry point — map + read order
├── README.md              # Human-facing: status, quick start, what this is
├── ledger.md              # Session handoff — what happened, what's next
├── docs/
│   ├── plan.md            # Implementation plan — goals, phases, decisions
│   ├── tasks.md           # Current task list (when needed)
│   ├── resources.md       # Links, references, data sources
│   └── architecture.md    # System design (when needed)
└── src/                   # Source code
```

Add as needed: `scripts/`, `tests/`, `data/`, `outputs/`, `configs/`

### What Each File Does

**`CLAUDE.md`** — The agent's entry point. Establishes the read order, project rules, key files, and related paths. This is the map, not the encyclopedia. Keep under 100 lines.

**`ledger.md`** — The fastest handoff file. An agent starting a new session reads this first to know: what was done recently, what's blocked, what's next. Append-only — new entries go at the top, old entries stay. This is operational, not analytical.

**`docs/plan.md`** — The implementation plan. What we're building, why, in what order. Decisions made and their rationale. Updated as the plan evolves — living document, not a spec.

**`docs/tasks.md`** — Current task list when the project needs one. Not every project does — small projects can track tasks in the ledger.

**`docs/resources.md`** — All reference links (papers, tools, APIs, related projects). Everything an agent needs to find context without asking.

**`docs/architecture.md`** — System design, module boundaries, data flow. Create when the project has enough moving parts. Not every project needs one.

**`README.md`** — Status checklist, quick start commands, what this project is. The human-facing overview.

### What About Research Logs?

For research-heavy projects, add a separate `research-log.md` for experiment tracking (questions, conditions, results, interpretations). This is different from the ledger:

- **Ledger** = operational. "What happened. What's next." Read at session start.
- **Research log** = analytical. "What experiment. What result. What it means." Read when writing up findings.

Not every project needs a research log. Engineering projects usually don't. Research projects benefit from having both.

## Step 3: Write CLAUDE.md

Include a **read order** at the top — this is the most important thing. Then project rules and key files.

```markdown
# {Project Name}

{One-line description}

## Read Order

1. `ledger.md`
2. `docs/plan.md`
3. `docs/tasks.md` (if it exists)
4. `docs/resources.md`

## Project Rules

- {Language/framework choices and why}
- {Key conventions or constraints}

## Key Files

- `src/...` — {description}
- `docs/plan.md` — implementation plan
- `docs/resources.md` — reference links
```

Structure as a map with pointers to `docs/` for detail. Keep under 100 lines.

## Step 4: Write ledger.md

Start with the project thesis and current focus:

```markdown
# {Project Name} Ledger

Last updated: {date}

This is the fastest handoff file for {project-name}.

## Product Thesis

{2-3 sentences: what this is and why it exists}

## Current Focus

{What phase we're in, what the immediate priorities are}

## Recent Progress

### {date} — {title}

- What was done
- What's blocked
- What's next
```

## Step 5: Write docs/plan.md

Include:
- **Goal** — what success looks like
- **Approach** — how we're getting there
- **Phases** — ordered steps with clear boundaries
- **Decisions** — choices made and why (the most valuable part)
- **Open questions** — what we don't know yet

This is the document that gets updated most. When the plan changes, update it here.

## Step 6: Write docs/resources.md

Include:
- All reference links (methodology, papers, tools, APIs)
- Data sources (if applicable)
- Related project paths
- Anything an agent would need to look up

## Step 7: Write README.md

Include:
- One-line description
- Status checklist (what's done, what's next)
- Quick start commands
- Link to docs/ for detail

## Context Lifecycle

Kickoff creates the context system. **`evolve-context`** maintains it.

```
project-kickoff → build → milestone → evolve-context → build → milestone → ...
```

After kickoff, use `evolve-context` when:
- A phase completes or the plan changes
- CLAUDE.md or ledger.md feels stale
- Before a handoff or after a long gap

The context files created here are designed to be evolved, not written once.

## Principles

- **Ledger first** — the fastest handoff beats the most complete documentation
- **CLI first** — validate core logic before adding UI/extensions
- **Agent-efficient structure** — organize for model navigation, not human browsing
- **Map, not encyclopedia** — CLAUDE.md points to docs/, docs/ points to code
- **Boring technology** — popular frameworks = better agent output
- **Plan is living** — update docs/plan.md as decisions are made, not after
- **Iterative** — build the simplest version first, expand from working state

## Output

Return to conversation with:
- Paths created
- Language/dependency decisions made
- Plan outline (from docs/plan.md)
- Status: ready to start work
- Reminder: use `evolve-context` to maintain these files as the project progresses
