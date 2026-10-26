@echo off
chcp 65001 >nul
title Install Stream-safe (other browser)
if "%~1"=="" (
  echo Drag your browser's .exe file and drop it onto this file.
  echo See docs\install-browsers.en.md for how to find the .exe.
  pause
  exit /b 1
)
set "FLAG=--disable-features=HardwareSecureDecryption"
echo "%~1" | findstr /i "msedge" >nul && set "FLAG=--enable-features=msDisablePlayReadyHardwareDrm"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-StreamSafeShortcut.ps1" -Browser custom -ExePath "%~1" -Flag "%FLAG%"
echo.
echo Done. You can close this window.
pause
