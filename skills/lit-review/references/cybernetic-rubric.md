# Cybernetic Rubric

Evaluate papers through the lens of control, feedback, and human-AI interaction.

## Dimensions

### Feedback Loops

Does the system observe its own outputs and adjust?

| Score | Description |
|-------|-------------|
| **true** | Explicit feedback mechanism where outputs influence subsequent behavior |
| **partial** | Some feedback exists but not central to the design |
| **false** | Open-loop system with no self-observation |

### Learning Level (Bateson)

What kind of learning does the system exhibit?

| Level | Description | Example |
|-------|-------------|---------|
| **0** | Fixed response - no learning | Thermostat, static rule-based system |
| **I** | Response learning - change behavior based on feedback | Model fine-tuning on task |
| **II** | Learning to learn - change the process of learning, acquire new contexts | Meta-learning, in-context learning |
| **III** | Meta-systemic change - revise the framework that governs Level II | Revising what counts as "good performance" |

**Level III is rare.** It involves changing the premises through which you evaluate learning itself. Most current systems operate at Level I or II.

### Requisite Variety (Ashby)

Does controller complexity match system complexity?

"Only variety can absorb variety." A controller needs at least as many states as the system it controls.

| Score | Description |
|-------|-------------|
| **true** | Controller has sufficient complexity to handle system states |
| **partial** | Some complexity matching, but gaps exist |
| **false** | Controller is too simple for the system it's trying to manage |

### Self-Regulation

Can it detect and correct its own errors?

| Score | Description |
|-------|-------------|
| **true** | Explicit error detection and correction mechanisms |
| **partial** | Some error handling but not systematic |
| **false** | Errors propagate without detection or correction |

### Human-in-Loop

Where and how do humans intervene? Is it architecturally explicit?

| Score | Description |
|-------|-------------|
| **explicit** | Clear intervention points designed into the architecture |
| **implicit** | Humans can intervene but it's not designed for |
| **none** | Fully autonomous with no designed human touchpoints |

## Scoring in Practice

When reviewing a paper:

1. Read for evidence of each dimension
2. Assign scores based on what's architecturally present, not aspirational
3. Note uncertainty - if unclear from the paper, say so
4. In the analysis section, explain *why* you assigned each score

## Connection to Human-AI Control

This rubric operationalizes dimensions relevant to understanding how humans maintain control over AI systems:

- **Feedback loops** - Can humans observe and understand system behavior?
- **Learning level** - How predictable is system behavior? Level III systems may surprise.
- **Requisite variety** - Do human oversight mechanisms have enough complexity?
- **Self-regulation** - Does the system help or hinder human understanding of errors?
- **Human-in-loop** - Are control points designed or accidental?
