@echo off
chcp 65001 >nul
title Uninstall Stream-safe shortcuts
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-StreamSafeShortcut.ps1" -Uninstall -Browser edge
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-StreamSafeShortcut.ps1" -Uninstall -Browser chrome
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-StreamSafeShortcut.ps1" -Uninstall -Browser brave
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-StreamSafeShortcut.ps1" -Uninstall -Browser vivaldi
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-StreamSafeShortcut.ps1" -Uninstall -Browser edge -Mode compat
echo.
echo Done. For "other browser" shortcuts use Uninstall-Other-Browser.bat.
pause
