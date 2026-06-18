#!/usr/bin/env bash
# Field-kit bootstrap (macOS). Installs Homebrew, Node, Git, Claude Code,
# essential apps, and copies skills. Safe to re-run. No secrets baked in.
#   --no-apps   skip the brew app installs
set -uo pipefail

say()  { printf "\n==> %s\n" "$1"; }
ok()   { printf "    [ok] %s\n" "$1"; }
warn() { printf "    [warn] %s\n" "$1"; }
have() { command -v "$1" >/dev/null 2>&1; }

NO_APPS="${1:-}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/.." && pwd)"

say "Field kit bootstrap (macOS)"

# 1. Homebrew ----------------------------------------------------------
if have brew; then
  ok "brew present"
else
  say "Installing Homebrew (may prompt for your password)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon
  [ -x /usr/local/bin/brew ]    && eval "$(/usr/local/bin/brew shellenv)"      # Intel
fi

# 2. Node + Git --------------------------------------------------------
say "Node + Git"
have node || brew install node
have git  || brew install git
ok "node $(node --version 2>/dev/null) / git $(git --version 2>/dev/null | awk '{print $3}')"

# 3. Claude Code -------------------------------------------------------
say "Claude Code"
if have claude; then
  ok "claude present: $(claude --version 2>/dev/null)"
elif have npm; then
  npm install -g @anthropic-ai/claude-code && ok "claude installed"
else
  warn "npm missing; reopen terminal then: npm install -g @anthropic-ai/claude-code"
fi

# 4. Essential apps ----------------------------------------------------
if [ "$NO_APPS" != "--no-apps" ]; then
  say "Essential apps (brew --cask)"
  for app in google-chrome vlc the-unarchiver rectangle; do
    if brew install --cask "$app" >/dev/null 2>&1; then ok "$app"; else warn "$app skipped"; fi
  done
else
  warn "Skipping app installs (--no-apps)"
fi

# 5. Skills + /wipe command -------------------------------------------
say "Install skills + /wipe command"
CL="$HOME/.claude"
mkdir -p "$CL/skills" "$CL/commands"
[ -d "$REPO/skills" ]          && cp -R "$REPO/skills/." "$CL/skills/"        && ok "skills copied"
[ -d "$REPO/.claude/commands" ] && cp -R "$REPO/.claude/commands/." "$CL/commands/" && ok "/wipe copied"
[ -f "$HERE/uninstall-and-logout.sh" ] && cp "$HERE/uninstall-and-logout.sh" "$CL/fieldkit-cleanup.sh" && ok "cleanup staged for /wipe"

say "Done"
cat <<'EOF'

NEXT:
  1. claude
  2. log in with your Claude account (browser OAuth)
  3. do the work
  4. when finished:  /wipe   then  /logout
EOF
