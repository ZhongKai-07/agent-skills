[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z0-9-]+$')]
    [string]$Skill,

    [Parameter(Mandatory = $true)]
    [ValidateSet('codex', 'claude', 'agents')]
    [string]$Target
)

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $repositoryRoot "skills/$Skill"

if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md') -PathType Leaf)) {
    throw "Skill '$Skill' was not found under $source"
}

$targetRoot = switch ($Target) {
    'codex' {
        if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
    }
    'claude' {
        if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME '.claude' }
    }
    'agents' {
        if ($env:AGENTS_HOME) { $env:AGENTS_HOME } else { Join-Path $HOME '.agents' }
    }
}

$skillsRoot = Join-Path $targetRoot 'skills'
$destination = Join-Path $skillsRoot $Skill
New-Item -ItemType Directory -Path $skillsRoot -Force | Out-Null

if (Test-Path -LiteralPath $destination) {
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backup = "$destination.backup-$timestamp"
    Move-Item -LiteralPath $destination -Destination $backup
    Write-Host "Backed up existing Skill to $backup"
}

Copy-Item -LiteralPath $source -Destination $destination -Recurse
Write-Host "Installed $Skill for $Target to $destination"
