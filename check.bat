@echo off
chcp 65001 > nul
set "ROOT_DIR=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%ROOT_DIR%labs\lab-000-orientation\scripts\check-env.ps1"
