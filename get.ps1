<#
  Field Kit bootstrapper (Windows) - NO git required.
  Downloads the repo zip, extracts to the Desktop, launches the installer.
  Uses only built-in PowerShell (Invoke-WebRequest + Expand-Archive).

  Run on the client machine:
    irm https://raw.githubusercontent.com/themodesttechie/fieldkit/main/get.ps1 | iex
#>
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'   # faster download (no progress redraw)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$url  = 'https://github.com/themodesttechie/fieldkit/archive/refs/heads/main.zip'
$zip  = Join-Path $env:TEMP 'fieldkit.zip'
$stage= Join-Path $env:TEMP 'fieldkit-stage'
$dest = Join-Path $env:USERPROFILE 'Desktop\fieldkit'

Write-Host "Downloading Field Kit..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $url -OutFile $zip

if (Test-Path $stage) { Remove-Item -Recurse -Force $stage }
Expand-Archive -Path $zip -DestinationPath $stage -Force

if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
Move-Item (Join-Path $stage 'fieldkit-main') $dest -Force
Remove-Item $zip, $stage -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Saved to $dest" -ForegroundColor Green
Write-Host "Launching installer (approve the admin prompt)..." -ForegroundColor Cyan
Start-Process (Join-Path $dest 'INSTALL.cmd')
