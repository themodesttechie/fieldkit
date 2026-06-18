# Remote access (Option B) — Tailscale + SSH

Lets you work on the client machine **from your own machine**. Tailscale provides
a private encrypted link (no port-forwarding, no public exposure); SSH provides the
shell. Claude Code runs on **your** machine and drives the client box over `ssh`.

## How it works
1. **On the client machine** (run once, at the start): `SSH-SETUP.cmd` (Windows) or
   `ssh-setup.command` (Mac). It installs Tailscale, enables the SSH server, and runs
   `tailscale up` — a browser opens, you log in **to your own Tailscale account**.
   The client machine joins your tailnet temporarily and the script prints the exact
   `ssh user@...` line.
2. **On your machine**: have Tailscale installed + logged in to the same account.
   Run the printed `ssh user@<tailscale-name>` (enter the client account password once).
   Now Claude Code (on your machine) can run checks/fixes through that ssh connection.
3. **Before you leave** (run on the client machine): `SSH-TEARDOWN.cmd` /
   `ssh-teardown.command`. Logs out + removes Tailscale, disables SSH, removes keys.
   Then delete the device in https://login.tailscale.com/admin/machines.

## Files
| OS | Setup | Teardown |
|----|-------|----------|
| Windows | `windows/SSH-SETUP.cmd` | `windows/SSH-TEARDOWN.cmd` |
| macOS | `mac/ssh-setup.command` | `mac/ssh-teardown.command` |

## When to use which option
- **Option A (field kit local install)** — simplest, most capable, including GUI/app
  problems. Best default. Use this unless you must stay on your own machine.
- **Option B (this)** — you stay on your machine and tunnel into a *reachable* client
  box. Great for CLI/headless fixes. GUI fixes are limited (it's a shell, not a screen).

## Limits & safety
- SSH is a **terminal**, not a screen — no clicking through GUIs. For desktop-app issues
  use Option A.
- Windows: Tailscale's own SSH server isn't supported, so this uses the built-in OpenSSH
  server + Tailscale network. Password auth by default.
- **Always run teardown** + remove the device from your tailnet. Leaving SSH + Tailscale
  on means the machine stays reachable.
- Treat the client machine as untrusted afterwards.
