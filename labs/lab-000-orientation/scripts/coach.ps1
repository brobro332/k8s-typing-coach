# Kubernetes Interactive Typing Coach (Muscle Memory Builder)
# 복붙을 감지하고, 초보자의 오타를 친절하게 교정해 주는 1:1 타이핑 코치 스크립트입니다.

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

        # 1. 정답 확인
        if ($Trimmed -ceq $Drill.target_text) {
            # 복붙 감지 (최소 입력 시간보다 빠르면 경고)
            if ($Stopwatch.ElapsedMilliseconds -lt $Drill.min_typing_ms) {
                $CopyPasteWarnings++
                Write-Host "🚨 [복붙 감지 경보!] 입력 시간: $($Stopwatch.ElapsedMilliseconds)ms (기준: $($Drill.min_typing_ms)ms 이상)" -ForegroundColor Red
                Write-Host "   손가락 근육이 기억할 수 있도록 붙여넣기 말고 한 글자씩 직접 쳐보세요!`n" -ForegroundColor Yellow
                continue
            }

            $TotalTyped++
            $Sec = [math]::Round($Stopwatch.ElapsedMilliseconds / 1000.0, 1)
            Write-Host "✅ 정답입니다! (직접 타이핑 소요 시간: ${Sec}초) 손가락이 기억하기 시작했어요!`n" -ForegroundColor Cyan
            $Passed = $true
        }
        else {
            # 2. 흔한 오타 피드백 검색
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
Write-Host " 🎉 축하합니다! 이 모듈의 모든 타이핑 훈련을 통과하셨습니다!" -ForegroundColor Green
Write-Host " 🚀 이제 실제로 명령어를 실행해 볼까요? 아래에 마지막으로 한 번 더 쳐서 실제 결과를 확인합니다!" -ForegroundColor Yellow
Write-Host "=================================================================`n" -ForegroundColor Cyan

# 실제 명령어 실행 단계
$FinalCmd = $Meta.missions[0].answer_command
Write-Host "⚡ 실제 실행할 명령어: $($FinalCmd) 를 직접 쳐보세요!" -ForegroundColor Green
Write-Host "💻 터미널 실행 ❯ " -NoNewline -ForegroundColor Cyan
$FinalInput = (Read-Host).Trim()

if ($FinalInput -eq $FinalCmd) {
    Write-Host "`n--- [실제 쿠버네티스 무전기 응답 결과] ---" -ForegroundColor DarkCyan
    $CmdParts = $FinalCmd -split '\s+'
    if ($CmdParts[0] -eq "kubectl") {
        & kubectl $CmdParts[1..($CmdParts.Length - 1)]
    }
    Write-Host "------------------------------------------`n" -ForegroundColor DarkCyan
} else {
    Write-Host "`n직접 실행해 보시려면 터미널에 $FinalCmd 를 입력해 보세요!" -ForegroundColor Yellow
}

# 진도율 데이터(progress.json) 자동 업데이트
if (Test-Path $ProgressPath) {
    $Progress = Get-Content $ProgressPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $Progress.typing_stats.total_commands_typed += $TotalTyped
    $Progress.typing_stats.copy_paste_warnings += $CopyPasteWarnings
    if ($Progress.completed_labs -notcontains $Meta.id) {
        $Progress.completed_labs += $Meta.id
    }
    $Progress.current_lab = "lab-001-cluster-check"
    $Progress | ConvertTo-Json -Depth 5 | Set-Content $ProgressPath -Encoding UTF8
    Write-Host "📊 [DB 기록 완료] 나의 학습 진도(user-data/progress.json)가 자동 업데이트되었습니다!" -ForegroundColor Gray
}
