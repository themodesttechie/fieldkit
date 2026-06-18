<#
.SYNOPSIS
  Wipe Claude Code credentials + history off this machine. Run before you leave.
.DESCRIPTION
  Removes the OAuth token, session history, MCP config, copied skills/commands.
  Optionally uninstalls Claude Code entirely.
#>
[CmdletBinding()]
param(
    [switch]$Uninstall,   # also npm-uninstall Claude Code
    [switch]$KeepApps     # (no-op placeholder; apps are the client's to keep)
)

$ErrorActionPreference = 'SilentlyContinue'

function Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Ok($msg)   { Write-Host "    [removed] $msg" -ForegroundColor Green }

Write-Host "WIPING Claude Code credentials + data from this machine." -ForegroundColor Yellow

$targets = @(
    (Join-Path $env:USERPROFILE '.claude'),
    (Join-Path $env:USERPROFILE '.claude.json'),
    (Join-Path $env:USERPROFILE '.claude.json.backup'),
    (Join-Path $env:APPDATA 'claude-cli'),
    (Join-Path $env:LOCALAPPDATA 'claude-cli')
)

Step "Removing credential + data paths"
foreach ($t in $targets) {
    if (Test-Path $t) { Remove-Item -Recurse -Force $t; Ok $t }
}

# Windows Credential Manager entries (token sometimes cached here)
Step "Clearing cached credentials"
cmdkey /list 2>$null | Select-String -Pattern 'claude|anthropic' | ForEach-Object {
    if ($_ -match 'Target:\s*(.+)$') {
        $tgt = $Matches[1].Trim()
        cmdkey /delete:$tgt 2>$null
        Ok "credmgr: $tgt"
    }
}

if ($Uninstall) {
    Step "Uninstalling Claude Code"
    npm uninstall -g @anthropic-ai/claude-code 2>$null
    Ok "claude-code package"
}

Step "Done"
Write-Host "Credentials gone. Verify: 'claude' should now ask you to log in again." -ForegroundColor Green
Write-Host "If you cloned the repo here, delete the folder too." -ForegroundColor Green
