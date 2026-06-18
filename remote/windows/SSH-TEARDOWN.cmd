@echo off
REM One-click: CLOSE the remote access (run before you leave).
echo Field Kit - remote access TEARDOWN (needs admin)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','\"%~dp0ssh-teardown.ps1\"'"
echo An elevated window opened to do the teardown.
pause
