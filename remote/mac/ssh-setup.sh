#!/usr/bin/env bash
# Option B setup (macOS). Opens secure remote access TO THIS Mac using Tailscale
# (encrypted mesh VPN, no port-forwarding) + the built-in Remote Login (SSH).
# Tear down with ssh-teardown.sh before you leave.
set -uo pipefail

say()  { printf "\n==> %s\n" "$1"; }
ok()   { printf "    [ok] %s\n" "$1"; }
have() { command -v "$1" >/dev/null 2>&1; }

say "1/3 Tailscale"
if have tailscale; then
  ok "tailscale present"
else
  have brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  [ -x /usr/local/bin/brew ]    && eval "$(/usr/local/bin/brew shellenv)"
  brew install tailscale
  sudo tailscaled install-system-daemon
  ok "tailscale installed"
fi

say "2/3 Enable Remote Login (SSH) + connect Tailscale (browser opens - log in to YOUR tailnet)"
sudo systemsetup -setremotelogin on
sudo tailscale up
ok "SSH enabled + tailscale up"

say "3/3 Connection details"
ip="$(tailscale ip -4 2>/dev/null | head -1)"
dns="$(tailscale status --json 2>/dev/null | /usr/bin/python3 -c 'import sys,json;print(json.load(sys.stdin)["Self"]["DNSName"].rstrip("."))' 2>/dev/null)"
user="$(whoami)"
echo
echo "From YOUR machine (Tailscale running, same account) connect with:"
echo "    ssh $user@$ip"
[ -n "$dns" ] && echo "    ssh $user@$dns"
echo
echo "(You'll be asked for THIS Mac account's password the first time.)"
echo "IMPORTANT: run ssh-teardown.sh before you leave to close access."
