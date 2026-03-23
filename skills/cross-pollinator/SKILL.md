---
name: cross-pollinator
description: "Discovers hidden connections between MoonWorkspace projects by analyzing shared patterns, tech stacks, and proven solutions. Generates Insight Cards when a solution from one project can be applied to another. Use this skill when looking for reusable patterns or cross-project optimization opportunities."
homepage: https://github.com/Reasonofmoon/darlbit-claw
metadata: { "openclaw": { "emoji": "🐝", "requires": { "bins": ["git", "node"] } } }
---

# 🐝 Cross-Pollinator — Project Connection Discovery

The heart of Layer 4 (Genesis). Discovers hidden connections between projects.

## When to Use

✅ **USE this skill when:**

- Looking for reusable patterns across MoonWorkspace projects
- A problem was solved in one project and might apply to others
- Searching for cross-project optimization opportunities
- "다른 프로젝트에서 비슷한 문제를 해결한 적 있어?" / "Find cross-project patterns"

## When NOT to Use

❌ **DON'T use this skill when:**

- Working on a single isolated project without cross-project relevance
- Need to search external resources (use serendipity-scout instead)

## Analysis Process

```
1. Load project_registry.json (39 projects)
2. Load proven_patterns.md (verified solutions)
3. Load skill_metrics.jsonl (usage history)
4. For each Proven Pattern:
   a. Find projects with matching tech stack
   b. Check if those projects lack the pattern
   c. If match → Generate Insight Card
5. Save to workspace/genesis/insights/
```

## Insight Card Format

```markdown
## INS-YYYY-MM-DD-NNN: [Title]
- **Source**: [origin project] ([pattern ID])
- **Target**: [candidate project]
- **Confidence**: 0.0-1.0
- **Rationale**: [why this connection exists]
- **Action**: [suggested next step]
- **Status**: PROPOSED | ACCEPTED | REJECTED
```

## Commands

### Scan for Cross-Pollination Opportunities
```powershell
# Analyze all projects for hidden connections
pwsh -File scripts/scan_workspace.ps1 -Mode CrossPollinate
```

## Output Location

- `workspace/genesis/insights/INS-YYYY-MM-DD-NNN.md`
- `workspace/genesis/idea_backlog.md` (appended)

## Notes

- Runs automatically as part of weekly Genesis Synthesis (Sundays)
- Can also be triggered manually when a new Proven Pattern is registered
- Read-only operation — does not modify any project files
