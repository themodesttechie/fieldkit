# Field Kit

Portable tech-support kit for setting up / fixing someone else's Windows machine.
**Contains zero secrets — safe to put on a public repo, email, or USB stick.**

## What's inside
| File | Does |
|------|------|
| `INSTALL.cmd` | **One-click installer.** Double-click → installs Claude Code + Node + Git + essential apps + copies skills. |
| `bootstrap.ps1` | The actual installer (called by INSTALL.cmd). `-WhatIf` to dry-run, `-NoApps` to skip app installs. |
| `cleanup.ps1` | Wipes Claude creds + history off the machine. `-Uninstall` also removes Claude Code. |
| `scripts/diagnose.ps1` | Read-only laptop health report (disk/RAM/battery/startup/network/updates). |
| `scripts/debloat.ps1` | Removes Win11 junk apps. `-WhatIf` to preview first. |
| `skills/diagnose/` | Claude skill that runs + explains the health check for a non-technical owner. |
| `.claude/commands/wipe.md` | The `/wipe` slash command — one command to clean everything at the end. |

## Use it on a client machine
```powershell
git clone https://github.com/themodesttechie/fieldkit
cd fieldkit
# or just double-click INSTALL.cmd from a USB stick
```
1. Run `INSTALL.cmd` (one click, elevates to admin).
2. Run `claude`, log in with your Claude account.
3. Do the work (use `/diagnose` skill, run scripts, etc).
4. **When done, inside Claude run `/wipe`, then `/logout`.**
5. Delete the `fieldkit` folder.

## No internet / no git on their machine?
Put the whole `fieldkit` folder on a USB stick and run `INSTALL.cmd` from there.
`bootstrap.ps1` still installs Node/Git/Claude via winget (needs internet for downloads only).

## Safety
- Never log into Bitwarden / Gmail / business accounts on a client machine.
- `/wipe` + `/logout` removes your OAuth token. Treat the machine as untrusted afterwards.
- Scripts are read-only or idempotent; `debloat.ps1` and `bootstrap.ps1` support `-WhatIf`.
