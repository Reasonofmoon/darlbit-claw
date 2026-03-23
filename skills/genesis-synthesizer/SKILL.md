---
name: genesis-synthesizer
description: "Weekly synthesis engine that combines all Insight Cards, Opportunity Cards, and Nightshift logs into a unified Weekly Genesis Report. Identifies the top 3 most impactful ideas and updates the idea backlog. Runs every Sunday night as the culmination of the Genesis Layer. Use when generating weekly creative summaries or strategic recommendations."
homepage: https://github.com/Reasonofmoon/darlbit-claw
metadata: { "openclaw": { "emoji": "🔮", "requires": { "bins": ["node"] } } }
---

# 🔮 Genesis Synthesizer — Weekly Creative Synthesis

The culmination of Layer 4 (Genesis). Combines all weekly signals into actionable ideas.

## When to Use

✅ **USE this skill when:**

- Running the weekly Sunday synthesis cycle
- Generating the Weekly Genesis Report
- Identifying the top strategic priorities for next week
- "이번 주 종합 분석해줘" / "Generate this week's Genesis report"

## When NOT to Use

❌ **DON'T use this skill when:**

- Looking for a specific insight (check individual cards instead)
- Running daily reflection (use nightshift instead)

## Synthesis Process

```
1. Collect this week's data:
   - All Insight Cards from cross-pollinator
   - All Opportunity Cards from serendipity-scout
   - 7 Nightshift logs
   - Skill metrics summary
2. Cluster by theme (tech stack, domain, problem type)
3. Score and rank by impact × feasibility
4. Select Top 3 Ideas
5. Generate Weekly Genesis Report
6. Update idea_backlog.md
7. Send summary to Telegram
```

## Weekly Genesis Report Format

```markdown
# 🌕 Weekly Genesis Report — Week NN, YYYY

## 🏆 Top 3 Ideas This Week

### 1. [Title] (Confidence: X.XX)
[Description and rationale]
- **Impact**: High/Medium/Low
- **Effort**: High/Medium/Low
- **Source**: [Card IDs]

### 2. ...
### 3. ...

## 📊 Week Summary
- Insights Generated: N
- Opportunities Found: N
- Anti-Patterns Resolved: N
- Skills Evolved: N
- Projects Touched: N/39
```

## Commands

### Run Weekly Synthesis
```powershell
# Generate this week's Genesis report
pwsh -File scripts/scan_workspace.ps1 -Mode Synthesis
```

## Output Location

- `workspace/genesis/weekly_reports/genesis_week_NN_YYYY.md`
- `workspace/genesis/idea_backlog.md` (updated)
- Telegram notification (if gateway active)

## Notes

- Scheduled for Sunday 23:30 KST (after the final Nightshift of the week)
- Depends on data from nightshift, cross-pollinator, and serendipity-scout
- The Top 3 Ideas feed into Paperclip's CEO Agent for strategic planning
