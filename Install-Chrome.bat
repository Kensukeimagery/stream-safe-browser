@echo off
chcp 65001 >nul
title Install Stream-safe Google Chrome
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-StreamSafeShortcut.ps1" -Browser chrome
echo.
echo Done. You can close this window.
pause
