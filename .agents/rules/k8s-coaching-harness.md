---
trigger: always_on
description: k8s-typing-coach 프로젝트의 AI 코칭 철학, 작업 폴더 제한, Git 보안 수칙 및 데이터 아키텍처 하네스 규칙
---

# 🛡️ [k8s-typing-coach] AI 에이전트 하네스 규칙 (Harness Rules)

이 워크스페이스를 열거나 작업을 이어받는 모든 AI 에이전트는 아래의 **4대 절대 원칙**을 최우선으로 준수해야 합니다.

---

## 1. 🔒 작업 영역(Workspace) 접근 제한 원칙
- **절대 현재 워크스페이스 루트 폴더 외부의 디렉토리나 파일을 조회, 탐색, 수정하지 마십시오.**
- 모든 실습 가이드, 스크립트, 설정 파일, 로그는 오직 이 레포지토리 폴더 내부에서만 생성하고 관리합니다.

---

## 2. 🔐 Git 업로드 및 코드 보안 수칙 (Security-First)
이 프로젝트는 공개/원격 GitHub 레포지토리(`k8s-typing-coach`)로 관리되며 여러 PC에서 `pull` 받아 사용됩니다. 새로운 파일이나 스크립트를 만들 때 다음 보안 규칙을 엄격히 적용하십시오.

1. **로컬 절대 경로 및 개인 식별 정보(PII) 하드코딩 금지**
   - 마크다운 문서(`.md`), JSON, 스크립트(`.ps1`, `.bat`) 내부에 사용자의 로컬 드라이브 경로(예: `C:\Users\...`, `d:\...`), 컴퓨터 호스트네임, 윈도우 계정명, 개인 이니셜을 절대 적지 마십시오.
   - 모든 문서 간 링크는 **상대 경로**(예: `../../dictionary/concepts/concept-pod.md`)로 작성하여 로컬 에디터와 GitHub 웹뷰 양쪽에서 작동하게 하십시오.
   - 모든 스크립트 경로 참조는 `%~dp0`(배치 파일) 또는 `$MyInvocation.MyCommand.Path` / `$PSScriptRoot`(PowerShell) 기반의 **상대 경로**만 사용하십시오.
2. **PowerShell 스크립트 보안 (`Invoke-Expression` 사용 금지)**
   - `coach.ps1`, `verify.ps1` 등 모든 스크립트에서 명령어 주입(Command Injection) 취약점을 유발하는 `Invoke-Expression`을 절대 사용하지 마십시오.
   - 명령어 실행 시에는 반드시 입력값을 검증한 후 화이트리스트 방식(`& kubectl $CmdParts`)으로 안전하게 호출하십시오.
3. **터미널 출력 및 클러스터 민감 정보 파일 저장 금지**
   - `kubectl cluster-info`, `kubectl get nodes -o wide`, `kubectl get ... -o yaml` 등 클러스터 내부 IP, UID, 토큰이 포함된 출력 결과를 Git 추적 대상 파일로 저장하지 마십시오.
4. **쿠버네티스 인증 정보 및 Secret 보호**
   - `kubeconfig`, 인증서(`*.crt`, `*.key`), 실제 비밀번호가 담긴 `Secret` 매니페스트(Base64 인코딩 포함)는 절대 커밋하지 마십시오. 실습용 Secret은 반드시 더미 값(`dummy-password`)만 사용하고, 로컬 비밀 파일은 `.gitignore` 규칙(`*.secret.yaml`, `.env*`)에 매칭되게 명명하십시오.
5. **개인 진도 상태 분리 (`progress.json` vs `progress.template.json`)**
   - 개인 학습 통계 파일인 `user-data/progress.json`은 `.gitignore`로 제외되어 있습니다. 스키마 변경 시 반드시 `user-data/progress.template.json`을 함께 업데이트하십시오.

---

## 3. 🐣 초보자 맞춤형 '걸음마 & 근육 기억(Muscle Memory)' 코칭 철학
1. **비유 우선 & 3단계 다중 설명 레이어**
   - 개념을 설명할 때는 항상 **Lv.1(일상/식당 비유) -> Lv.2(실습 작동 원리) -> Lv.3(실무/면접 아키텍처 정의)** 순서로 구조화하십시오.
2. **복붙(Ctrl+C, Ctrl+V) 방지 및 직접 타이핑 유도**
   - 가이드 문서(`README.md`) 본문에 완성된 명령어를 복사하기 쉬운 단일 코드블록으로 던져주지 마십시오.
   - 반드시 **어절 해부표(Anatomy Table)**와 발음 팁을 통해 *"누구에게(`kubectl`) + 무슨 행동을(`run/get`) + 어떤 대상에게"* 어순을 이해하며 한 글자씩 직접 타이핑하도록 유도하십시오.
   - 향후 YAML 실습(`Step 3` 이후)에서도 완성본 대신 주석 힌트가 적힌 **빈칸 템플릿(`workspace/*.yaml`)**을 먼저 타이핑하게 하고, 정답(`solutions/*.yaml`)은 비교용으로만 분리하십시오.

---

## 4. 🗄️ DB화 및 코칭 프로그램 확장성 유지
- 사용자가 실습 중 던진 질문과 시행착오는 즉시 **`user-data/qna-history.jsonl`** 과 **`user-data/session-history.md`** 에 기록하여 향후 AI 튜터(RAG) 및 코칭 플랫폼 구축용 데이터셋으로 자산화하십시오.
- 모든 실습 모듈은 `schema/lab.schema.json` 규격(`meta.json` + `README.md` + `scripts/coach.ps1`)을 준수하여 생성하십시오.
