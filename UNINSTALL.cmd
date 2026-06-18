@echo off
REM ============================================================
REM  Field Kit - ONE-CLICK end-of-session cleanup
REM  Removes Claude Code + credentials, and signs you out of
REM  Google + Claude in the browser. Run this before you leave.
REM ============================================================
echo Field Kit cleanup: removing Claude Code, wiping credentials,
echo and signing out of Google + Claude in your browser...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0uninstall-and-logout.ps1"
echo.
echo Confirm in the browser that you are SIGNED OUT of Google, then
echo delete this fieldkit folder.
pause
