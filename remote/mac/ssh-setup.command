#!/bin/bash
# One-click (macOS): open secure remote access to THIS Mac (Tailscale + SSH).
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Field Kit - remote access SETUP (macOS)"
bash "$DIR/ssh-setup.sh"
echo
echo "Press Return to close."
read -r _
