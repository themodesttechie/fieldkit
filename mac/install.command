#!/bin/bash
# Field Kit - one-click installer (macOS). Double-click in Finder.
# (If macOS blocks it: right-click -> Open, or run the xattr line in README.)
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Field Kit installer (macOS)"
bash "$DIR/bootstrap.sh"
echo
echo "Press Return to close."
read -r _
