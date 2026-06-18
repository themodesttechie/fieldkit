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
| `skills/markitdown/` | Convert PDF/Word/PPT/Excel/images/HTML → clean Markdown (Microsoft tool). |
| `skills/docx`, `pdf`, `pptx`, `xlsx` | Create + edit Office documents (from anthropics/skills, official). |
| `.claude/commands/wipe.md` | The `/wipe` slash command — one command to clean everything at the end. |

### Where the bundled skills came from
- `diagnose` — built for this kit.
- `markitdown` — copied from local install (Microsoft MarkItDown CLI wrapper).
- `docx` / `pdf` / `pptx` / `xlsx` — official [anthropics/skills](https://github.com/anthropics/skills) (vetted, no third-party code).

Only reputable, secret-free skills are bundled. Random public-repo skills are **not** added — a skill is instructions Claude executes, so an untrusted one is a prompt-injection / supply-chain risk on a client machine.

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
