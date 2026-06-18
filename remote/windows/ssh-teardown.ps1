<#
.SYNOPSIS
  Option B teardown (Windows). Closes the remote access opened by ssh-setup.ps1.
  Logs out + removes Tailscale, stops + disables OpenSSH server, drops firewall
  rule, removes any authorized_keys. Run elevated. Use -RemoveOpenSSH to also
  remove the OpenSSH Server feature entirely.
#>
[CmdletBinding()]
param([switch]$RemoveOpenSSH)
$ErrorActionPreference = 'SilentlyContinue'
function Step($m) { Write-Host "`n==> $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "    [done] $m" -ForegroundColor Green }

$tsExe = 'C:\Program Files\Tailscale\tailscale.exe'

Step "Disconnect + remove Tailscale"
if (Test-Path $tsExe) { & $tsExe logout; & $tsExe down }
winget uninstall --id Tailscale.Tailscale -e --silent
Ok "tailscale logged out + removed"

Step "Stop + disable OpenSSH server"
Stop-Service sshd
Set-Service sshd -StartupType Disabled
Get-NetFirewallRule -Name 'sshd-fieldkit' -ErrorAction SilentlyContinue | Remove-NetFirewallRule
Ok "sshd stopped + firewall rule removed"

Step "Remove any keys that were added"
foreach ($k in @("$env:ProgramData\ssh\administrators_authorized_keys", "$env:USERPROFILE\.ssh\authorized_keys")) {
    if (Test-Path $k) { Remove-Item -Force $k; Ok "removed $k" }
}

if ($RemoveOpenSSH) {
    Step "Removing OpenSSH Server feature"
    $cap = Get-WindowsCapability -Online -Name OpenSSH.Server* | Select-Object -First 1
    if ($cap.State -eq 'Installed') { Remove-WindowsCapability -Online -Name $cap.Name | Out-Null; Ok "OpenSSH Server feature removed" }
}

Step "Done - remote access closed."
Write-Host "Also remove this device from your Tailscale admin console: https://login.tailscale.com/admin/machines" -ForegroundColor Yellow
