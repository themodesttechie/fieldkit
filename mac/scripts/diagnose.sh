#!/usr/bin/env bash
# macOS health report: model, OS, CPU/RAM, disk, battery, network, login items,
# pending updates. Read-only - changes nothing.
#   diagnose.sh [outfile]
set -uo pipefail

OUT="${1:-}"
[ -n "$OUT" ] && : > "$OUT"
line() { echo "$1"; [ -n "$OUT" ] && echo "$1" >> "$OUT"; }
sec()  { line ""; line "=== $1 ==="; }

sec "System"
line "Model    : $(sysctl -n hw.model 2>/dev/null)"
line "macOS    : $(sw_vers -productName) $(sw_vers -productVersion) ($(sw_vers -buildVersion))"
line "Uptime   : $(uptime | sed -E 's/.*up *//; s/, *[0-9]+ users.*//')"

sec "CPU / RAM"
line "CPU      : $(sysctl -n machdep.cpu.brand_string 2>/dev/null) ($(sysctl -n hw.ncpu) cores)"
line "RAM      : $(( $(sysctl -n hw.memsize) / 1073741824 )) GB total"

sec "Disk (/)"
df -h / | awk 'NR==2{printf "Free     : %s free of %s (%s used)\n",$4,$2,$5}' | while read -r l; do line "$l"; done

sec "Battery"
batt="$(pmset -g batt 2>/dev/null | grep -Eo '[0-9]+%' | head -1)"
line "Charge   : ${batt:-no battery (desktop)}"

sec "Network"
ip="$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)"
line "IP       : ${ip:-none}"
if ping -c 2 -t 3 8.8.8.8 >/dev/null 2>&1; then line "Internet : OK"; else line "Internet : NO REACH"; fi

sec "Login items (startup)"
items="$(osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null)"
if [ -n "$items" ]; then
  echo "$items" | tr ',' '\n' | sed 's/^ *//' | while read -r i; do [ -n "$i" ] && line "- $i"; done
else
  line "(none or permission denied)"
fi

sec "Pending updates"
upd="$(softwareupdate -l 2>&1 | grep -E '\* Label|No new software' | head -5)"
line "${upd:-check skipped}"

[ -n "$OUT" ] && echo "" && echo "Saved report to $OUT"
