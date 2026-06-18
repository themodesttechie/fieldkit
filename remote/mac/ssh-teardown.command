#!/bin/bash
# One-click (macOS): CLOSE the remote access (run before you leave).
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Field Kit - remote access TEARDOWN (macOS)"
bash "$DIR/ssh-teardown.sh"
echo
echo "Press Return to close."
read -r _
