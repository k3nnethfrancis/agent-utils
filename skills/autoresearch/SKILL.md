---
name: autoresearch
description: Turn any question into an automated feedback loop. The pattern — design a sensor (eval), an actuator (code the agent modifies), and launch an evolutionary optimization loop. Works on any (code → run → score) problem — model training, software optimization, prompt tuning, eval design, data pipelines, agent harnesses. The eval function IS the research.
---

# Autoresearch

Turn any question into an automated experiment loop. Works on anything with a score.

## The Pattern

```
/autoresearch <question>
```

1. **Distill** the question into three things: a **target file** (what the agent modifies), an **eval** (what produces the score), and a **run command** (how to execute)
2. **Design the eval** — the function that measures progress toward answering the question. This is the hard part and the real contribution.
3. **Write the target file** — the code, config, prompt, or pipeline the agent will iterate on
4. **Adapt `program.md`** — copy from `references/program.md`, fill in the blanks for this specific problem
5. **Launch** — fire up the loop in tmux, let it compound overnight
6. **Analyze** — interpret results, evolve the experiment if needed

## The Core Idea

Any optimization problem can be reduced to:

> "If I change X and measure Y, what happens?"

X is the **actuator** — the file the agent modifies. Y is the **sensor** — the eval that produces a score. The agent's job is to search the space of X mutations that improve Y.

**The eval function IS the research.** Once you have a good eval, optimization is mechanical. The hard intellectual work is figuring out what to measure and what to let the agent change.

This works for ML training (Karpathy's original use case), but equally for:
- **Prompt optimization** — target: prompt text, eval: accuracy on test cases
- **Config tuning** — target: TOML/YAML config, eval: benchmark score
- **Pipeline optimization** — target: processing code, eval: throughput or quality metric
- **Agent harness design** — target: system prompt or constraints, eval: task completion rate
- **Eval design itself** — target: rubric/scoring code, eval: correlation with human judgments

## How It Works

### Step 1: Question -> Actuator + Sensor

Take the question and identify:
- **What can be changed?** (the actuator / target file)
- **What can be measured?** (the sensor / eval function)
- **What's the run command?** (how to execute one iteration)

Examples:

| Question | Target file | Eval | Run command |
|----------|-------------|------|-------------|
| "Which RL hyperparams work best?" | `train.toml` | eval_score (pass@1) | `python run.py` |
| "Can I make this prompt more accurate?" | `prompt.txt` | accuracy on test set | `python eval.py` |
| "How fast can this TUI render?" | `src/renderer.rs` | frames per second | `cargo run --release -- --bench` |
| "Does this system prompt reduce hallucinations?" | `system.md` | factuality score | `python judge.py` |
| "What training data mix works best?" | `data_config.yaml` | val_bpb | `python train.py` |

The question doesn't need to be fully answered in one loop. It needs to produce **signal** — a measurement that moves in an interpretable direction.

### Step 2: Build the Eval

The eval must:
- Produce a **single scalar** — printed as `score: {value}` in stdout
- Be **interpretable** — higher/lower maps to a meaningful outcome
- Be **separate from the target** — the agent can't modify what measures it
- Be **fast** — runs in seconds, not minutes

The eval can be anything: a Python script, a shell pipeline, a test suite, a judge call. It just needs to produce `score:` on stdout.

### Step 3: Set Up the Project

```
{project-dir}/
  {target_file}    # what the agent modifies (train.py, config.toml, prompt.txt, etc.)
  {eval_file}      # the scoring function (frozen — agent cannot touch)
  program.md       # agent instructions (copied from references/program.md and adapted)
  results.tsv      # experiment history (agent maintains)
```

The key constraint: **the agent modifies exactly one file.** Everything else is frozen. This prevents the agent from gaming the eval, and makes every experiment a clean diff.

### Step 4: Adapt program.md

Copy `references/program.md` and fill in the blanks:

1. **Name and objective** — what are we optimizing and why
2. **Target file** — what the agent can change
3. **Frozen files** — what it can't touch (eval, data, this file)
4. **Run command** — how to execute one iteration
5. **Time budget** — how long each run gets
6. **Research context** — why this matters (gives the agent informed hypotheses)
7. **Seed ideas** — 3-5 initial directions to explore

The program.md is the human's control surface. You iterate on it between sessions — tightening constraints, adding seed ideas, refining the objective. The agent iterates on the target file. Two loops, two files.

### Step 5: Launch

```bash
cd {project-dir}
tmux new-session -d -s autoresearch \
  "claude --dangerously-skip-permissions -p 'Read program.md and start. Baseline score is {X}.'"
```

Monitor: `tmux attach -t autoresearch`
Check results: `cat results.tsv`
Kill: `tmux kill-session -t autoresearch`

Any coding agent with filesystem access works (Claude Code, Codex CLI, OpenCode, etc.). The key is `--dangerously-skip-permissions` or equivalent so it can edit and run without human approval.

### Step 6: Analyze and Evolve

After a batch of experiments:
- Read `results.tsv` — what patterns emerge?
- Read git log — what changes helped/hurt?
- **Evolve the experiment** — maybe the eval needs refinement, the target file needs restructuring, or the question has shifted based on what you learned
- Update `program.md` with new seed ideas and relaunch

This is the compounding part. Each cycle doesn't just improve a score — it improves understanding of the question, which improves experiment design, which produces better signal.

## Practical Notes

### Time Budget
5 minutes per iteration is a good default. Short enough for ~12 experiments/hour, long enough for most evals to produce signal. Adjust based on your problem — prompt optimization might need 30 seconds, model training might need 10 minutes.

### Git as Memory
The agent commits before each run, reverts on failure. This means:
- `git log` is the experiment history — every hypothesis, kept or not
- `git diff` between any two commits shows exactly what changed
- `results.tsv` is the structured summary, git is the full record
- Branch per experiment series: `autoresearch/{tag}`

### When the Agent Gets Stuck
If score plateaus after 10+ experiments, the agent needs new seed ideas. Update `program.md` with fresh directions based on what you've learned from the results so far. This is the human-in-the-loop moment — not babysitting, but steering.

### ML-Specific Notes
For model training experiments (the original Karpathy use case):
- ~10-50M params practical on consumer hardware
- nanoGPT variants are a good default architecture
- Works on MPS (Apple Silicon) and CUDA
- No torch.compile on MPS; optional on CUDA
- BPE tokenizer with small vocab (4K-16K) keeps things fast

## Gotchas

_Add failure modes here as they're discovered in real use._

## File Structure

```
autoresearch/
├── SKILL.md                    # This file — how to set up and run the loop
└── references/
    └── program.md              # The program.md — copy and adapt per problem
```

## When to Use

- Any problem with a (change → run → score) loop
- You want to explore a design space systematically without babysitting
- The iteration cycle is fast enough for dozens of experiments overnight
- You want an agent to find things you wouldn't think to try

## When NOT to Use

- No clear score — if you can't define what "better" means numerically, fix that first
- Score requires human judgment at every step (use the loop to generate candidates, then judge manually)
- The iteration cycle is too slow (>30 min per run means ~2 experiments/hour — not enough for the pattern to work)
