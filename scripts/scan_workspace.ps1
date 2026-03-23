<#
.SYNOPSIS
    MoonWorkspace scanner with multiple operating modes.
    Supports CrossPollinate, Serendipity, and Synthesis modes.

.DESCRIPTION
    Part of Layer 4 (Genesis). Orchestrates the creative engines:
    - CrossPollinate: Find reusable patterns between projects
    - Serendipity: Scan external sources for opportunities
    - Synthesis: Generate weekly Genesis report

.EXAMPLE
    pwsh -File scripts/scan_workspace.ps1 -Mode CrossPollinate
    pwsh -File scripts/scan_workspace.ps1 -Mode Synthesis
#>

param(
    [ValidateSet("CrossPollinate","Serendipity","Synthesis","All")]
    [string]$Mode = "All",

    [string]$WorkspacePath = "F:\MoonWorkspace\MoonWorkspace\projects",
    [string]$DarlbitPath   = "F:\MoonWorkspace\MoonWorkspace\projects\darlbit-claw"
)

$ErrorActionPreference = "Stop"
$timestamp = Get-Date -Format "yyyy-MM-dd"
$weekNum   = Get-Date -UFormat "%V"
$year      = Get-Date -Format "yyyy"

# ─── CROSS-POLLINATE ──────────────────────────────────────────
function Invoke-CrossPollinate {
    Write-Host "🐝 Cross-Pollination Engine starting..." -ForegroundColor Yellow

    $registryPath = Join-Path $DarlbitPath "workspace\perception\project_registry.json"
    $patternsPath = Join-Path $DarlbitPath "workspace\reflection\proven_patterns.md"
    $outputDir    = Join-Path $DarlbitPath "workspace\genesis\insights"

    if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

    # Load registry
    if (-not (Test-Path $registryPath)) {
        Write-Host "  ⚠️  project_registry.json not found. Run generate_registry.ps1 first." -ForegroundColor Red
        return
    }

    $registry = Get-Content $registryPath | ConvertFrom-Json

    # Analyze tech stack overlaps
    $techStacks = @{}
    foreach ($project in $registry.projects) {
        $pkgPath = Join-Path $project.path "package.json"
        if (Test-Path $pkgPath) {
            try {
                $pkg = Get-Content $pkgPath | ConvertFrom-Json
                $deps = @()
                if ($pkg.dependencies) { $deps += $pkg.dependencies.PSObject.Properties.Name }
                if ($pkg.devDependencies) { $deps += $pkg.devDependencies.PSObject.Properties.Name }
                $techStacks[$project.name] = $deps
            } catch { }
        }
    }

    # Find overlaps
    $overlaps = @()
    $projectNames = $techStacks.Keys | Sort-Object
    for ($i = 0; $i -lt $projectNames.Count; $i++) {
        for ($j = $i + 1; $j -lt $projectNames.Count; $j++) {
            $a = $projectNames[$i]
            $b = $projectNames[$j]
            $shared = $techStacks[$a] | Where-Object { $techStacks[$b] -contains $_ }
            if ($shared.Count -ge 5) {
                $overlaps += @{ ProjectA = $a; ProjectB = $b; SharedDeps = $shared.Count; TopShared = ($shared | Select-Object -First 5) -join ", " }
            }
        }
    }

    Write-Host "  Found $($overlaps.Count) significant tech stack overlaps" -ForegroundColor Cyan

    # Generate insight summary
    $insightFile = Join-Path $outputDir "cross_pollinate_$timestamp.md"
    $content = "# 🐝 Cross-Pollination Scan — $timestamp`n`n"
    $content += "## Tech Stack Overlaps (5+ shared dependencies)`n`n"

    foreach ($overlap in ($overlaps | Sort-Object { $_.SharedDeps } -Descending | Select-Object -First 15)) {
        $content += "### $($overlap.ProjectA) ↔ $($overlap.ProjectB) ($($overlap.SharedDeps) shared)`n"
        $content += "- **Key shared**: $($overlap.TopShared)`n`n"
    }

    Set-Content -Path $insightFile -Value $content -Encoding UTF8
    Write-Host "  ✅ Saved: $insightFile" -ForegroundColor Green
}

# ─── SERENDIPITY ──────────────────────────────────────────────
function Invoke-Serendipity {
    Write-Host "🎲 Serendipity Scout starting..." -ForegroundColor Yellow
    Write-Host "  ℹ️  External scanning requires OpenClaw gateway with web_search skill." -ForegroundColor Gray
    Write-Host "  ℹ️  This mode generates a prompt template for the agent to execute." -ForegroundColor Gray

    $outputDir = Join-Path $DarlbitPath "workspace\genesis\opportunities"
    if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

    $promptFile = Join-Path $outputDir "serendipity_prompt_$timestamp.md"
    $content = @"
# 🎲 Serendipity Scout Prompt — $timestamp

## Instructions for Moltbot
Execute the following searches and analyze relevance to MoonWorkspace:

### 1. GitHub Trending (This Week)
``````
web_search: "GitHub trending repositories this week education technology"
web_search: "GitHub trending repositories this week AI agents tools"
web_search: "GitHub trending repositories this week Next.js components"
``````

### 2. EdTech News
``````
web_search: "latest EdTech tools 2026 AI learning"
web_search: "Gemini API new features 2026"
``````

### 3. Relevance Check
For each discovery, evaluate:
- Does it match any project in project_registry.json?
- Could it solve an active Anti-Pattern?
- Could it enhance a Proven Pattern?

### 4. Output
Generate Opportunity Cards for discoveries with relevance > 0.7
Save to: workspace/genesis/opportunities/OPP-$timestamp-NNN.md
"@

    Set-Content -Path $promptFile -Value $content -Encoding UTF8
    Write-Host "  ✅ Prompt saved: $promptFile" -ForegroundColor Green
}

# ─── SYNTHESIS ────────────────────────────────────────────────
function Invoke-Synthesis {
    Write-Host "🔮 Genesis Synthesis starting..." -ForegroundColor Yellow

    $outputDir = Join-Path $DarlbitPath "workspace\genesis\weekly_reports"
    if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

    # Collect this week's data
    $insightsDir  = Join-Path $DarlbitPath "workspace\genesis\insights"
    $oppsDir      = Join-Path $DarlbitPath "workspace\genesis\opportunities"
    $nightshiftDir = Join-Path $DarlbitPath "workspace\reflection\nightshift_logs"

    $insightCount  = if (Test-Path $insightsDir) { (Get-ChildItem $insightsDir -File).Count } else { 0 }
    $oppCount      = if (Test-Path $oppsDir) { (Get-ChildItem $oppsDir -File).Count } else { 0 }
    $nightshiftCount = if (Test-Path $nightshiftDir) { (Get-ChildItem $nightshiftDir -File).Count } else { 0 }

    # Project activity summary
    $registryPath = Join-Path $DarlbitPath "workspace\perception\project_registry.json"
    $projectsTouched = 0
    $totalProjects = 0
    if (Test-Path $registryPath) {
        $registry = Get-Content $registryPath | ConvertFrom-Json
        $totalProjects = $registry.totalProjects
        $projectsTouched = ($registry.projects | Where-Object { $_.status -eq "active" }).Count
    }

    # Generate report
    $reportFile = Join-Path $outputDir "genesis_week_${weekNum}_${year}.md"
    $content = @"
# 🌕 Weekly Genesis Report — Week $weekNum, $year

> Generated: $timestamp
> This report synthesizes all insights and opportunities from the past week.

## 📊 Week Summary

| Metric | Value |
|:-------|:------|
| Insights Generated | $insightCount |
| Opportunities Found | $oppCount |
| Nightshift Logs | $nightshiftCount |
| Projects Touched | $projectsTouched / $totalProjects |

## 🏆 Top Ideas This Week

> ⚠️ This section requires LLM analysis of the collected data.
> Run the genesis-synthesizer skill through Moltbot for AI-powered ranking.

### Collected Data Locations
- Insights: ``workspace/genesis/insights/``
- Opportunities: ``workspace/genesis/opportunities/``
- Nightshift Logs: ``workspace/reflection/nightshift_logs/``
- Anti-Patterns: ``workspace/reflection/anti_patterns.md``
- Proven Patterns: ``workspace/reflection/proven_patterns.md``

## 📋 Next Week Focus

(To be filled by Moltbot after LLM analysis)

---
*Generated by Genesis Synthesizer v1.0*
"@

    Set-Content -Path $reportFile -Value $content -Encoding UTF8
    Write-Host "  ✅ Report saved: $reportFile" -ForegroundColor Green
}

# ─── MAIN ─────────────────────────────────────────────────────
Write-Host ""
Write-Host "═══════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "  🌕 MoonWorkspace Scanner — Mode: $Mode"    -ForegroundColor Magenta
Write-Host "═══════════════════════════════════════════" -ForegroundColor Magenta
Write-Host ""

switch ($Mode) {
    "CrossPollinate" { Invoke-CrossPollinate }
    "Serendipity"    { Invoke-Serendipity }
    "Synthesis"      { Invoke-Synthesis }
    "All" {
        Invoke-CrossPollinate
        Write-Host ""
        Invoke-Serendipity
        Write-Host ""
        Invoke-Synthesis
    }
}

Write-Host ""
Write-Host "✨ Scan complete." -ForegroundColor Green
