# Deep Dive Report Format

Every report in `$BOOKMARKS_DIR/reports/` follows this structure.

## Frontmatter

```yaml
---
title: "Descriptive Title"
date: YYYY-MM-DD
categories:
  - category-slug-1           # from your guidance doc categories
  - category-slug-2
tier: 1                        # 1 or 2, from triage
sources:
  - url: "https://..."
    type: paper                # paper | blog | tweet | github | video
  - url: "https://..."
    type: tweet
tags:
  - specific-tag               # freeform, specific to this report
  - another-tag
status: unread                 # unread → read → referenced
triage_date: "YYYY-MM-DD"
---
```

## Body Sections

```markdown
# {Title}

## Source
- Tweet: {url}
- Paper: {url if found}
- Blog: {url if found}
- GitHub: {url if found}

## Key Findings
{Bullet points of concrete findings — be specific, cite numbers and methods.
 This is the most important section. No fluff.}

## Methodology (if applicable)
{How they tested/built this — datasets, evaluation methods, baselines.
 Skip if source is a tweet thread without formal methodology.}

## Project Implications
{Specific ways this informs your active projects.
 Connect to concrete concepts in your research or engineering work.
 Split into subsections per project if relevant to multiple.}

## Actionable Takeaways
{What you should DO with this information — be concrete.
 "Read section X" > "interesting paper".
 "Prototype detection for pattern Y" > "relevant to our work".}

## Open Questions
{What remains unknown or needs follow-up.
 Genuinely open — not restated findings as questions.}
```

## Filename Convention

Slugified: lowercase, hyphens instead of spaces, no special characters.

Examples:
- `when-multi-agent-helps-vs-hurts.md`
- `interp-scaled-rl-findings.md`
- `agent-failure-taxonomy-7-patterns.md`
