@echo off
chcp 65001 >nul
title Install Stream-safe Edge (compat mode)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-StreamSafeShortcut.ps1" -Browser edge -Mode compat
echo.
echo Done. You can close this window.
pause
