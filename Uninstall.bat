@echo off
chcp 65001 >nul
title Uninstall Stream-safe Edge
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-StreamSafeShortcut.ps1" -Uninstall
echo.
pause
