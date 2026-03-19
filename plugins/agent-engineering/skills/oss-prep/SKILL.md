---
name: oss-prep
description: Prepare a project for open source release. Use when the user says "prep for oss", "prepare for open source", or similar. Scans, discusses, and transforms projects for public sharing.
---

# OSS Prep

Prepare a personal project for public release. This is a collaborative process—scan first, discuss options, then transform.

## When to Use

When the user says:
- "prep this for oss"
- "prepare for open source"
- "let's make this shareable"
- "get this ready for github"

## Principles

Optimizing for:
- **Accessibility** - others can understand and use it quickly
- **Shareability** - no personal/private dependencies
- **Interoperability** - works with other tools, agents, workflows

Design philosophy:
- **CLI-first** - core functionality callable from command line
- **Agent-usable** - clear interfaces for AI tools to invoke
- **Markdown-driven** - documentation matches how models are trained

## Workflow

### Step 1: Create Branch

```bash
git checkout -b oss-prep
```

All changes happen on this branch for review before merging.

### Step 2: Scan and Report

Scan the project for items that need attention:

**Personal identifiers:**
- Hardcoded paths (`/Users/...`)
- Name references (replace with "the user" or dynamic)
- Private repo/vault references
- Personal API keys or credentials (should be env vars)

**Project structure:**
- Is there a clear entry point?
- Is CLI interface exposed?
- Are dependencies documented?
- Is installation straightforward?

**Documentation:**
- README: Is it user-facing or internal planning?
- CLAUDE.md: Does it assume specific user context?
- Are setup instructions complete for a new user?

**Agent-usability:**
- Could this be an MCP server?
- Could this be a Claude Code plugin/skill?
- Are tool interfaces well-defined?
- Is output parseable/structured?

### Step 3: Discuss

Present findings and discuss:
- What's the intended audience? (developers, agents, both)
- Which distribution format makes sense? (standalone CLI, MCP, plugin, library)
- Are there features to cut vs. generalize?
- Any private functionality that should stay separate?

### Step 4: Transform

Based on discussion, make changes:

**Path generalization:**
```python
# Before
path = "/Users/someone/Desktop/project"

# After
path = os.path.expanduser("~/project")
# or
path = os.environ.get("PROJECT_PATH", os.path.expanduser("~/project"))
```

**README transformation:**
- Focus on: What it does, how to install, how to use
- Remove: Internal planning, personal context
- Add: Examples, common use cases

### Step 5: Consider Distribution Format

**Standalone CLI:**
- Entry point script or binary
- Clear --help documentation
- Installable via standard methods

**MCP Server:**
- Exposes tools via MCP protocol
- Can be added to Claude Code or other MCP clients

**Claude Code Plugin:**
- Skills directory with SKILL.md
- Plugin-ready structure

**Library/Package:**
- Importable module
- Published to package registry

### Step 6: Review Diff

```bash
git diff main
```

Walk through changes together before committing.

### Step 7: Commit and Decide

If approved, commit. Then discuss: merge to main, or keep branch for further iteration?

## What NOT to Change

- License/authorship metadata (keep attribution)
- Git history (don't rewrite)
- Core functionality (only generalize interfaces)

## Gotchas

_Empty — add failure modes here as they're discovered in real use._

## Output

After completing, summarize:
- Changes made
- Distribution format chosen (if decided)
- Remaining items to address
- Ready to merge or needs iteration
