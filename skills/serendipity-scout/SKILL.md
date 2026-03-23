---
name: serendipity-scout
description: "Monitors external sources (GitHub Trending, Hacker News, EdTech blogs, RSS) and matches discoveries against internal project needs using QMD semantic similarity. Generates Opportunity Cards when a relevant external tool, technique, or pattern is found. Use when looking for external innovation applicable to MoonWorkspace."
homepage: https://github.com/Reasonofmoon/darlbit-claw
metadata: { "openclaw": { "emoji": "🎲", "requires": { "bins": ["node"], "skills": ["web_search", "web_fetch"] } } }
---

# 🎲 Serendipity Scout — External Discovery Engine

Part of Layer 4 (Genesis). Captures meaningful coincidences from the outside world.

## When to Use

✅ **USE this skill when:**

- Searching for external tools/libraries that could help current projects
- Monitoring tech trends relevant to MoonWorkspace's domains (EdTech, Creative, Agent)
- Weekly Genesis scan for external opportunities
- "밖에서 쓸만한 새로운 도구 없어?" / "What's trending that I should know about?"

## When NOT to Use

❌ **DON'T use this skill when:**

- Looking for internal patterns (use cross-pollinator)
- Need a specific known tool (use web_search directly)

## Discovery Process

```
1. Scan external sources:
   - GitHub Trending (weekly)
   - Hacker News Top Stories
   - EdTech blogs & RSS feeds
   - npm / PyPI trending packages
2. For each discovery:
   a. Extract key capabilities
   b. Compute QMD semantic similarity vs project_registry
   c. If relevance > threshold → Generate Opportunity Card
3. Save to workspace/genesis/opportunities/
```

## Opportunity Card Format

```markdown
## OPP-YYYY-MM-DD-NNN: [Tool/Library/Technique Name]
- **Source**: [URL or platform]  
- **Relevance Score**: 0.0-1.0
- **Related Projects**: [matching internal projects]
- **Opportunity**: [how this could be applied]
- **Effort**: Low | Medium | High
- **Status**: DISCOVERED | EVALUATED | ADOPTED | DISMISSED
```

## Commands

### Run External Scan
```powershell
# Scan external sources for relevant discoveries
pwsh -File scripts/scan_workspace.ps1 -Mode Serendipity
```

## Output Location

- `workspace/genesis/opportunities/OPP-YYYY-MM-DD-NNN.md`
- `workspace/genesis/idea_backlog.md` (appended)

## Notes

- Scheduled weekly as part of Genesis Synthesis
- Uses `web_search` and `web_fetch` skills for data collection
- Respects rate limits on external APIs
- Results are filtered by relevance to avoid noise
