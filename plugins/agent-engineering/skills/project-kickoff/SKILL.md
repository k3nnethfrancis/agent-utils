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
├── CLAUDE.md              # Project-specific agent instructions
├── README.md              # Status, quick start, what this is
├── docs/
│   ├── plan.md            # Implementation plan — goals, phases, decisions
│   ├── resources.md       # Links, references, data sources
│   └── architecture.md    # System design (when needed)
├── research-log.md        # Experiment tracking (when applicable)
└── src/                   # Source code
```

Add as needed: `scripts/`, `tests/`, `data/`, `outputs/`, `configs/`

### What Each File Does

**`CLAUDE.md`** — The agent's entry point. Quick context, language/framework choices, key files, related paths. This is the map, not the encyclopedia.

**`docs/plan.md`** — The implementation plan. What we're building, why, in what order. Decisions made and their rationale. Updated as the plan evolves — this is a living document, not a spec that gets written once.

**`docs/resources.md`** — All reference links (papers, tools, APIs, related projects). Everything an agent needs to find context without asking.

**`docs/architecture.md`** — System design, module boundaries, data flow. Create this when the project has enough moving parts to need one. Not every project does.

**`research-log.md`** — Chronological log of experiments, findings, and decisions. What was tried, what happened, what it means, what's next. Critical for research projects; optional for pure engineering.

**`README.md`** — Status checklist, quick start commands, what this project is. The human-facing overview.

## Step 3: Write CLAUDE.md

Include:
- Quick context (1-2 sentences: what this is and why it exists)
- Language/framework choices and why
- Key files list with one-line descriptions
- Related paths and connected projects
- Any project-specific conventions or constraints

Structure as a map with pointers to `docs/` for detail. Keep under 100 lines.

## Step 4: Write docs/plan.md

Include:
- **Goal** — what success looks like
- **Approach** — how we're getting there
- **Phases** — ordered steps with clear boundaries
- **Decisions** — choices made and why (these are the most valuable part)
- **Open questions** — what we don't know yet

This is the document that gets updated most. When the plan changes, update it here — don't let the plan drift from the docs.

## Step 5: Write docs/resources.md

Include:
- All reference links (methodology, papers, tools, APIs)
- Data sources (if applicable)
- Related project paths
- Anything an agent would need to look up

## Step 6: Write README.md

Include:
- One-line description
- Status checklist (what's done, what's next)
- Quick start commands
- Link to docs/ for detail

## Context Lifecycle

Kickoff creates the context system. **`evolve-context`** maintains it.

```
project-kickoff → build → milestone → evolve-context → build → milestone → evolve-context → ...
```

After kickoff, use `evolve-context` when:
- A phase completes or the plan changes
- CLAUDE.md feels stale
- Before a handoff or after a long gap
- The user says "update the docs" or "sync context"

The context files created here are designed to be evolved, not written once. The plan will change. The key files list will grow. The architecture will shift. That's normal — the system handles it.

## Gotchas

_Empty — add failure modes here as they're discovered in real use._

## Principles

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
