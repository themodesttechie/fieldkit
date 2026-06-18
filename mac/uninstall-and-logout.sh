#!/usr/bin/env bash
# Field-kit end-of-session cleanup (macOS).
#  - removes Claude Code credentials + history
#  - uninstalls Claude Code
#  - signs you OUT of Google + Claude in the default browser (kills OAuth session)
set -uo pipefail

say()  { printf "\n==> %s\n" "$1"; }
ok()   { printf "    [done] %s\n" "$1"; }

echo "FIELD KIT - end-of-session cleanup (macOS)"

say "Removing Claude credentials + history"
rm -rf "$HOME/.claude" "$HOME/.claude.json" "$HOME/.claude.json.backup" 2>/dev/null
ok "credential + data paths removed"

KEEP="${1:-}"
if [ "$KEEP" != "--keep-claude" ]; then
  say "Uninstalling Claude Code"
  npm uninstall -g @anthropic-ai/claude-code >/dev/null 2>&1
  ok "Claude Code removed (if it was installed)"
fi

say "Signing out of Google + Claude in the default browser"
# Google logout URL signs out ALL Google accounts in that browser profile.
open "https://accounts.google.com/Logout" 2>/dev/null
sleep 2
open "https://claude.ai/logout" 2>/dev/null
ok "opened logout pages - CONFIRM in browser they show 'signed out'"

say "Done"
cat <<'EOF'

CHECK BEFORE YOU LEAVE:
  - new terminal, type:  claude   -> should be "command not found"
  - browser shows you SIGNED OUT of Google (themodesttechie) and Claude
  - delete the fieldkit folder
EOF
