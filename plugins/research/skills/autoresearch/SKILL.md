---
name: autoresearch
description: Turn any research question into an automated experiment loop on small models. The pattern — distill question, design eval, write train.py, write program.md, launch autonomous loop, analyze. The eval function IS the research.
---

# Autoresearch

Turn any research question into an automated experiment on small, fast-training models.

## The Pattern

```
/autoresearch <question>
```

1. **Distill** the question into the minimum viable experiment trainable on a small model (~10-50M params) in minutes
2. **Design the eval** — the function that measures progress toward answering the question. This is the hard part and the real contribution.
3. **Write train.py** — configure the model, training loop, and eval to produce a single score
4. **Write program.md** — instructions for the autonomous agent to optimize that score
5. **Launch** — fire up the loop in tmux, let it compound overnight
6. **Analyze** — interpret results, evolve the experiment if needed

## The Core Idea

Every AI research question can be reduced to:

> "If I train a small model under condition X and measure property Y, what happens?"

The trick is finding the right X and Y. The model is just a lab rat. The eval function is the microscope. The agent's job is to design the experiment — pick the right X, build the right Y, and interpret what the results mean.

**The eval function IS the research.** Once you have a good eval, optimization is mechanical. The hard intellectual work is figuring out what to measure and how to measure it at small scale.

## How It Works

### Step 1: Question -> Minimum Viable Experiment

Take the research question and ask: what is the **simplest** version of this that a small model trained for 5 minutes could tell us something about?

Examples:
- "Does filtering specific content from training data change model behavior?"
  -> Train model A on filtered data, model B on unfiltered. Compare log-probs on targeted probes. Eval = selective divergence.

- "Do models learn syntactic structure before semantic meaning?"
  -> Train one model, checkpoint at intervals. Probe for syntax (agreement) vs semantics (entailment) at each point. Eval = syntax_score - semantic_score over training.

- "Does model depth or width matter more for few-shot learning?"
  -> Train deep-narrow vs shallow-wide models on same data. Eval on in-context learning probes. Eval = few_shot_accuracy.

- "Can you detect memorization vs generalization from internal representations?"
  -> Train on data with known duplicates. Compare loss on seen vs unseen text. Eval = memorization_ratio.

The question doesn't need to be fully answered at this scale. It needs to produce **signal** — a measurement that moves in an interpretable direction.

### Step 2: Build the Eval

The eval function goes at the end of `train.py`. It must:
- Produce a **single scalar** that the autonomous loop can optimize
- Be **interpretable** — higher/lower must map to a meaningful research outcome
- Include **controls** — so we know the signal is real, not noise
- Be **cheap** — runs in seconds after training, not minutes

The eval is printed in grep-able format:
```
---
score:            0.045678
<other metrics>
```

### Step 3: Configure train.py

Set up a project directory with:

- **`train.py`** — Model + training loop + eval. This is what the autonomous loop modifies.
- **`prepare.py`** — Data loading and tokenizer. Provides `make_dataloader(...)` and `evaluate_bpb(...)`.
- **`probes.py`** (optional) — Behavioral probe texts if the eval involves targeted generation or classification.
- **`program.md`** — Agent instructions for the autonomous loop.

Model architecture: any small trainable model works. nanoGPT variants (GPT-2 style) are a good default:
- Configurable depth, width, head dim
- Standard optimizer (AdamW, or Muon for matrix params)
- RoPE, RMSNorm, sliding window attention optional
- ~10-50M params practical on consumer GPUs
- Works on MPS (Apple Silicon) — no torch.compile needed. Also works on CUDA.
- No torch.compile on MPS; on CUDA, optional

Data: any tokenized text dataset. BPE tokenizer with small vocab (4K-16K) keeps things fast. Prepare a few shards of training data and a validation shard.

### Step 4: Write program.md

The `program.md` tells the autonomous agent what to optimize. Template:

```markdown
# Experiment: [name]

## Objective
Maximize/minimize [score_name] by modifying train.py.
[Score] measures [what it means for the research question].

## What you CAN modify
- train.py: architecture, optimizer, hyperparameters, training loop

## What you CANNOT modify
- prepare.py, probes.py (data and measurement are fixed)
- The eval function (last section of train.py)

## The experiment loop
LOOP FOREVER:
1. Modify train.py with an idea
2. git commit
3. Run: python train.py > run.log 2>&1
4. Read: grep "^score:" run.log
5. If improved, keep. Otherwise git reset.
6. NEVER STOP.
```

### Step 5: Launch

```bash
cd {project-dir}
tmux new-session -d -s autoresearch \
  "claude --dangerously-skip-permissions -p 'Read program.md and start. Baseline score is [X].'"
```

Monitor: `tmux attach -t autoresearch`
Check results: `cat results.tsv`
Kill: `tmux kill-session -t autoresearch`

Any coding agent with filesystem access works as the autonomous loop runner (Claude Code, Codex CLI, OpenCode, etc.). The key is `--dangerously-skip-permissions` or equivalent so it can edit and run without human approval.

### Step 6: Analyze and Evolve

After a batch of experiments:
- Read `results.tsv` — what patterns emerge?
- Read git log — what changes helped/hurt?
- **Evolve the experiment** — maybe the eval needs refinement, the probes need updating, or the question has shifted based on what we learned
- Relaunch with updated train.py and program.md

This is the compounding part. Each cycle doesn't just improve a score — it improves understanding of the question, which improves experiment design, which produces better signal.

## Infrastructure Setup

### Project Structure

```
{project-dir}/
  train.py          # model + training loop + eval
  prepare.py        # data loading, tokenizer
  probes.py         # behavioral probes (optional)
  program.md        # autonomous agent instructions
  results.tsv       # experiment history
  research-log.md   # research narrative
  {data-dir}/       # tokenized training data
```

### Model Constraints
- ~10-50M params practical on consumer hardware
- 5 min training budget is a good default (keeps iteration fast)
- Batch size 8 typical for MPS memory; adjust for your GPU
- No torch.compile on MPS; optional on CUDA

### Git Workflow
- Each experiment series gets a branch: `autoresearch/<tag>`
- Agent commits before each run, reverts on failure
- `results.tsv` tracks full experiment history
- `research-log.md` tracks the research narrative

## When to Use

- You have a question about AI/ML behavior that can be tested empirically
- The question can be reduced to a measurable property of a trained model
- You want to run experiments overnight without babysitting
- You want to explore a design space systematically

## When NOT to Use

- The question requires large-scale models to produce signal
- The question is purely theoretical / not empirically testable
- You need human judgment in the loop at every step
