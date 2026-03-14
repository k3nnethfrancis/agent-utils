---
title: "Accelerating Scientific Discovery with Autonomous Goal-evolving Agents"
authors: [Wei Du, et al.]
venue: arXiv
date: 2025-12-31
arxiv: "2512.21782"
url: "https://arxiv.org/abs/2512.21782"
paper_type: system
tags: [multi-agent, scientific-discovery, objective-evolution, optimization]
cybernetics:
  feedback_loops: true
  learning_level: II
  requisite_variety: true
  self_regulation: true
  human_in_loop: explicit
reviewed: 2026-01-17
---

# SAGA: Scientific Autonomous Goal-evolving Agent

## Summary

SAGA addresses a fundamental assumption in AI-driven optimization: that objective functions are known and fixed. Instead, it treats objectives as discoverable through iterative refinement—a bi-level architecture where an outer loop of LLM agents evolves objectives while an inner loop optimizes solutions. Demonstrated state-of-the-art across four domains: antibiotic design, inorganic materials, functional DNA, and chemical processes.

## Problem Statement

Most optimization frameworks assume objectives are given. SAGA argues this assumption is the bottleneck—not the optimization itself. In practice, scientists iterate on what they're optimizing for as they observe results.

## Core Claim

The problem should be reframed from "optimize X given objective Y" to "discover the objective function that produces valuable X."

## Key Insight

Objectives can be gamed or incomplete. When antibiotic candidates achieved high predicted potency but poor drug-likeness, a naive optimizer would keep producing similar candidates. SAGA's Analyzer detects this pattern and the Planner proposes additional constraints. The system doesn't just optimize—it notices when optimization is going wrong.

## Architecture & Method

### Components

**Outer loop (4 agents):**
- **Planner**: Decomposes goals into measurable objectives with weights/directions
- **Implementer**: Converts abstract objectives to executable scoring functions
- **Optimizer**: Runs domain-specific search (default: LLM-based evolutionary algorithms)
- **Analyzer**: Evaluates progress, identifies failure modes, recommends adjustments

**Inner loop:** Standard optimization under current objectives.

### Key Mechanisms

The Analyzer-Planner feedback enables the system to notice "reward hacking" or incomplete objectives. The Analyzer observes candidate populations, detects patterns, and generates diagnostic reports. The Planner receives these and proposes objective modifications.

### Design Decisions

- **Held-out evaluation**: All final metrics kept separate from optimization objectives
- **Three autonomy levels**: Co-pilot (human at each iteration), Semi-pilot (human reviews Analyzer only), Autopilot (fully autonomous)
- **Multi-objective discovery**: Handles candidate-wise, population-wise, and filter objectives

## Evaluation

### Key Results

| Domain | Finding |
|--------|---------|
| Antibiotics | >90% passed all practical thresholds; baselines achieved activity OR drug-likeness, not both |
| Magnets | 15 novel stable structures in 200 DFT calculations |
| DNA enhancers | 48% improvement in specificity |

### Failure Modes

- Requires computational verification (no wet-lab-in-the-loop yet)
- Some sensitivity to objective weights affecting convergence stability
- Design space assumed given (doesn't discover appropriate solution spaces)

## Cybernetic Analysis

**Feedback loops (true)**: Explicit Analyzer->Planner feedback where outputs influence subsequent objective-setting.

**Learning level (II)**: The system exhibits "learning to learn"—it doesn't just optimize within a fixed frame, it revises the frame itself.

**Requisite variety (true)**: Four specialized agents provide variety needed to manage complex optimization landscape.

**Self-regulation (true)**: Analyzer explicitly detects failure modes (clustering, reward hacking) and triggers corrective objective changes.

**Human-in-loop (explicit)**: Three autonomy levels with clear intervention points.

## Open Questions

- How do agents handle conflicting assessments?
- Sample efficiency across domains?
- Transfer to non-scientific domains?
- What would Level III look like here—revising what counts as "good science"?
