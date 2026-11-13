# 🏋️‍♂️ k8s-typing-coach

> **"복붙(Ctrl+C, Ctrl+V) 금지! 식당 비유와 1:1 터미널 타이핑 코치로 밑바닥부터 손가락 근육(Muscle Memory)에 익히는 쿠버네티스 인터랙티브 학습 시스템"**

개념도 명령어도 하나도 모르는 완전 초심자가 쿠버네티스(Kubernetes, K8s)를 걸음마부터 배울 수 있도록 설계된 **모듈형 지식 그래프(DB) & 인터랙티브 타이핑 훈련 프로젝트**입니다.

---

## ✨ 핵심 특징 (Why `k8s-typing-coach`?)

1. **⌨️ 복붙 감지 & 오타 교정 1:1 타이핑 코치 (`coach.ps1`)**
   - 명령어를 복사-붙여넣기 하면 입력 속도(ms)를 감지해 경고를 띄우고, 초보자가 자주 내는 오타(`kubctl`, `ngnix` 등)를 감지해 맞춤형 피드백을 제공합니다.
2. **🍳 3단계 다중 설명 레이어 (식당 비유 ~ 실무 아키텍처)**
   - 모든 개념을 `Lv.1 걸음마 식당 비유` -> `Lv.2 실습 핵심 원리` -> `Lv.3 실무/면접용 정의` 3단계로 구조화했습니다.
3. **🗄️ 즉시 DB화 및 코칭 웹/앱 서비스 확장 가능 아키텍처**
   - 모든 실습(`labs/`), 개념 사전(`dictionary/`), 커리큘럼(`tracks/`)이 표준 JSON 스키마(`schema/`)와 Markdown Frontmatter로 분리되어 있어, 향후 AI 튜터(RAG)나 인터랙티브 교육 플랫폼으로 즉시 변환할 수 있습니다.

---

## 🚀 빠른 시작 (Quick Start)

1. **사전 환경 진단하기 (Docker & kubectl 확인)**
   ```powershell
   ./check
   ```
   *(미설치 항목이 있다면 `labs/lab-000-orientation/INSTALL_GUIDE.md`를 참고해 설치하세요.)*

2. **현재 단계의 1:1 타이핑 코치 실행하기**
   ```powershell
   ./coach
   ```

---

## 📂 폴더 구조 (Architecture)

```text
k8s-typing-coach/
├── check.bat                  # 1초 사전 환경 진단 실행기
├── coach.bat                  # 현재 진도 맞춤형 1:1 타이핑 코치 실행기
├── schema/                    # 실습(Lab) 및 개념(Concept) 표준 JSON 스키마
├── dictionary/                # 원자 단위로 분리된 개념(concepts) 및 명령어(commands) 카드
├── tracks/                    # 학습 목적별 커리큘럼 로드맵 JSON
├── labs/                      # 단계별 실습 모듈 (가이드 문서 + 메타데이터 + 코치 스크립트)
│   ├── lab-000-orientation/
│   ├── lab-001-cluster-check/
│   └── lab-002-first-pod/
└── user-data/                 # 학습자 진도 템플릿 및 초보자 실제 질문(FAQ) 데이터셋
```
