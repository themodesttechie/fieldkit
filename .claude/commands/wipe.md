---
description: Wipe Claude creds + history, uninstall, and sign out of Google/Claude in the browser
---

You are finishing a temporary support session on someone else's computer. Detect the OS and run the matching cleanup, which removes Claude credentials/history, uninstalls Claude Code, and opens browser logout pages for Google + Claude.

**On Windows:**
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.claude\fieldkit-cleanup.ps1"
```
Fallbacks if missing: repo `.\uninstall-and-logout.ps1`, then `.\cleanup.ps1`.

**On macOS / Linux:**
```bash
bash "$HOME/.claude/fieldkit-cleanup.sh"
```
Fallback if missing: repo `mac/uninstall-and-logout.sh`.

If no script is found, remove `~/.claude` and `~/.claude.json` directly, then open `https://accounts.google.com/Logout` and `https://claude.ai/logout` in the default browser.

Then tell the user to:
- confirm in the browser they are **signed out of Google** (their themodesttechie account) and Claude,
- run the built-in **`/logout`** command themselves (a custom command cannot invoke built-in logout),
- close Claude and delete the cloned `fieldkit` folder.

Keep output short. Confirm each step done or skipped.
