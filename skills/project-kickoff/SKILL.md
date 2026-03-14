---
name: project-kickoff
description: Create a new project with consistent structure and documentation. Use when the user says "new project" or "start a project" or when building something new.
---

# Project Kickoff

Create a new project with consistent structure, smart dependency choices, and agent-efficient documentation.

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
- **TypeScript** - web apps, APIs
- **Go** - CLI tools (agents excel at Go's simple type system)
- **Swift** - macOS/iOS native UI
- **Python** - ML, data processing, scripts

**Dependency selection:**
- Prioritize packages with strong community adoption (more training data for agents)
- Verify maintenance status, peer dependencies, popularity before adding
- Popular frameworks = models have better contextual knowledge

## Step 2: Create Project Structure

```
projects/{project-name}/
├── CLAUDE.md           # Project-specific instructions
├── README.md           # Status checklist, quick start
├── docs/
│   └── resources.md    # Links and references
├── scripts/            # Processing/build scripts
└── outputs/            # Generated artifacts
```

Add as needed: `data/`, `src/`, `tests/`

**Key principle:** Design for agent efficiency, not human navigation. Markdown-driven - models work efficiently with this format.

## Step 3: Write CLAUDE.md

Include:
- Quick context (1-2 sentences)
- Language/framework choices and why
- Key files list
- Related paths and connected projects

## Step 4: Write README.md

Include:
- Status checklist (what's done, what's next)
- Quick start commands (CLI first - validate core logic before UI)
- Link to docs/resources.md

## Step 5: Write docs/resources.md

Include:
- All reference links (methodology, papers, tools)
- Data sources (if applicable)
- Related project paths

## Principles

- **CLI first** - validate core logic before adding UI/extensions
- **Agent-efficient structure** - organize for model navigation
- **Markdown-driven** - docs as primary communication
- **Iterative exploration** - build, play, refine

## Output

Return to conversation with:
- Paths created
- Language/dependency decisions made
- Status: ready to start work
