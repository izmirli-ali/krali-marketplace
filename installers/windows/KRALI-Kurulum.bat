@echo off
setlocal
title KRALI ChatGPT Kurulumu

set "SCRIPT_DIR=%~dp0"
set "INSTALLER=%SCRIPT_DIR%Install-KraliChatGPT.ps1"

if not exist "%INSTALLER%" (
  echo [KRALI] Install-KraliChatGPT.ps1 ayni klasorde bulunamadi.
  echo Kurulum paketini yeniden cikartip tekrar deneyin.
  pause
  exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%INSTALLER%"
exit /b %ERRORLEVEL%
