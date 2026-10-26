@echo off
chcp 65001 >nul
title Install Stream-safe Brave
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-StreamSafeShortcut.ps1" -Browser brave
echo.
echo Done. You can close this window.
pause
