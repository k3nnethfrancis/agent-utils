# Research Log Quality Bar

Use this as the default standard for `research-log.md` entries.

## What a Good Research Log Captures

A good research log should let a later writer answer:
- what question was being tested?
- what exact run or slice was used?
- what happened?
- what changed in the system because of it?
- what should be done next?

It should support later writing without requiring full transcript archaeology.

## Recommended Entry Shape

```md
## YYYY-MM-DD — Short Experiment Title

Question
- What was this run meant to answer?

Setup
- Key conditions, models, tasks, seeds, or config files

Artifacts
- Summary JSONs
- Experiment IDs
- Analysis outputs
- Important transcripts

Results
- The concrete outcomes
- Keep this factual

Interpretation
- What the results suggest
- Distinguish inference from observation

Confounds / Fixes
- What was broken, ambiguous, or changed because of the run

Next
- The immediate next experiment or decision

Writeup Hooks
- 1-3 sentences that a future technical report could reuse
```

## Quality Rules

- Prefer experiment blocks over command history.
- Prefer concrete artifact paths over pasted logs.
- Record null results and failed runs, not just wins.
- Capture what changed in the measurement stack when relevant.
- Keep entries concise but specific enough to support later synthesis.
- If a result is still provisional, mark it as provisional.

## Anti-Patterns

Avoid:
- dumping raw terminal output
- writing only vibes with no artifacts
- writing only artifacts with no interpretation
- silently rewriting history after later reruns
- mixing multiple unrelated experiments into one vague entry
