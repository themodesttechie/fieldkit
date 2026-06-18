<#
.SYNOPSIS
  New-laptop health report: OS, disk, RAM, battery, startup bloat, network.
.DESCRIPTION
  Read-only. Changes nothing. Prints a report and optionally saves to file.
#>
[CmdletBinding()]
param([string]$OutFile)

$ErrorActionPreference = 'SilentlyContinue'
$report = [System.Text.StringBuilder]::new()
function Line($s) { [void]$report.AppendLine($s); Write-Host $s }
function Head($s) { Line ""; Line "=== $s ===" }

Head "System"
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
Line ("Model    : {0} {1}" -f $cs.Manufacturer, $cs.Model)
Line ("OS       : {0} (build {1})" -f $os.Caption, $os.BuildNumber)
Line ("Uptime   : {0:dd}d {0:hh}h {0:mm}m" -f (New-TimeSpan -Start $os.LastBootUpTime))

Head "CPU / RAM"
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
Line ("CPU      : {0} ({1} cores)" -f $cpu.Name.Trim(), $cpu.NumberOfCores)
$ramGB  = [math]::Round($cs.TotalPhysicalMemory/1GB,1)
$freeGB = [math]::Round($os.FreePhysicalMemory/1MB,1)
Line ("RAM      : {0} GB total, {1} GB free" -f $ramGB, $freeGB)

Head "Disks"
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
    $tot = [math]::Round($_.Size/1GB,1)
    $fre = [math]::Round($_.FreeSpace/1GB,1)
    $pct = if ($_.Size) { [math]::Round(($_.FreeSpace/$_.Size)*100,0) } else { 0 }
    $flag = if ($pct -lt 10) { "  <-- LOW" } else { "" }
    Line ("{0}  {1} GB free / {2} GB ({3}% free){4}" -f $_.DeviceID, $fre, $tot, $pct, $flag)
}

Head "Battery"
$bat = Get-CimInstance Win32_Battery
if ($bat) { Line ("Charge   : {0}%  (status {1})" -f $bat.EstimatedChargeRemaining, $bat.BatteryStatus) }
else      { Line "No battery (desktop)" }

Head "Startup programs"
Get-CimInstance Win32_StartupCommand |
    Select-Object Name, Command |
    ForEach-Object { Line ("- {0}" -f $_.Name) }

Head "Network"
Get-NetIPConfiguration | Where-Object { $_.IPv4Address } | ForEach-Object {
    Line ("{0} : {1}" -f $_.InterfaceAlias, $_.IPv4Address.IPAddress)
}
$ping = Test-Connection 8.8.8.8 -Count 2 -Quiet
Line ("Internet : {0}" -f $(if ($ping) { "OK" } else { "NO REACH" }))

Head "Pending Windows Updates"
try {
    $session  = New-Object -ComObject Microsoft.Update.Session
    $searcher = $session.CreateUpdateSearcher()
    $pending  = $searcher.Search("IsInstalled=0").Updates.Count
    Line ("Pending  : {0} update(s)" -f $pending)
} catch { Line "Update check skipped (needs internet/admin)" }

if ($OutFile) {
    $report.ToString() | Out-File -FilePath $OutFile -Encoding utf8
    Write-Host "`nSaved report to $OutFile" -ForegroundColor Green
}
