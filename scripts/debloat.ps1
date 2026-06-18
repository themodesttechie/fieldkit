<#
.SYNOPSIS
  Remove common Windows 11 pre-installed bloat. Conservative list.
.DESCRIPTION
  Uninstalls per-user UWP junk. Skips anything system-critical.
  Use -WhatIf first to preview. Nothing is removed in -WhatIf mode.
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$bloat = @(
    'Microsoft.3DBuilder',
    'Microsoft.BingNews',
    'Microsoft.BingWeather',
    'Microsoft.GetHelp',
    'Microsoft.Getstarted',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.People',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.XboxApp',
    'Microsoft.XboxGameOverlay',
    'Microsoft.XboxGamingOverlay',
    'Microsoft.ZuneMusic',
    'Microsoft.ZuneVideo',
    'Clipchamp.Clipchamp',
    'Microsoft.Todos',
    'MicrosoftTeams'
)

Write-Host "Debloat: removing per-user junk apps. Core apps untouched." -ForegroundColor Yellow

foreach ($name in $bloat) {
    $pkg = Get-AppxPackage -Name $name -ErrorAction SilentlyContinue
    if (-not $pkg) { continue }
    if ($PSCmdlet.ShouldProcess($name, "Remove-AppxPackage")) {
        try {
            $pkg | Remove-AppxPackage -ErrorAction Stop
            Write-Host "  [removed] $name" -ForegroundColor Green
        } catch {
            Write-Host "  [skip] $name - $($_.Exception.Message)" -ForegroundColor DarkYellow
        }
    } else {
        Write-Host "  [would remove] $name" -ForegroundColor Cyan
    }
}

Write-Host "`nDone. Reboot recommended." -ForegroundColor Green
