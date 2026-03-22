# Experiment: {name}

## Objective

Maximize `score` by modifying `{target_file}`.

`score` measures: {what the score means — one sentence connecting the metric to the question you're trying to answer}.

Current baseline: {X}

## What You CAN Modify

- `{target_file}` — {describe what's in it and what kinds of changes are fair game}

## What You CANNOT Modify

- `{eval_file}` — the evaluation function is fixed. Do not touch it.
- `{data_files}` — input data is fixed.
- This file (`program.md`) — your instructions don't change.

## The Loop

LOOP FOREVER:
1. Read the git log to understand what's been tried and what worked
2. Form a hypothesis about what change will improve `score`
3. Modify `{target_file}` — make ONE clear change per iteration
4. `git add {target_file} && git commit -m "experiment: {describe change}"`
5. Run: `{run_command}` (must complete within {time_budget})
6. Read the output. Find `score: {value}`
7. If score improved: keep the commit, record in results.tsv
8. If score did NOT improve: `git revert HEAD --no-edit`
9. NEVER STOP. There is always something else to try.

## Constraints

- Time budget per run: {time_budget} (e.g., 5 minutes)
- Every run must produce a `score:` line in output
- Simpler changes are better than complex ones
- If a direction isn't working after 3 attempts, try something fundamentally different
- Record every experiment (kept or reverted) in `results.tsv`:
  `{timestamp}\t{description}\t{score}\t{kept|reverted}`

## Research Context

{2-3 sentences about WHY this experiment matters — what question you're trying to answer, what you expect to find, what would be surprising. This gives the agent enough context to make informed hypotheses rather than random walks.}

## Ideas to Explore

{Seed the agent with 3-5 initial directions. These should be genuine hypotheses, not exhaustive — the agent will discover its own directions as it goes.}

- {Direction 1}
- {Direction 2}
- {Direction 3}
