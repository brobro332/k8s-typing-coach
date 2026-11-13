---
id: "cmd-kubectl-run"
command: "kubectl run"
category: "cli"
difficulty: 1
---

# 🏃‍♂️ `kubectl run` & `kubectl describe` : 방 만들고 돋보기로 관찰하기!

## 1. `kubectl run` : "새 파드(방) 하나 당장 만들어서 돌려라!"
쿠버네티스 지배인에게 가장 빠르게 파드(Pod) 1개를 즉석에서 만들라고 시키는 동사입니다.

### 어순 공식
> **`kubectl`** (지배인아) + **`run`** (달리게 해라/만들어라) + **`[내가 지어줄 방 이름]`** + **`--image=[요리사 종류]`**

* 예시: `kubectl run my-first-pod --image=nginx`
  - 뜻: *"지배인아, `my-first-pod`라는 이름으로 방을 하나 만들고, 그 안에 `nginx` 요리사를 넣어서 바로 돌려라!"*

---

## 2. `kubectl describe` : "돋보기로 이 방의 속사정을 아주 자세히 설명해 봐!"
`kubectl get pods`는 한 줄짜리 **요약 표**만 보여줍니다.
만약 방이 왜 안 켜지는지, 방 안에서 지배인이 무슨 작업(다운로드 -> 생성 -> 시작)을 했는지 **상세 이력서(CCTV 기록)**를 보고 싶을 때 쓰는 동사가 바로 **`describe` (디스크라이브, 묘사하다/상세히 설명하다)**입니다!

### 어순 공식
> **`kubectl`** (지배인아) + **`describe`** (상세히 설명해 봐) + **`pod`** (파드 중에서) + **`[방 이름]`**

* 예시: `kubectl describe pod my-first-pod`
  - 출력 결과 맨 아래쪽에 나오는 **`Events:` (이벤트 로그)** 칸을 보면, 지배인이 인터넷에서 `nginx`를 다운받고(`Pulling`), 방을 만들고(`Created`), 요리사를 출근시킨(`Started`) 시간별 기록이 전부 적혀 있습니다!
