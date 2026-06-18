#!/bin/bash
# Field Kit - ONE-CLICK end-of-session cleanup (macOS). Double-click in Finder.
# Uninstalls Claude Code, wipes credentials, signs you out of Google + Claude.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Field Kit cleanup (macOS): removing Claude Code, wiping credentials,"
echo "and signing out of Google + Claude in your browser..."
echo
bash "$DIR/uninstall-and-logout.sh"
echo
echo "Confirm you are SIGNED OUT of Google, then delete the fieldkit folder."
echo "Press Return to close."
read -r _
