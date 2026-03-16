---
name: harness-engineering
description: Design and improve harnesses — the environments, constraints, feedback loops, and control systems that make AI agents do reliable work. Use when setting up a new project for agent-assisted development, diagnosing why agents are producing bad output, reviewing architectural constraints, or thinking about how to scale human oversight of agent workflows. Synthesizes OpenAI's harness engineering principles with cybernetic control theory.
---

# Harness Engineering

A harness is the full environment surrounding an AI agent — repository structure, documentation, linters, CI, architectural constraints, feedback loops, and coordination protocols. Harness engineering is the discipline of designing these environments so agents produce reliable, coherent work under human governance.

This is not prompt engineering. Prompts are one-shot instructions. A harness is the persistent structure that shapes every agent action — the difference between telling someone what to do and designing the room they work in.

## Theoretical Grounding

These practices map to cybernetic principles that explain *why* they work and predict *where* they'll fail.

### Ashby's Law of Requisite Variety

"Only variety can absorb variety." A controller must have at least as many states as the system it controls.

**Applied**: A linter with 5 rules cannot govern a codebase with 50 architectural patterns. Custom linters that embed remediation instructions in error messages *increase the variety of the control system* — each error message is a context-specific intervention, not a generic rule. When agents generate code faster than humans can review, the human loses requisite variety for oversight. Agent-to-agent review loops restore variety by distributing the control function.

**Diagnostic**: When agents consistently violate constraints, ask: does the harness have enough variety to match the agent's behavioral space? If not, no amount of re-prompting fixes it.

### Beer's Viable System Model

Organizations as recursive systems with five functions:

| System | Function | Harness Equivalent |
|--------|----------|-------------------|
| S1 | Operations | The agents doing the work |
| S2 | Coordination | Shared conventions, formatting, naming, file structure |
| S3 | Control | Linters, CI, structural tests, architectural constraints |
| S3* | Audit | Background agents scanning for entropy, pattern deviation |
| S4 | Intelligence | Observability, telemetry, monitoring — sensing the environment |
| S5 | Identity | CLAUDE.md, project principles, golden rules — what this system *is* |

**Applied**: Most harness failures are S2/S3 failures — coordination without enforcement, or enforcement without coordination. Custom linter error messages that include remediation instructions are S3 that teaches, not just blocks. Entropy management via background agents is S3* — continuous audit.

**Diagnostic**: When a codebase drifts, map the failure to VSM level. Missing S2 (no shared conventions) looks different from missing S4 (no observability into what agents are doing).

### Bateson's Learning Levels

- **Level 0**: Fixed response — agent follows a static template
- **Level I**: Agent adapts within a task — responds to linter feedback, fixes errors
- **Level II**: Agent learns patterns across tasks — recognizes architectural style and adapts
- **Level III**: Meta-systemic — the harness itself evolves based on what agents learn

**Applied**: Most harnesses operate at Level I — the agent hits a linter error, reads the remediation, fixes it. Level II requires that the agent's context includes enough architectural history to generalize. Level III is what background entropy-management agents attempt: the control system modifying itself based on observed patterns.

### Wiener's Feedback Loops

Negative feedback for stability (linters catching violations). Positive feedback for growth (successful patterns spreading). The harness is a feedback system — the question is whether the loops are fast enough and legible enough.

**Applied**: The principle that "corrections are cheap, waiting is expensive" is a statement about feedback loop latency. Slow review gates introduce delay into the control loop. Fast, automated checks keep the loop tight. But purely automated loops without human checkpoints risk positive feedback runaway — bad patterns self-reinforcing because no one is watching.

### Structural Coupling (Varela)

Systems co-evolve with their environments. Human-AI interaction isn't one-way — agents shape how humans think about architecture, and human architectural decisions shape agent behavior.

**Applied**: When you design a harness for agents, you also design the workflow humans follow. The documentation structure that works for agents (progressive disclosure, linked indexes) also changes how humans navigate the project. Be intentional about this co-evolution.

## Principles

### 1. Design Environments, Not Instructions

The human's job shifts from writing code to designing the world the agent works in:
- Repository structure and module boundaries
- Documentation architecture (progressive disclosure, not encyclopedias)
- CI/CD pipeline as behavioral constraint
- Linting rules with embedded remediation
- File naming and organizational conventions

A well-designed environment makes the right thing easy and the wrong thing loud.

### 2. Give Agents a Map, Not an Encyclopedia

Progressive disclosure beats comprehensive documentation. A short index pointing to a structured `docs/` directory outperforms a massive single file.

**Why it works (requisite variety)**: An 800-line instruction file exceeds the agent's effective attention. A 100-line table of contents with links matches the agent's retrieval pattern — scan, find pointer, follow to detail.

**Structure**: Top-level instructions as map. `docs/` directory as territory. Architecture decisions in `docs/architecture.md`. Conventions in `docs/conventions.md`. Agent-specific guidance in `docs/agent-guide.md`.

### 3. Enforce Architecture Mechanically

Telling agents "don't do X" in markdown is a suggestion. Making X trigger a build failure is a rule.

Linters, structural tests, and CI gates are the S3 control layer. They have teeth. Documentation does not. When an architectural constraint matters, encode it in tooling:
- Dependency direction tests
- Module boundary validation
- Import restriction enforcement
- Custom lint rules with remediation messages that teach the agent how to fix the violation

### 4. Use Boring Technology

Agents have been trained on mountains of widely-used libraries and frameworks. They have seen far less of your custom framework. Every proprietary abstraction is a variety-mismatch between what the agent knows and what the codebase needs.

**Cybernetic framing**: Boring technology reduces the variety of the problem space. The agent's training distribution already covers it. Novel technology increases required variety in both the agent and the harness.

### 5. Manage Entropy Actively

Agents replicate patterns — all of them, including bad ones. One workaround becomes canonical. Code quality degrades by accretion, not catastrophe.

Entropy management is Beer's S3* — continuous audit:
- Background agents scanning for pattern deviation
- Automated style and convention enforcement
- Periodic refactoring sweeps
- Quality grades on modules, tracked over time

Without active entropy management, agent-generated codebases degrade faster than human ones because agents reproduce what they see without judgment.

### 6. Build Feedback Loops at Every Level

| Level | Feedback Mechanism | Loop Speed |
|-------|-------------------|------------|
| Immediate | Linter errors, type errors, test failures | Seconds |
| Task | CI pipeline, integration tests | Minutes |
| Session | Code review (agent or human), PR checks | Hours |
| Project | Entropy scans, architecture drift detection | Days |
| Strategic | Metrics review, workflow retrospectives | Weeks |

Fast loops catch mechanical errors. Slow loops catch strategic drift. You need both.

### 7. Throttle Throughput to Match Oversight Capacity

When agents generate changes faster than the control system can review, the system loses governance. "Corrections are cheap, waiting is expensive" is only true when corrections are actually happening.

**Ashby's constraint**: The review function must have requisite variety to match the code generation function. If it doesn't, you're shipping unreviewed work.

Strategies:
- Agent-to-agent review loops (distribute variety across agents)
- Scoped PRs (reduce the variety per review unit)
- Automated classification of changes by risk (focus human review on high-variety changes)
- Hard gates on critical paths, fast-merge on low-risk changes

### 8. Make Knowledge Explicit and Versioned

If agents can't see it, it doesn't exist. Knowledge trapped in chat, meetings, or tribal memory is invisible to the harness.

Everything that governs agent behavior must be:
- In the repo (or discoverable via tools)
- Versioned (so you can see what changed and why)
- Machine-readable (structured docs, not prose-heavy narratives)
- Maintained (stale docs are worse than no docs — they inject false context)

## Diagnostic Framework

When agent output is bad, diagnose which layer is failing:

```
1. Context failure    → Agent didn't have the right information
                        Fix: documentation, file structure, progressive disclosure

2. Constraint failure → Agent violated an architectural rule
                        Fix: mechanical enforcement (linter, CI gate)

3. Variety failure    → Harness can't match agent's behavioral space
                        Fix: more specific constraints, agent-to-agent review

4. Feedback failure   → Agent made mistakes but nothing caught them
                        Fix: tighter loops, better tests, entropy scanning

5. Coupling failure   → Harness optimized for agents broke human workflow
                        Fix: co-design for both agent and human interaction

6. Identity failure   → Agent produced correct code that violates project values
                        Fix: project principles, golden rules, top-level instructions
```

## Applying to a New Project

When setting up or auditing a harness:

1. **Map the VSM** — identify what fills each system function (S1-S5). Find the gaps.
2. **Audit variety** — does the control system match the agent's behavioral space? Where are the mismatches?
3. **Check feedback latency** — how fast does the agent learn about mistakes? Where are the slow loops?
4. **Test entropy resistance** — introduce a deliberate bad pattern. How long until the harness catches it?
5. **Verify human oversight** — can a human understand what agents are doing? Can they intervene? Is this performative or real?

## When to Use This Skill

- Setting up a new project for agent-assisted development
- Diagnosing why agents are producing inconsistent or low-quality output
- Reviewing and strengthening architectural constraints
- Designing CI/CD pipelines for agent workflows
- Thinking about how to scale human oversight as agent throughput increases
- Evaluating whether a codebase is "agent-ready"
- After reading an agent's output and thinking "this is drifting"

## Sources

- [OpenAI: Harness Engineering](https://openai.com/index/harness-engineering/) — the 8 rules
- [OpenAI: Unlocking the Codex Harness](https://openai.com/index/unlocking-the-codex-harness/) — implementation details
- [Martin Fowler: Harness Engineering](https://martinfowler.com/articles/exploring-gen-ai/harness-engineering.html) — critical analysis
- Ashby, "Introduction to Cybernetics" (1956) — requisite variety
- Beer, "Brain of the Firm" (1972) — viable system model
- Bateson, "Steps to an Ecology of Mind" (1972) — learning levels
- Wiener, "Cybernetics" (1948) — feedback loops
- Varela & Maturana, "The Tree of Knowledge" (1987) — structural coupling
