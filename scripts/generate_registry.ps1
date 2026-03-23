<#
.SYNOPSIS
    Generates and maintains the MoonWorkspace project registry.
    Scans all projects under F:\MoonWorkspace\MoonWorkspace\projects\
    and produces project_registry.json with health scores.

.DESCRIPTION
    Part of Layer 1 (Perception). Collects metadata for each project:
    - Git activity (last commit, recent commit count)
    - Build status (package.json existence)
    - Documentation health (README presence)
    - Domain classification

.EXAMPLE
    pwsh -File scripts/generate_registry.ps1
#>

param(
    [string]$WorkspacePath = "F:\MoonWorkspace\MoonWorkspace\projects",
    [string]$OutputPath = "F:\MoonWorkspace\MoonWorkspace\projects\darlbit-claw\workspace\perception\project_registry.json"
)

$ErrorActionPreference = "Stop"

# Domain classification rules
$domainMap = @{
    "edtech"    = @("connectedu-3","oet-korea","kukbop-data-hak","bluel","fill-blank","edunote","lecture-note-generator","opennote-skeleton","claude-curri-skills","csat-korean","debate","telegram-debate","vocab-deck","comprehensive-reading-app","genius-institute","idiom-scanner")
    "creative"  = @("remo-motion-graphic","textdna","link-2-ink","poetly","lofi-video-factory","quote-cutter","subtitle-generator","gentype","manga-gong-bang-temp","sports-video-archiver")
    "agent"     = @("darlbit-claw","paperclip","notebooklm-mcp","fashion-secretary")
    "framework" = @("app_dev_framework","ai-auto-generation-simulation","moonlight-library")
    "prototype" = @("_temp_math_teacher","_temp_memory_palace","_temp_prompt_gen","_temp_quote_app","_temp_studymap")
}

function Get-ProjectDomain($name) {
    foreach ($domain in $domainMap.Keys) {
        if ($domainMap[$domain] -contains $name) { return $domain }
    }
    return "other"
}

function Get-HealthScore($projectPath) {
    $score = 50

    # Git activity (last 7 days)
    try {
        $recentCommits = git -C $projectPath log --since="7 days ago" --oneline 2>$null | Measure-Object | Select-Object -ExpandProperty Count
        $score += [Math]::Min($recentCommits * 5, 25)
    } catch { }

    # README exists
    if (Test-Path (Join-Path $projectPath "README.md")) { $score += 5 } else { $score -= 5 }

    # package.json exists (indicates structured project)
    if (Test-Path (Join-Path $projectPath "package.json")) { $score += 5 }

    # .git exists (version controlled)
    if (Test-Path (Join-Path $projectPath ".git")) { $score += 5 } else { $score -= 10 }

    return [Math]::Max(0, [Math]::Min(100, $score))
}

function Get-LastCommitDate($projectPath) {
    try {
        $date = git -C $projectPath log -1 --format="%aI" 2>$null
        if ($date) { return $date.Trim() }
    } catch { }
    return $null
}

function Get-ProjectStatus($projectPath) {
    $lastCommit = Get-LastCommitDate $projectPath
    if (-not $lastCommit) { return "unknown" }

    $daysSince = ((Get-Date) - [datetime]::Parse($lastCommit)).Days
    if ($daysSince -le 7) { return "active" }
    elseif ($daysSince -le 30) { return "idle" }
    else { return "dormant" }
}

# Main scan
Write-Host "🔍 Scanning MoonWorkspace projects..." -ForegroundColor Cyan

$projects = @()
$dirs = Get-ChildItem -Path $WorkspacePath -Directory | Where-Object { $_.Name -ne "node_modules" }

foreach ($dir in $dirs) {
    $name = $dir.Name
    $path = $dir.FullName

    Write-Host "  📂 $name" -ForegroundColor Gray

    $project = @{
        name       = $name
        path       = $path
        domain     = Get-ProjectDomain $name
        status     = Get-ProjectStatus $path
        lastCommit = Get-LastCommitDate $path
        healthScore = Get-HealthScore $path
    }

    $projects += $project
}

# Build registry
$registry = @{
    projects      = $projects | Sort-Object { $_.healthScore } -Descending
    lastScan      = (Get-Date -Format "o")
    totalProjects = $projects.Count
    summary       = @{
        active   = ($projects | Where-Object { $_.status -eq "active" }).Count
        idle     = ($projects | Where-Object { $_.status -eq "idle" }).Count
        dormant  = ($projects | Where-Object { $_.status -eq "dormant" }).Count
        unknown  = ($projects | Where-Object { $_.status -eq "unknown" }).Count
    }
}

# Ensure output directory exists
$outputDir = Split-Path $OutputPath -Parent
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

# Write JSON
$registry | ConvertTo-Json -Depth 5 | Set-Content -Path $OutputPath -Encoding UTF8

Write-Host ""
Write-Host "✅ Registry saved to: $OutputPath" -ForegroundColor Green
Write-Host "   Total: $($projects.Count) projects | Active: $($registry.summary.active) | Idle: $($registry.summary.idle) | Dormant: $($registry.summary.dormant)" -ForegroundColor Yellow
