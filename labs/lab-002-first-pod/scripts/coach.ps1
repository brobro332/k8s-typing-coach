# Kubernetes Interactive Typing Coach - Lab 002 (First Pod)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$LabDir = Split-Path -Parent $ScriptDir
$RootDir = Split-Path -Parent (Split-Path -Parent $LabDir)
$MetaPath = Join-Path $LabDir "meta.json"
$ProgressPath = Join-Path $RootDir "user-data\progress.json"

if (-not (Test-Path $MetaPath)) {
    Write-Host "❌ meta.json 파일을 찾을 수 없습니다: $MetaPath" -ForegroundColor Red
    exit 1
}

# 실습 시작 전 혹시 이전에 만든 my-first-pod가 남아있다면 정리
$Existing = kubectl get pod my-first-pod --ignore-not-found 2>$null
if ($Existing) {
    Write-Host "🧹 깔끔한 실습을 위해 이전 my-first-pod를 먼저 정리합니다..." -ForegroundColor DarkGray
    kubectl delete pod my-first-pod --force --grace-period=0 2>$null | Out-Null
}

$Meta = Get-Content $MetaPath -Raw -Encoding UTF8 | ConvertFrom-Json

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " 🏋️‍♂️ [K8s 타이핑 코치] $($Meta.title)" -ForegroundColor Yellow
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "💡 규칙: 복사-붙여넣기(Ctrl+V)는 금지입니다! 의미를 생각하며 한 글자씩 타이핑하세요." -ForegroundColor Gray
Write-Host "   (종료하려면 언제든 'exit'를 입력하세요)`n" -ForegroundColor Gray

$CopyPasteWarnings = 0
$TotalTyped = 0

foreach ($Drill in $Meta.typing_drills) {
    Write-Host "-----------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "🎯 $($Drill.prompt)" -ForegroundColor Green
    Write-Host "`n[단어 해부 & 발음 팁]" -ForegroundColor Magenta
    foreach ($Part in $Drill.anatomy) {
        Write-Host "  🔹 $($Part.part) " -NoNewline -ForegroundColor White
        Write-Host "($($Part.pronunciation_tip)) : $($Part.meaning)" -ForegroundColor Gray
    }
    Write-Host ""

    $Passed = $false
    while (-not $Passed) {
        Write-Host "⌨️  직접 타이핑 ❯ " -NoNewline -ForegroundColor Yellow
        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $UserInput = Read-Host
        $Stopwatch.Stop()

        $Trimmed = $UserInput.Trim()

        if ($Trimmed -eq "exit") {
            Write-Host "`n👋 타이핑 훈련을 잠시 중단합니다. 언제든 다시 실행하세요!" -ForegroundColor Cyan
            exit 0
        }

        if ([string]::IsNullOrWhiteSpace($Trimmed)) {
            continue
        }

        if ($Trimmed -ceq $Drill.target_text) {
            if ($Stopwatch.ElapsedMilliseconds -lt $Drill.min_typing_ms) {
                $CopyPasteWarnings++
                Write-Host "🚨 [복붙 감지 경보!] 입력 시간: $($Stopwatch.ElapsedMilliseconds)ms (기준: $($Drill.min_typing_ms)ms 이상)" -ForegroundColor Red
                Write-Host "   손가락 근육이 기억할 수 있도록 붙여넣기 말고 한 글자씩 직접 쳐보세요!`n" -ForegroundColor Yellow
                continue
            }

            $TotalTyped++
            $Sec = [math]::Round($Stopwatch.ElapsedMilliseconds / 1000.0, 1)
            Write-Host "✅ 정답입니다! (직접 타이핑 소요 시간: ${Sec}초)`n" -ForegroundColor Cyan
            Write-Host "--- [실제 쿠버네티스 실행 결과] ---" -ForegroundColor DarkCyan
            $CmdParts = $Trimmed -split '\s+'
            if ($CmdParts[0] -eq "kubectl") {
                & kubectl $CmdParts[1..($CmdParts.Length - 1)]
            }
            Write-Host "-----------------------------------`n" -ForegroundColor DarkCyan
            $Passed = $true
        }
        else {
            $FoundTypo = $false
            foreach ($Typo in $Drill.common_typos) {
                if ($Trimmed -eq $Typo.wrong) {
                    Write-Host "💡 [코치의 힌트] $($Typo.feedback)`n" -ForegroundColor Yellow
                    $FoundTypo = $true
                    break
                }
            }

            if (-not $FoundTypo) {
                Write-Host "❌ 앗, 조금 다릅니다! 내가 친 글자: [$Trimmed]" -ForegroundColor Red
                Write-Host "   위쪽의 [단어 해부] 조각들을 보면서 스펠링과 띄어쓰기를 다시 확인해 보세요!`n" -ForegroundColor Gray
            }
        }
    }
}

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " 🔍 [자동 채점기 작동] my-first-pod가 진짜 살아있는지 검사합니다..." -ForegroundColor Yellow
$PodStatus = kubectl get pod my-first-pod -o jsonpath='{.status.phase}' 2>$null
if ($PodStatus -eq "Running" -or $PodStatus -eq "Pending") {
    Write-Host " 🎉 [채점 통과: PASS!] 내 첫 번째 파드(my-first-pod)가 클러스터에 성공적으로 생성되었습니다! (상태: $PodStatus)" -ForegroundColor Green
} else {
    Write-Host " ⚠️ 파드 상태를 확인해 주세요: $PodStatus" -ForegroundColor Yellow
}
Write-Host "=================================================================`n" -ForegroundColor Cyan

if (Test-Path $ProgressPath) {
    $Progress = Get-Content $ProgressPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $Progress.typing_stats.total_commands_typed += $TotalTyped
    $Progress.typing_stats.copy_paste_warnings += $CopyPasteWarnings
    if ($Progress.completed_labs -notcontains $Meta.id) {
        $Progress.completed_labs += $Meta.id
    }
    $Progress.current_lab = "lab-003-yaml-manifest"
    foreach ($Kw in @("pods", "run", "--image=nginx", "describe", "pod")) {
        if ($Progress.typing_stats.mastered_keywords -notcontains $Kw) {
            $Progress.typing_stats.mastered_keywords += $Kw
        }
    }
    $Progress | ConvertTo-Json -Depth 5 | Set-Content $ProgressPath -Encoding UTF8
    Write-Host "📊 [DB 기록 완료] 나의 학습 진도(user-data/progress.json)가 자동 업데이트되었습니다!" -ForegroundColor Gray
}
