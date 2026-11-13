@echo off
chcp 65001 > nul
set "ROOT_DIR=%~dp0"
set "PROGRESS_FILE=%ROOT_DIR%user-data\progress.json"
set "TEMPLATE_FILE=%ROOT_DIR%user-data\progress.template.json"

if not exist "%PROGRESS_FILE%" (
    copy /Y "%TEMPLATE_FILE%" "%PROGRESS_FILE%" > nul
)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$root = '%ROOT_DIR%'; " ^
  "$stepArg = '%1'; " ^
  "$pPath = Join-Path $root 'user-data\progress.json'; " ^
  "$tPath = Join-Path $root 'tracks\beginner-roadmap.json'; " ^
  "$p = Get-Content $pPath -Raw -Encoding UTF8 | ConvertFrom-Json; " ^
  "$t = Get-Content $tPath -Raw -Encoding UTF8 | ConvertFrom-Json; " ^
  "if ($stepArg -ne '') { " ^
  "  $matched = $t.modules | Where-Object { $_.order -eq [int]$stepArg -or $_.lab_id -like \"*$stepArg*\" } | Select-Object -First 1; " ^
  "  if ($matched) { $p.current_lab = $matched.lab_id; $p | ConvertTo-Json -Depth 5 | Set-Content $pPath -Encoding UTF8; } " ^
  "} " ^
  "$lab = $p.current_lab; " ^
  "$scriptPath = Join-Path $root \"labs\$lab\scripts\coach.ps1\"; " ^
  "if (Test-Path $scriptPath) { & $scriptPath } else { Write-Host \"[안내] 아직 $lab 모듈이 준비되지 않았습니다.\" -ForegroundColor Yellow }"
