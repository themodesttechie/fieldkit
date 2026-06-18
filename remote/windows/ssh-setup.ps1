<#
.SYNOPSIS
  Option B setup (Windows). Opens secure remote access TO THIS machine using
  Tailscale (encrypted mesh VPN, no port-forwarding) + the built-in OpenSSH server.
.DESCRIPTION
  Run elevated (SSH-SETUP.cmd does that). Steps:
    1. install Tailscale
    2. enable + start OpenSSH server (+ firewall rule)
    3. tailscale up  -> browser opens, log in to YOUR tailnet
    4. print the exact ssh command to use from your own machine
  Tear down with ssh-teardown.ps1 before you leave.
#>
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
function Step($m) { Write-Host "`n==> $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "    [ok] $m" -ForegroundColor Green }
function Have($c) { [bool](Get-Command $c -ErrorAction SilentlyContinue) }

$tsExe = 'C:\Program Files\Tailscale\tailscale.exe'

Step "1/4 Tailscale"
if ((Have tailscale) -or (Test-Path $tsExe)) {
    Ok "tailscale present"
} else {
    winget install --id Tailscale.Tailscale -e --accept-source-agreements --accept-package-agreements --silent
    Ok "tailscale installed"
}

Step "2/4 OpenSSH Server"
$cap = Get-WindowsCapability -Online -Name OpenSSH.Server* | Select-Object -First 1
if ($cap.State -ne 'Installed') { Add-WindowsCapability -Online -Name $cap.Name | Out-Null }
Set-Service sshd -StartupType Automatic
Start-Service sshd
if (-not (Get-NetFirewallRule -Name 'sshd-fieldkit' -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name 'sshd-fieldkit' -DisplayName 'OpenSSH Server (fieldkit)' `
        -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 | Out-Null
}
Ok "sshd running + firewall allowed"

Step "3/4 Connect Tailscale (a browser will open - log in to YOUR tailnet)"
& $tsExe up
Ok "tailscale up"

Step "4/4 Connection details"
$ip   = (& $tsExe ip -4 | Select-Object -First 1)
$dns  = $null
try { $dns = ((& $tsExe status --json | ConvertFrom-Json).Self.DNSName).TrimEnd('.') } catch {}
$user = $env:USERNAME
Write-Host "`nFrom YOUR machine (Tailscale running, same account) connect with:" -ForegroundColor Yellow
Write-Host "    ssh $user@$ip"
if ($dns) { Write-Host "    ssh $user@$dns" }
Write-Host "`n(You'll be asked for THIS Windows account's password the first time.)"
Write-Host "IMPORTANT: run SSH-TEARDOWN.cmd before you leave to close access." -ForegroundColor Yellow
