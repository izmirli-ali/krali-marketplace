@echo off
setlocal
title KRALI ChatGPT Teshis

set "SCRIPT_DIR=%~dp0"
set "DIAGNOSTIC=%SCRIPT_DIR%Diagnose-KraliChatGPT.ps1"

if not exist "%DIAGNOSTIC%" (
  echo [KRALI] Diagnose-KraliChatGPT.ps1 ayni klasorde bulunamadi.
  echo Guncel paketi yeniden indirip klasore cikartin.
  pause
  exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%DIAGNOSTIC%"
exit /b %ERRORLEVEL%
