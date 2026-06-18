@echo off
REM One-click: open secure remote access to THIS machine (Tailscale + OpenSSH).
echo Field Kit - remote access SETUP (needs admin)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','\"%~dp0ssh-setup.ps1\"'"
echo An elevated window opened to do the setup.
pause
