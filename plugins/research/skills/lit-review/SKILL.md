---
name: lit-review
description: Structured literature review workflow. Use when the user asks to "do a lit review", "review this paper", "triage these papers", "compare papers", or mentions arXiv, research papers, or academic literature.
---

# Literature Review

Structured capture of research papers for a knowledge base. Reviews enable conceptual reconstruction of studies and synthesis across the field.

## Modes

### Triage
Quick 2-3 sentence summary for go/no-go decisions. Use when screening multiple papers.

Format: Title, authors, venue -> what it claims -> why it might matter (or not).

### Full Review
Comprehensive structured capture. Default mode when asked to "review" or "do a lit review."

See `references/review-template.md` for full structure.

### Compare
Pull scores across multiple reviews for synthesis. Use when asked to compare papers or do meta-analysis.

Generate comparison table from frontmatter fields, then narrative synthesis of patterns.

## Full Review Workflow

1. **Fetch the paper** - Use WebFetch for arXiv HTML, WebSearch for finding papers, or read from provided PDF/URL
2. **Extract metadata** - Authors, venue, date, arXiv ID, paper type
3. **Identify core contribution** - Problem statement, key claim, key insight
4. **Map the architecture** - Components, mechanisms, design decisions with rationale
5. **Assess evaluation** - Setup, key results, ablations, failure modes (high-level)
6. **Critical analysis** - Stated limitations, our critiques, methodological concerns
7. **Score analysis dimensions** - Apply rubric from `references/cybernetic-rubric.md`
8. **Connect to research goals** - How does this relate to your research questions?
9. **Flag open questions** - What's left unanswered?

Weave quotable passages inline where they strengthen other sections.

## Output Format

Hybrid: YAML frontmatter (structured, queryable) + markdown prose (nuanced analysis).

```yaml
---
title: "Paper Title"
authors: [Author One, Author Two]
venue: Conference/Journal Name
date: YYYY-MM-DD
arxiv: "XXXX.XXXXX"
paper_type: empirical | theoretical | system | survey | benchmark
tags: [tag1, tag2]
cybernetics:
  feedback_loops: true | false | partial
  learning_level: 0 | I | II | III
  requisite_variety: true | false | partial
  self_regulation: true | false | partial
  human_in_loop: explicit | implicit | none
---
```

## Key Principles

- **Conceptual reconstruction**: Capture enough to design something similar, not to replicate exactly
- **Research memory**: This extends beyond training knowledge - be thorough on recent work
- **Compression for synthesis**: These get combined into meta-analyses - make them comparable
- **Analysis lens**: Always assess control-relevant dimensions

## Gotchas

_Empty — add failure modes here as they're discovered in real use._

## Additional Resources

### Reference Files
- **`references/review-template.md`** - Full review structure with section guidance
- **`references/cybernetic-rubric.md`** - Scoring rubric with analysis dimensions

### Examples
- **`examples/saga-review.md`** - Complete review demonstrating the format
