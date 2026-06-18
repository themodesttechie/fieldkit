<#
.SYNOPSIS
  End-of-session cleanup for a client machine. ONE script, run via UNINSTALL.cmd.
  - removes Claude Code credentials + session history
  - clears cached credentials
  - uninstalls Claude Code (npm or native)
  - signs you OUT of Google + Claude in the default browser (kills the OAuth session)
.NOTES
  Run in normal user context (no admin needed). Browser logout requires the
  default browser that was used for the OAuth login.
#>
[CmdletBinding()]
param([switch]$KeepClaudeInstalled)

$ErrorActionPreference = 'SilentlyContinue'
function Step($m) { Write-Host "`n==> $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "    [done] $m" -ForegroundColor Green }

Write-Host "FIELD KIT - end-of-session cleanup" -ForegroundColor Yellow

# 1. Remove Claude credentials + history -------------------------------
Step "Removing Claude credentials + history"
$paths = @(
    "$env:USERPROFILE\.claude",
    "$env:USERPROFILE\.claude.json",
    "$env:USERPROFILE\.claude.json.backup",
    "$env:APPDATA\claude-cli",
    "$env:LOCALAPPDATA\claude-cli"
)
foreach ($p in $paths) { if (Test-Path $p) { Remove-Item -Recurse -Force $p; Ok $p } }

# 2. Windows Credential Manager ----------------------------------------
Step "Clearing cached credentials"
cmdkey /list 2>$null | Select-String 'claude|anthropic' | ForEach-Object {
    if ($_ -match 'Target:\s*(.+)$') {
        $tgt = $Matches[1].Trim(); cmdkey /delete:$tgt | Out-Null; Ok "credmgr: $tgt"
    }
}

# 3. Uninstall Claude Code ---------------------------------------------
if (-not $KeepClaudeInstalled) {
    Step "Uninstalling Claude Code"
    $src = (Get-Command claude -ErrorAction SilentlyContinue).Source
    npm uninstall -g @anthropic-ai/claude-code 2>$null
    if ($src -and (Test-Path $src)) { Remove-Item -Force $src 2>$null }
    Ok "Claude Code removed (if it was installed)"
}

# 4. Sign out of Google + Claude in the browser ------------------------
Step "Signing out of Google + Claude in the default browser"
# Google logout URL signs out ALL Google accounts in that browser profile.
Start-Process "https://accounts.google.com/Logout"
Start-Sleep -Seconds 2
Start-Process "https://claude.ai/logout"
Ok "Opened logout pages - CONFIRM in the browser they show 'signed out'"

Step "Done"
Write-Host @"

CHECK BEFORE YOU LEAVE:
  - 'claude' command should be gone (open a new terminal, type claude -> not recognized)
  - browser should show you SIGNED OUT of Google (themodesttechie) and Claude
  - delete the fieldkit folder

"@ -ForegroundColor Green
