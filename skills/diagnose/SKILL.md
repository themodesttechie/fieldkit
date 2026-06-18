---
name: diagnose
description: Run a full health check on a Windows laptop (disk, RAM, battery, startup bloat, network, pending updates) and explain findings in plain language. Use when setting up or troubleshooting a new/slow machine.
---

# Laptop Diagnose

When invoked, run the read-only health-check script and interpret the results for a non-technical owner.

## Steps
1. Detect the OS and run the matching diagnostic (it changes nothing). Locate the script under the cloned `fieldkit` folder.

   **Windows** — run `fieldkit\scripts\diagnose.ps1`:
   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File "<path>\fieldkit\scripts\diagnose.ps1"
   ```
   Add `-OutFile "$env:USERPROFILE\Desktop\health-report.txt"` to also save a copy.

   **macOS / Linux** — run `fieldkit/mac/scripts/diagnose.sh`:
   ```bash
   bash "<path>/fieldkit/mac/scripts/diagnose.sh" ~/Desktop/health-report.txt
   ```

2. Read the output and summarize for the owner:
   - Flag low disk (<10% free), low RAM headroom, lots of startup programs, no internet, or many pending updates.
   - Recommend concrete fixes (e.g. "12 startup apps slowing boot — disable these", "Drive C only 6% free — clear temp / move files").

3. Offer next actions: run `debloat.ps1` to remove junk apps, install essentials, or apply Windows updates.

Keep the explanation friendly and jargon-free — the laptop owner is not technical.
