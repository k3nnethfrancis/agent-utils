---
name: research-log
description: Write and maintain durable research-log.md files after experiments, evaluations, and research sessions. Captures hypotheses, setup, artifacts, results, interpretations, and next steps in a form that supports later technical reports.
---

# Research Log

Use this skill to turn experiment work into durable, writeup-ready notes.

The goal is not to duplicate raw logs. The goal is to preserve the reasoning thread that will matter later when writing a report:
- what question the run was meant to answer
- what was actually run
- what happened
- what that means
- what should happen next

## Workflow

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

The research log is the writeup-friendly layer, not the only layer.
