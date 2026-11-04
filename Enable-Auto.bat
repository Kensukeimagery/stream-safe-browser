@echo off
chcp 65001 >nul
title Stream-safe: start Edge in Stream-safe mode automatically
echo.
echo This makes EVERY normal way of opening Edge use the stream-safe flags.
echo You will see a preview of every change before anything is applied.
echo Undo at any time with Disable-Auto.bat.
echo.
echo Mode:  1 = standard (hardware DRM off)
echo        2 = compat   (also turns off DirectComposition video overlays; use if screen share is still black)
choice /c 12 /n /m "Choose 1 or 2: "
if errorlevel 2 (set "MODE=compat") else (set "MODE=standard")
echo.
choice /c YN /n /m "Also cover links opened from other apps (Discord, LINE...)? [Y/N]: "
set "LINKS="
if not errorlevel 2 set "LINKS=-IncludeLinks"
echo.
echo ===== Preview: what would be changed (nothing is changed yet) =====
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Enable-AutoStreamSafe.ps1" -Mode %MODE% %LINKS% -WhatIf
echo.
choice /c YN /n /m "Apply these changes? [Y/N]: "
if errorlevel 2 (echo Cancelled. Nothing was changed. & pause & exit /b 0)
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Enable-AutoStreamSafe.ps1" -Mode %MODE% %LINKS%
echo.
pause
