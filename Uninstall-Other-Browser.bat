@echo off
chcp 65001 >nul
title Uninstall Stream-safe (other browser)
if "%~1"=="" (
  echo Drag the same browser .exe you used for install onto this file.
  pause
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-StreamSafeShortcut.ps1" -Uninstall -Browser custom -ExePath "%~1" -Flag x
echo.
pause
