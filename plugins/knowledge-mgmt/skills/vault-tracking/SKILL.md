---
name: vault-tracking
description: Commit notes and vault changes to git when substantial. Use proactively after significant work in a markdown vault (Obsidian or any markdown directory) — structural changes, new notes, reorganization. Think like merging a PR - meaningful bundles.
---

# Vault Tracking

Commit notes and vault changes to git when substantial. Works with Obsidian vaults, markdown directories, or any git-tracked notes collection. Think like merging a PR - meaningful bundles of work.

## When to Use (Proactive)

Trigger this skill when:
- Adding multiple new files
- Making structural changes (moving folders, reorganizing)
- Completing major content updates
- After a significant work session
- Before switching to a different major task

Use judgment - not every tiny edit, but when you'd want a checkpoint.

## Criteria for Committing

**Commit when:**
- Multiple files changed as part of coherent work
- Folder structure modified
- Major document created or significantly revised
- End of focused work session
- Good stopping point before context switch

**Don't commit:**
- Single typo fixes in isolation
- Work still in messy progress
- Nothing meaningful to describe

## Actions

### 1. Check Status

```bash
git status
```

Review what's changed. Understand the scope.

### 2. Stage Changes

```bash
git add -A
```

Or selectively stage if there's unrelated work mixed in.

### 3. Write Commit Message

Format:
```
Brief summary of changes (imperative mood)

- Detail 1
- Detail 2
```

Think PR title + description. What did this bundle of work accomplish?

### 4. Commit

```bash
git commit -m "message"
```

## Gotchas

_Empty — add failure modes here as they're discovered in real use._

## Principles

- **Meaningful bundles** - think like a PR, not individual edits
- **Descriptive messages** - future you should understand the "why"
- **Regular rhythm** - don't let uncommitted work pile up too long
- **No push without ask** - commit locally, push only when requested

## Output

Brief confirmation: "Committed: [summary] ([n] files)"
