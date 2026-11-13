# 🤖 AGENTS.md — AI Coaching Harness & Context Guide

이 문서는 **`k8s-typing-coach`** 레포지토리를 다른 PC에서 `git clone` / `git pull` 받았을 때, AI 코칭 에이전트가 **이전 대화 맥락, 설계 철학, 보안 수칙, 현재 진도**를 100% 동일하게 이어받기 위한 **하네스(Harness) 마스터 문서**입니다.

---

## 📌 에이전트 필독 문서 (새로운 환경에서 세션을 시작할 때)
1. **하네스 핵심 규칙**: [`.agents/rules/k8s-coaching-harness.md`](./.agents/rules/k8s-coaching-harness.md)
2. **지금까지의 전체 대화 및 의사결정 히스토리**: [`user-data/session-history.md`](./user-data/session-history.md)
3. **초보자 질문/인사이트 DB (JSONL)**: [`user-data/qna-history.jsonl`](./user-data/qna-history.jsonl)
4. **전체 커리큘럼 로드맵**: [`tracks/beginner-roadmap.json`](./tracks/beginner-roadmap.json)

---

## 🛡️ 핵심 요약 (Core Guardrails)
1. **폴더 접근 제한**: 현재 워크스페이스 루트 폴더 외부의 파일이나 폴더는 절대 탐색하거나 수정하지 않는다.
2. **복붙 금지(Muscle Memory)**: 모든 명령어와 YAML은 학습자가 의미를 이해하며 손가락으로 직접 타이핑하도록 어절 해부표와 `coach.ps1`을 통해 코칭한다.
3. **보안 최우선(Security-First)**:
   - 모든 파일 내 로컬 절대 경로, 사용자 계정명/이니셜, 클러스터 IP/토큰 노출 엄금 (무조건 상대 경로 사용).
   - PowerShell 스크립트 내 `Invoke-Expression` 사용 엄금 (`& kubectl` 배열 인자 호출만 허용).
   - 터미널 출력 덤프, `kubeconfig`, 실제 `Secret` 파일은 `.gitignore`를 통해 원격 저장소 업로드 원천 차단.
4. **소통 스타일**: 사용자는 편하게 반말/단문으로 질문하거나 지시하며, 에이전트는 친절하고 명확한 코치 톤으로 핵심을 간결하게 안내한다.
