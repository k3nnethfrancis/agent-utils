---
name: log-research
description: Write and maintain research logs — durable records of experiments, sessions, and findings. Covers both internal experiment logs (what we ran, what happened) and published research logs (what we explored, what we learned). Use after experiments, evaluations, research sessions, or when synthesizing a day's work.
---

# Research Log

Turn experiment work and research sessions into durable, writeup-ready notes.

The goal is not to duplicate raw logs. The goal is to preserve the reasoning thread that will matter later when writing a report:
- what question the run was meant to answer
- what was actually run
- what happened
- what that means
- what should happen next

## Two Modes

### Internal Experiment Log

For `research-log.md` files within projects — structured records of specific experiments and runs.

### Published Research Log

For dated logs that synthesize across a day's work — what was explored, read, built, and learned.

## Workflow (Internal)

### 1. Read the Existing Context

Before editing a `research-log.md`, read the minimum project context needed to avoid drift:
- the current `research-log.md` if it exists
- the active task list
- the project ledger / handoff / plan docs relevant to the experiment

### 2. Decide Whether to Append or Start a New Entry

Append when:
- the work is part of the same experiment block
- the new run is a direct follow-up fix or rerun
- the interpretation has not materially changed

Start a new entry when:
- the experiment question changed
- a new milestone was reached
- the analysis moved from setup to interpretation

### 3. Log the Experiment at the Right Level

Log experiment blocks, not command-by-command chronology.

Prefer one entry per meaningful unit such as:
- an experiment battery
- a baseline slice
- a replication set
- a major fix exposed by a run

Do not copy long command output into the log. Link to artifacts instead.

### 4. Include the Writeup-Critical Fields

A good research-log entry usually contains:
- `Question` or `Why this run existed`
- `Setup` or `Conditions`
- `Artifacts`
- `Results`
- `Interpretation`
- `Confounds / Fixes`
- `Next`
- `Writeup Hooks`

Use the quality bar in [references/quality-bar.md](./references/quality-bar.md).

### 5. Distinguish Observation from Interpretation

Be explicit about the boundary:
- observation: scores, runtime, turn limit, exact artifact path
- interpretation: what the result suggests

If the interpretation is uncertain, say so.

### 6. Preserve Negative and Null Results

A good research log keeps:
- null results
- failed replications
- confounded runs
- instrument failures

These are often the most important ingredients in a later technical report.

### 7. Sync the Context System

After updating the research log, also update surrounding project context when appropriate:
- task list for priority shifts
- ledger for implementation progress
- handoff docs for next-session assumptions

## Published Log Format

```yaml
---
title: YYYY-MM-DD
date: YYYY-MM-DD
tags:
  - relevant-tags
  - research-log
---
# YYYY-MM-DD | Descriptive title

Content here.
```

### Structure

When a day has multiple distinct activities, organize by what happened:

1. **What we explored / built / reviewed** — Plain description of the work and approach
2. **What we read / processed** — Papers, threads with links
3. **What we're thinking about** — Synthesis, open questions, connections between pieces

Each section should stand alone.

### Style

**Plain documentation, not performance.** No hyperbole, no catchy framing, no "key insights" callouts.

**Notebook, not manifesto.** Observations, questions, findings. Not announcements about what you're going to do.

**Show, don't tell.** Lead by example rather than declaring intent.

**Include links.** Papers, threads, repos, tools — link them.

**Capture the full day's work.** Reflect the full scope, not just the current session.

### Good headers

- "Exploring X and Y"
- "Bookmark review"
- "Thoughts on multi-agent research tools"

### Bad headers

- "The Core Insight"
- "What This Means for the Arc"
- "Key Takeaways"

## Gotchas

_Empty — add failure modes here as they're discovered in real use._

### Tone

- First person plural ("we") for collaborative work
- Plain English, direct observations
- Questions are good
- Uncertainty is fine — don't oversell conclusions
