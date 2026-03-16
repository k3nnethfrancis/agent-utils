# Literature Review Template

## Frontmatter

```yaml
---
title: "Full Paper Title"
authors: [First Author, Second Author, ...]
venue: Conference or Journal Name
date: YYYY-MM-DD
arxiv: "XXXX.XXXXX"  # if applicable
url: "https://..."   # canonical link
paper_type: empirical | theoretical | system | survey | benchmark
tags: [domain-tag, method-tag, ...]
cybernetics:
  feedback_loops: true | false | partial
  learning_level: 0 | I | II | III
  requisite_variety: true | false | partial
  self_regulation: true | false | partial
  human_in_loop: explicit | implicit | none
reviewed: YYYY-MM-DD
---
```

## Body Sections

### Summary

2-3 sentences. What is this paper and what does it contribute?

### Problem Statement

What gap or challenge does this paper address? What was missing before this work?

### Core Claim

The main argument or thesis. What are they asserting?

### Key Insight

The non-obvious thing they figured out. What makes this work interesting or novel?

### Prior Work Positioning

How do they position against existing literature? What do they build on, what do they challenge?

### Architecture & Method

#### Components
List the main parts of the system/framework/approach.

#### Key Mechanisms
The specific techniques that make it work. How do components interact?

#### Design Decisions
Important choices they made with rationale. Why this approach over alternatives?

### Mathematical Formulations

*Include only if central to the contribution.*

Key equations or formalisms that define the approach.

### Evaluation

#### Setup
Datasets, baselines, metrics used.

#### Key Results
The numbers that matter. What did they demonstrate?

#### Ablations
What did they test to isolate their contribution?

#### Failure Modes
Where does it break? What are the limitations in practice?

### Critical Analysis

#### Stated Limitations
What do the authors acknowledge as limitations?

#### Our Critiques
What do we see that they missed or undersold?

#### Methodological Concerns
Threats to validity, questionable assumptions, reproducibility issues.

### Cybernetic Analysis

Brief narrative interpreting the rubric scores. What does this system look like through a control/feedback lens?

Reference the scores in frontmatter; here explain *why* they earned those scores.

### Connection to Research Goals

How does this paper relate to your core research questions?

What does it offer? What questions does it raise?

### Open Questions

What's left unanswered? What would we want to explore further?

---

## Writing Guidelines

- **Imperative form**: Write instructions as actions, not suggestions
- **Quotable passages**: Weave in verbatim quotes where they strengthen sections; don't create separate section
- **High-level on evaluation/criticism**: Don't exhaustively list every result; capture what matters
- **Conceptual reconstruction**: Aim for "could design something similar" not "could replicate exactly"
- **No follow-up actions section**: Decisions about what to do next happen outside the review
