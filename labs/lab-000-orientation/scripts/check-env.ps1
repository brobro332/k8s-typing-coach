# 쿠버네티스 실습 사전 환경 자동 진단 스크립트 (check-env.ps1)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " 🔍 [Step 0-0] 내 컴퓨터 쿠버네티스 실습 환경 진단기" -ForegroundColor Yellow
Write-Host "=================================================================`n" -ForegroundColor Cyan

$AllGood = $true

# 1. kubectl 설치 여부 확인
Write-Host "1️⃣  무전기 (kubectl) 설치 확인 중... " -NoNewline
$KubectlCmd = Get-Command kubectl -ErrorAction SilentlyContinue
if ($null -ne $KubectlCmd) {
    $Ver = (kubectl version --client -o yaml 2>$null | Select-String "gitVersion").ToString().Trim()
    Write-Host "[✅ 설치됨!] ($Ver)" -ForegroundColor Green
} else {
    Write-Host "[❌ 미설치]" -ForegroundColor Red
    Write-Host "   👉 아직 컴퓨터에 kubectl(무전기)이 없거나, 설치 후 에디터를 재시작하지 않았습니다." -ForegroundColor Yellow
    $AllGood = $false
}

# 2. Docker 설치 여부 확인
Write-Host "2️⃣  밀키트 박스 도구 (Docker) 설치 확인 중... " -NoNewline
$DockerCmd = Get-Command docker -ErrorAction SilentlyContinue
if ($null -ne $DockerCmd) {
    Write-Host "[✅ 설치됨!]" -ForegroundColor Green
} else {
    Write-Host "[❌ 미설치]" -ForegroundColor Red
    Write-Host "   👉 Docker Desktop이 아직 설치되지 않았습니다." -ForegroundColor Yellow
    $AllGood = $false
}

# 3. 쿠버네티스 클러스터(주방) 켜져 있는지 확인
Write-Host "3️⃣  쿠버네티스 미니 주방 (Cluster) 작동 확인 중... " -NoNewline
if ($null -ne $KubectlCmd) {
    $Nodes = kubectl get nodes --request-timeout='3s' 2>$null
    if ($LASTEXITCODE -eq 0 -and $Nodes) {
        Write-Host "[✅ 정상 가동 중!]" -ForegroundColor Green
    } else {
        Write-Host "[⚠️ 꺼져 있음 (또는 준비 중)]" -ForegroundColor Yellow
        Write-Host "   👉 무전기는 있지만 주방(클러스터) 전원이 꺼져 있습니다!" -ForegroundColor Yellow
        Write-Host "   👉 Docker Desktop 실행 -> 우측 상단 톱니바퀴(Settings) -> Kubernetes -> [Enable Kubernetes] 체크 후 Apply를 눌러주세요." -ForegroundColor Gray
        $AllGood = $false
    }
} else {
    Write-Host "[⏸️ 무전기 설치 후 확인 가능]" -ForegroundColor DarkGray
}

Write-Host "`n=================================================================" -ForegroundColor Cyan
if ($AllGood) {
    Write-Host " 🎉 완벽합니다! 모든 사전 환경이 100% 준비되었습니다!" -ForegroundColor Green
    Write-Host " 👉 이제 터미널에 ./coach 를 입력해 첫 타이핑 훈련을 시작해 보세요!" -ForegroundColor Yellow
} else {
    Write-Host " 📖 설치가 필요한 항목이 있습니다!" -ForegroundColor Yellow
    Write-Host " 👉 왼쪽 파일 목록에서 labs/lab-000-orientation/INSTALL_GUIDE.md 파일을 열어" -ForegroundColor White
    Write-Host "    사전 환경 설치 가이드를 따라 설치를 진행해 주세요!" -ForegroundColor White
}
Write-Host "=================================================================`n" -ForegroundColor Cyan
