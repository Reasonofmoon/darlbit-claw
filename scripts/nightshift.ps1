<#
.SYNOPSIS
    Nightshift — Daily Reflection Pipeline.
    Analyzes today's activities, detects patterns, extracts wisdom.

.DESCRIPTION
    Part of Layer 3 (Reflection). The core of Oblivion Chamber 2.0.
    Runs every night at 23:00 KST via Windows Task Scheduler.

.EXAMPLE
    pwsh -File scripts/nightshift.ps1
    pwsh -File scripts/nightshift.ps1 -BriefingOnly
#>

param(
    [switch]$BriefingOnly,
    [string]$WorkspacePath = "F:\MoonWorkspace\MoonWorkspace\projects",
    [string]$DarlbitPath   = "F:\MoonWorkspace\MoonWorkspace\projects\darlbit-claw"
)

$ErrorActionPreference = "Stop"
$today = Get-Date -Format "yyyy-MM-dd"
$logDir = Join-Path $DarlbitPath "workspace\reflection\nightshift_logs"

if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }

Write-Host ""
Write-Host "═══════════════════════════════════════════" -ForegroundColor DarkBlue
Write-Host "  🌙 Nightshift — $today"                    -ForegroundColor DarkBlue
Write-Host "═══════════════════════════════════════════" -ForegroundColor DarkBlue
Write-Host ""

# ─── [1] COLLECT ──────────────────────────────────────────────
Write-Host "[1/5] 📡 Collecting perception data..." -ForegroundColor Cyan

$projectDirs = Get-ChildItem -Path $WorkspacePath -Directory | Where-Object { $_.Name -ne "node_modules" }
$commitData = @()
$totalCommits = 0

foreach ($dir in $projectDirs) {
    try {
        $commits = git -C $dir.FullName log --since="24 hours ago" --oneline 2>$null
        $count = ($commits | Measure-Object).Count
        if ($count -gt 0) {
            $commitData += @{ Name = $dir.Name; Count = $count; Commits = $commits }
            $totalCommits += $count
        }
    } catch { }
}

$activeProjects = $commitData.Count
Write-Host "  Active today: $activeProjects projects, $totalCommits commits" -ForegroundColor Gray

# ─── [2] ANALYZE ──────────────────────────────────────────────
Write-Host "[2/5] 🔍 Analyzing patterns..." -ForegroundColor Cyan

# Check for error patterns in active projects
$errorPatterns = @()
foreach ($data in $commitData) {
    $projectPath = Join-Path $WorkspacePath $data.Name
    $errorFiles = @()

    # Check for recent error-related commits
    foreach ($commit in $data.Commits) {
        if ($commit -match "fix|error|bug|hotfix|patch") {
            $errorFiles += $commit
        }
    }

    if ($errorFiles.Count -gt 0) {
        $errorPatterns += @{ Project = $data.Name; Errors = $errorFiles }
    }
}

Write-Host "  Error-related commits: $($errorPatterns.Count) projects" -ForegroundColor Gray

# ─── [3] DECIDE (Oblivion) ────────────────────────────────────
Write-Host "[3/5] ⚖️  Making Oblivion decisions..." -ForegroundColor Cyan

$dormantProjects = @()
foreach ($dir in $projectDirs) {
    try {
        $lastDate = git -C $dir.FullName log -1 --format="%aI" 2>$null
        if ($lastDate) {
            $daysSince = ((Get-Date) - [datetime]::Parse($lastDate.Trim())).Days
            if ($daysSince -ge 30) {
                $dormantProjects += @{ Name = $dir.Name; DaysSince = $daysSince }
            }
        }
    } catch { }
}

Write-Host "  Dormant projects (30+ days): $($dormantProjects.Count)" -ForegroundColor Gray

# ─── [4] EXTRACT WISDOM ──────────────────────────────────────
Write-Host "[4/5] 💎 Extracting wisdom..." -ForegroundColor Cyan
Write-Host "  ℹ️  Deep wisdom extraction requires LLM analysis via Moltbot" -ForegroundColor Gray

# ─── [5] REPORT ───────────────────────────────────────────────
Write-Host "[5/5] 📝 Generating Nightshift log..." -ForegroundColor Cyan

$logFile = Join-Path $logDir "nightshift_log_$today.md"

$report = @"
# 🌙 Nightshift Log — $today

## Today's Vital Signs
- **Active Projects**: $activeProjects / $($projectDirs.Count)
- **Total Commits Today**: $totalCommits
- **Dormant Projects (30+ days)**: $($dormantProjects.Count)

## 📊 Project Activity

"@

foreach ($data in ($commitData | Sort-Object { $_.Count } -Descending)) {
    $report += "### $($data.Name) — $($data.Count) commits`n"
    foreach ($c in ($data.Commits | Select-Object -First 5)) {
        $report += "- ``$c```n"
    }
    $report += "`n"
}

if ($errorPatterns.Count -gt 0) {
    $report += "`n## 🔴 Error-Related Activity`n`n"
    foreach ($ep in $errorPatterns) {
        $report += "### $($ep.Project)`n"
        foreach ($e in $ep.Errors) {
            $report += "- ``$e```n"
        }
        $report += "`n"
    }
}

if ($dormantProjects.Count -gt 0) {
    $report += "`n## 🟡 Oblivion Candidates`n`n"
    $report += "| Project | Days Since Last Commit | Recommendation |`n"
    $report += "|:--------|:----------------------|:---------------|`n"
    foreach ($dp in ($dormantProjects | Sort-Object { $_.DaysSince } -Descending)) {
        $rec = if ($dp.DaysSince -ge 60) { "Archive" } elseif ($dp.DaysSince -ge 45) { "Review" } else { "Monitor" }
        $report += "| $($dp.Name) | $($dp.DaysSince) days | $rec |`n"
    }
}

$report += @"

## 📋 Tomorrow's Briefing

> ⚠️ Detailed briefing requires LLM analysis. Run through Moltbot for AI-powered insights.

- Active projects: Focus on today's most active ($( ($commitData | Sort-Object { $_.Count } -Descending | Select-Object -First 1).Name ))
- Dormant review: $($dormantProjects.Count) project(s) need attention

---
*Generated by Nightshift v1.0 | $(Get-Date -Format "HH:mm:ss")*
"@

Set-Content -Path $logFile -Value $report -Encoding UTF8

Write-Host ""
Write-Host "✅ Nightshift log saved: $logFile" -ForegroundColor Green
Write-Host "🌙 Nightshift complete. Good night. 🌕" -ForegroundColor DarkBlue
