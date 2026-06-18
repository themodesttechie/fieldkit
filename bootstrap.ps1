<#
.SYNOPSIS
  Field-kit bootstrap. Installs Claude Code + essential apps + copies skills.
  Safe to re-run (idempotent). No secrets baked in.
.NOTES
  Run elevated. INSTALL.cmd does that for you.
#>
[CmdletBinding()]
param(
    [switch]$NoApps,        # skip the winget essential-app installs
    [switch]$WhatIf         # dry run: print what would happen, change nothing
)

$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot

function Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Ok($msg)   { Write-Host "    [ok] $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "    [warn] $msg" -ForegroundColor Yellow }

function Have($cmd) { [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

function Winget-Install($id) {
    if ($WhatIf) { Write-Host "    would: winget install $id"; return }
    winget install --id $id -e --accept-source-agreements --accept-package-agreements --silent
}

Step "Field kit bootstrap starting"
Write-Host "    repo: $repo"

# --- 1. winget present? -------------------------------------------------
if (-not (Have winget)) {
    Warn "winget missing. Install 'App Installer' from Microsoft Store, then re-run."
    Warn "Continuing without app installs."
    $NoApps = $true
}

# --- 2. Node (Claude Code needs Node 18+) -------------------------------
Step "Node.js LTS"
if (Have node) {
    Ok "node already present: $(node --version)"
} else {
    Winget-Install 'OpenJS.NodeJS.LTS'
    # refresh PATH for this session so npm is visible immediately
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' +
                [System.Environment]::GetEnvironmentVariable('Path','User')
    if (Have node) { Ok "node installed: $(node --version)" } else { Warn "node not on PATH yet - reopen shell" }
}

# --- 3. Git (for cloning more tools) ------------------------------------
Step "Git"
if (Have git) { Ok "git present" } else { Winget-Install 'Git.Git' }

# --- 4. Claude Code ------------------------------------------------------
Step "Claude Code"
if (Have claude) {
    Ok "claude already present: $(claude --version 2>$null)"
} elseif ($WhatIf) {
    Write-Host "    would: npm install -g @anthropic-ai/claude-code"
} else {
    if (Have npm) {
        npm install -g @anthropic-ai/claude-code
        Ok "claude installed. Run 'claude' then log in with your Claude account."
    } else {
        Warn "npm not found this session. Reopen terminal and run: npm install -g @anthropic-ai/claude-code"
    }
}

# --- 5. Essential apps ---------------------------------------------------
if (-not $NoApps) {
    Step "Essential apps (winget)"
    $apps = @(
        'Google.Chrome',
        '7zip.7zip',
        'VideoLAN.VLC',
        'Microsoft.PowerToys',
        'Notepad++.Notepad++'
    )
    foreach ($a in $apps) {
        try { Winget-Install $a; Ok $a } catch { Warn "$a failed: $($_.Exception.Message)" }
    }
} else { Warn "Skipping app installs (-NoApps or winget missing)" }

# --- 6. Copy skills + slash commands into user Claude dir ---------------
Step "Install Claude skills + /wipe command"
$claudeHome = Join-Path $env:USERPROFILE '.claude'
$skillsSrc  = Join-Path $repo 'skills'
$skillsDst  = Join-Path $claudeHome 'skills'
$cmdSrc     = Join-Path $repo '.claude\commands'
$cmdDst     = Join-Path $claudeHome 'commands'

if ($WhatIf) {
    Write-Host "    would copy $skillsSrc -> $skillsDst"
    Write-Host "    would copy $cmdSrc -> $cmdDst"
} else {
    New-Item -ItemType Directory -Force -Path $skillsDst, $cmdDst | Out-Null
    if (Test-Path $skillsSrc) { Copy-Item "$skillsSrc\*" $skillsDst -Recurse -Force; Ok "skills copied" }
    if (Test-Path $cmdSrc)    { Copy-Item "$cmdSrc\*"    $cmdDst    -Recurse -Force; Ok "/wipe command copied" }
    # place cleanup script where the /wipe command expects it
    $cleanupSrc = Join-Path $repo 'uninstall-and-logout.ps1'
    if (-not (Test-Path $cleanupSrc)) { $cleanupSrc = Join-Path $repo 'cleanup.ps1' }
    if (Test-Path $cleanupSrc) { Copy-Item $cleanupSrc (Join-Path $claudeHome 'fieldkit-cleanup.ps1') -Force; Ok "cleanup script staged for /wipe" }
}

Step "Done"
Write-Host @"

NEXT:
  1. Run:  claude
  2. Log in with your Claude account (OAuth in browser).
  3. Do the work.
  4. When finished, inside Claude run:  /wipe
     (logs out + deletes all Claude creds/history on this machine)

"@ -ForegroundColor Green
