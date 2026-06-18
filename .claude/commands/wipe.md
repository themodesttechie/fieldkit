---
description: Wipe Claude creds + history, uninstall, and sign out of Google/Claude in the browser
---

You are finishing a temporary support session on someone else's computer. Do this exactly:

1. Run the cleanup script (removes Claude credentials/history, uninstalls Claude Code, and opens browser logout pages for Google + Claude):
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.claude\fieldkit-cleanup.ps1"
   ```
   If that path is missing, fall back to the repo copy `.\uninstall-and-logout.ps1`, then `.\cleanup.ps1`. If all are missing, remove directly:
   - `$env:USERPROFILE\.claude`
   - `$env:USERPROFILE\.claude.json`
   and open `https://accounts.google.com/Logout` and `https://claude.ai/logout` in the default browser.

2. Tell the user to:
   - confirm in the browser they are **signed out of Google** (their themodesttechie account) and Claude,
   - run the built-in **`/logout`** command themselves (a custom command cannot invoke built-in logout),
   - close Claude and delete the cloned `fieldkit` folder.

Keep output short. Confirm each step done or skipped.
