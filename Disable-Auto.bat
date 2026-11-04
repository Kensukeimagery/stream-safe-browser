@echo off
chcp 65001 >nul
title Stream-safe: undo automatic mode
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Enable-AutoStreamSafe.ps1" -Disable
echo.
echo Done. Edge is back to normal.
pause
