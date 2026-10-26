@echo off
chcp 65001 >nul
title Install Stream-safe Vivaldi
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-StreamSafeShortcut.ps1" -Browser vivaldi
echo.
echo Done. You can close this window.
pause
