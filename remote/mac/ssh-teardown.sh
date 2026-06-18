#!/usr/bin/env bash
# Option B teardown (macOS). Closes the remote access opened by ssh-setup.sh:
# logs out + removes Tailscale, disables Remote Login (SSH), removes added keys.
set -uo pipefail

say() { printf "\n==> %s\n" "$1"; }
ok()  { printf "    [done] %s\n" "$1"; }

say "Disconnect + remove Tailscale"
sudo tailscale logout 2>/dev/null
sudo tailscale down 2>/dev/null
sudo tailscaled uninstall-system-daemon 2>/dev/null
command -v brew >/dev/null 2>&1 && brew uninstall tailscale 2>/dev/null
ok "tailscale logged out + removed"

say "Disable Remote Login (SSH)"
sudo systemsetup -setremotelogin off
ok "SSH disabled"

say "Remove any keys that were added"
[ -f "$HOME/.ssh/authorized_keys" ] && rm -f "$HOME/.ssh/authorized_keys" && ok "removed authorized_keys"

say "Done - remote access closed."
echo "Also remove this device from your Tailscale admin console:"
echo "    https://login.tailscale.com/admin/machines"
