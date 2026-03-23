---
name: nightshift
description: "The Nightshift reflection skill runs every night at 23:00 to analyze the day's activities, detect failure patterns, extract wisdom, and generate a morning briefing. It is the core of Oblivion Chamber 2.0. Use this skill when performing daily reflection, reviewing project health, or generating a morning briefing."
homepage: https://github.com/Reasonofmoon/darlbit-claw
metadata: { "openclaw": { "emoji": "🌙", "requires": { "bins": ["git", "node"] } } }
---

# 🌙 Nightshift — Daily Reflection Skill

The core of Layer 3 (Reflection). Runs every night to analyze, reflect, and extract wisdom.

## When to Use

✅ **USE this skill when:**

- Running the daily 23:00 reflection cycle
- Analyzing today's Git activity and skill usage across MoonWorkspace
- Detecting repeated failure patterns (Anti-Patterns)
- Generating tomorrow's morning briefing
- "Run the nightshift" / "오늘 하루 돌아봐줘"

## When NOT to Use

❌ **DON'T use this skill when:**

- Performing real-time debugging (use coding-agent instead)
- Searching for specific information (use memory_search or web_search)
- Running tasks that need immediate execution (use exec)

## Pipeline

```
[1] COLLECT   → Gather Perception events + Cognition metrics
[2] ANALYZE   → Detect patterns (failures, successes, inactivity)
[3] DECIDE    → Oblivion decisions (archive, preserve, warn)
[4] EXTRACT   → Convert lessons to Zettelkasten notes
[5] REPORT    → Generate nightshift_log_YYYY-MM-DD.md
```

## Commands

### Run Full Nightshift
```powershell
# Trigger the complete nightshift pipeline
pwsh -File scripts/nightshift.ps1
```

### Generate Morning Briefing Only
```powershell
# Skip analysis, just generate tomorrow's briefing from existing data
pwsh -File scripts/nightshift.ps1 -BriefingOnly
```

## Output Locations

- `workspace/reflection/nightshift_logs/nightshift_log_YYYY-MM-DD.md`
- `workspace/reflection/anti_patterns.md` (appended)
- `workspace/reflection/proven_patterns.md` (appended)
- `workspace/MEMORY.md` (wisdom appended)

## Notes

- Scheduled via Windows Task Scheduler at 23:00 KST daily
- Requires read access to all projects in `F:\MoonWorkspace\MoonWorkspace\projects\`
- Does NOT modify any project code — read-only analysis
- Results are sent to Telegram if gateway is active
