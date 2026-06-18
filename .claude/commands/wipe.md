---
description: Wipe Claude Code creds + history off this machine, then log out
---

You are finishing a temporary support session on someone else's computer. Do this exactly:

1. Run the cleanup script to remove all Claude credentials, session history, MCP config, and copied skills:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.claude\fieldkit-cleanup.ps1"
   ```
   If that path is missing, fall back to the repo copy at `.\cleanup.ps1`, and if that is also missing, remove these directly:
   - `$env:USERPROFILE\.claude`
   - `$env:USERPROFILE\.claude.json`

2. Tell the user the credentials are wiped and that they must now run the built-in **`/logout`** command themselves (a custom command cannot invoke the built-in logout), then close Claude.

3. Remind them to delete the cloned `fieldkit` folder if it is still on disk.

Keep output short. Confirm each step done or skipped.
