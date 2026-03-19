---
name: skill-improver
description: Mine session logs for skill usage patterns, corrections, and failures to propose improvements. Use when the user says "improve skills", "review skill usage", "what have we learned about our skills", or periodically to evolve skills based on real usage data.
---

# Skill Improver

Scan session logs for how skills are actually used, where they fail, and what corrections the user made. Propose concrete improvements — gotchas entries, instruction changes, reference files.

Skills improve through real feedback, not imagination. This skill closes the loop.

## When to Use

- Periodically (every few weeks) to harvest accumulated feedback
- After a session where a skill produced bad output
- When the user says "improve skills", "review skill usage"
- When gotchas sections are empty and need filling

## How It Works

### Step 1: Find Skill Invocations

Scan session logs for skill reads. Skills show up as tool calls reading `SKILL.md` files:

```bash
# Find all skill invocations across recent sessions
grep -l "SKILL.md" sessions/*.md | sort -t/ -k2 -r | head -10
```

Within each session, skill invocations appear as:
- `"file_path": "...skills/{name}/SKILL.md"` — tool call reading the skill
- Direct path references like `/Users/.../skills/{name}/SKILL.md`

Extract skill name and line number for each invocation.

### Step 2: Extract Post-Invocation Context

For each skill invocation, read the conversation that follows. The signal lives in:

**User corrections** (lines after `## User` following skill output):
- "no not that" / "instead do" / "lets not" / "actually"
- "too [formal/verbose/vague/complex]"
- "I want it more like..." / "should be..."
- "rename" / "change" / "don't include"

**Failures** (in assistant output after invocation):
- Error messages
- "I made a mistake" / "let me fix"
- Re-reads of the same SKILL.md (indicating confusion)
- Output that was immediately corrected

**Patterns to extract per skill:**
1. What was the user trying to do?
2. Did the skill produce good output first try?
3. What corrections were made?
4. Were there structural failures (wrong files, wrong format, missing info)?
5. Were there taste/preference failures (tone, detail level, framing)?

### Step 3: Classify Findings

For each finding, classify:

| Type | Goes where | Example |
|------|-----------|---------|
| **Structural failure** | Gotchas section | "Skill assumes X file exists but it doesn't always" |
| **Missing information** | New reference file or instruction | "Skill doesn't know about the vault project directory" |
| **User preference** | Gotchas or instruction update | "User prefers shorter orient output with fewer bullets" |
| **Wrong approach** | Instruction rewrite | "Skill tries to do X but user always wants Y instead" |
| **Integration gap** | Add cross-skill reference | "After this skill, user always runs vault-tracking next" |

### Step 4: Search with QMD (Optional)

For deeper analysis across many sessions, use QMD to search semantically:

```
# Find sessions where skills were discussed or corrected
qmd search "skill correction feedback preference" --files -n 10

# Find sessions where specific skills were used
qmd search "strategize orient plan priorities" --files -n 5
```

This catches sessions where skills were discussed even without explicit SKILL.md reads (e.g., "the strategize skill should also...").

### Step 5: Propose Changes

For each skill with findings, propose specific edits:

```markdown
## Proposed: {skill-name}

### Gotchas to add:
- {gotcha from real failure}

### Instruction changes:
- Line X: change "{current}" to "{proposed}" because {reason from session}

### New reference files:
- references/{name}.md — {what it contains and why}

### Cross-skill integration:
- After {this skill}, suggest running {other skill} because {pattern observed}
```

Present all proposals together. Apply only after user approval.

## Extraction Script

Use this approach to scan a session:

```bash
# 1. Find skill invocations in a session
grep -n "skills/.*SKILL.md" "$SESSION_FILE" | grep -v "^#"

# 2. For each invocation at line N, find the next User message
#    (the response to the skill's output)
grep -n "^## User$" "$SESSION_FILE" | awk -F: -v n="$LINE_NUM" '$1 > n {print; exit}'

# 3. Read 50 lines from that User message for corrections
sed -n "${USER_LINE},+50p" "$SESSION_FILE"

# 4. Look for correction signals in those lines
grep -i "no \|not that\|actually\|instead\|don't\|should be\|rename\|change\|i want\|prefer\|too " <<< "$USER_LINES"
```

For multiple sessions, loop over the 5-10 most recent:
```bash
ls -t sessions/*.md | head -10 | while read f; do
  echo "=== $f ==="
  grep -c "SKILL.md" "$f"
done
```

## Principles

- **Real data only** — every proposed change must trace to an actual session event
- **Corrections over imagination** — don't invent gotchas, extract them from failures
- **Propose, don't apply** — always present changes for approval before editing skills
- **Preferences compound** — one correction is noise, three corrections on the same thing is a pattern
- **Structural > cosmetic** — prioritize failures that broke output over style preferences

## Gotchas

_Empty — add failure modes here as they're discovered in real use._

## Output

For each skill analyzed:
- Number of invocations found across sessions scanned
- Corrections/failures extracted (with session references)
- Proposed changes (gotchas, instructions, references)
- Confidence: high (3+ similar corrections) / medium (2) / low (1, might be situational)
