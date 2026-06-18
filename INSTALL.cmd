@echo off
REM ============================================================
REM  Field Kit - one-click installer
REM  Double-click this file. It elevates to admin and runs
REM  bootstrap.ps1 (installs Claude Code + apps + skills).
REM ============================================================
echo Field Kit installer - requesting admin rights...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','\"%~dp0bootstrap.ps1\"'"
echo.
echo An elevated window opened to do the install. You can close this one.
pause
