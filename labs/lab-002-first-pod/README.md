---
id: "lab-002-first-pod"
title: "Step 2. 첫 번째 1인용 주방 방(Pod) 만들고 요리사(nginx) 넣기"
level: 1
estimated_minutes: 15
prerequisites: ["lab-001-cluster-check"]
concepts: ["concept-pod", "concept-image", "cmd-kubectl-run"]
---

# 🫛 Step 2. 내 첫 번째 주방 방(Pod) 만들고 요리사 투입하기!

드디어 진짜 쿠버네티스 실습의 꽃입니다!
`Step 1`에서 우리 주방 컴퓨터(`nodes`)가 `Ready` 상태인 걸 확인했으니, 이제 그 땅 위에 **내 생애 첫 번째 1인용 주방 방(`Pod`)을 짓고 웹 서버 요리사(`nginx`)를 출근**시켜 봅시다!

---

## 📖 1교시: 오늘 배울 핵심 개념 2가지 + 새 동사 2가지

1. **[파드 (Pod)](../../dictionary/concepts/concept-pod.md)** = **'요리사가 들어가서 일하는 1인용 방 (콩깍지)'**
   - 쿠버네티스는 요리사(컨테이너)를 반드시 **파드(Pod)**라는 방 안에 넣어서 관리합니다.
2. **[이미지 (Image)와 nginx](../../dictionary/concepts/concept-image.md)** = **'요리사 원본 설계도 (`nginx` = 웹 서버 요리사)'**
   - `--image=nginx`라고 지정하면 인터넷 창고에서 `nginx` 웹 서버 요리사를 자동으로 데려옵니다.
3. **[kubectl run & describe](../../dictionary/commands/cmd-kubectl-run.md)**
   - **`run`** : 새 파드를 당장 만들어서 돌려라!
   - **`describe`** : 돋보기로 그 방의 상세 이력서(CCTV 이벤트 기록)를 자세히 보여줘!

---

## ⌨️ 2교시: 손가락 근육 기억 (Typing Anatomy)

오늘 타이핑 코치와 함께 연습할 4단계 문장입니다!

### ① 지금 있는 파드(방) 목록 확인하기
| 1어절 (무전기) | 2어절 (가져와라) | 3어절 (파드들을) | 뜻 |
| :---: | :---: | :---: | :--- |
| `kubectl` | `g` `e` `t` | `p` `o` `d` `s` | 지금 우리 식당에 파드(`pods`)가 몇 개 있는지 목록을 가져와 봐! *(처음엔 아무것도 없어서 `No resources found`라고 나옵니다!)* |

### ② 내 첫 번째 파드(`my-first-pod`) 만들고 요리사(`nginx`) 넣기 ⭐
| 1어절 (무전기) | 2어절 (동사: 돌려라) | 3어절 (내가 지어줄 방 이름) | 4어절 (어떤 요리사 이미지?) |
| :---: | :---: | :---: | :---: |
| `kubectl` | `r` `u` `n` | `m` `y` `-` `f` `i` `r` `s` `t` `-` `p` `o` `d` | `-` `-` `i` `m` `a` `g` `e` `=` `n` `g` `i` `n` `x` |
- **어순 뜻**: *"지배인아(`kubectl`), 새로 만들어서 돌려라(`run`), 방 이름은 `my-first-pod`이고, 요리사 설계도는 엔진엑스(`--image=nginx`)를 써라!"*
- **주의할 점**: `nginx` 스펠링은 **`n-g-i-n-x`** 입니다! (`ngnix`로 오타 주의!)

### ③ 방이 잘 만들어졌는지 다시 확인하기
- 아까 1번에서 쳤던 **`kubectl get pods`** 를 한 번 더 칩니다!
- 이제 `No resources found` 대신 **`my-first-pod`**가 짠! 하고 나타나고, 상태(`STATUS`)가 `ContainerCreating`(방 꾸미는 중)에서 **`Running`(영업 중!)**으로 바뀝니다!

### ④ 돋보기로 방 안의 상세 기록(`describe`) 들여다보기
| 1어절 (무전기) | 2어절 (동사: 상세히 설명해라) | 3어절 (종류: 파드) | 4어절 (방 이름) |
| :---: | :---: | :---: | :---: |
| `kubectl` | `d` `e` `s` `c` `r` `i` `b` `e` | `p` `o` `d` | `m` `y` `-` `f` `i` `r` `s` `t` `-` `p` `o` `d` |
- 결과 맨 아래쪽에 **`Events:`** 라는 표가 나옵니다. 지배인이 몇 초 전에 인터넷에서 `nginx`를 다운받고 방을 열었는지 CCTV처럼 다 찍혀 있어요!

---

## 🎮 3교시: 타이핑 코치 출발! (`./coach`)

준비가 되셨다면 아래쪽 터미널 창에 똑같이 쳐보세요! (이제 자동으로 `Step 2` 코치가 열립니다!)

> **타이핑할 글자**: `.` `/` `c` `o` `a` `c` `h` 그리고 **엔터(Enter)!**
