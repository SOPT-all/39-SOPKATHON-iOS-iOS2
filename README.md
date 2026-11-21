# 39-SOPKATHON-iOS-iOS2
> PLAY SOPT 39기 iOS 2조 iOS 레포지토리 🍏

<br>

## 🧸 speakids: 어린이집 교사를 위한 돌봄 기록 서비스
<img width="800" src="https://github.com/user-attachments/assets/afffd247-d0d7-44a2-b4f1-d8b7349f04dc" />

### 개요
speakids는 20대 및 신규 부임 어린이집 교사가 아이별 돌봄 내용을 간편하게 기록하고, 하루 업무를 마친 뒤 학부모에게 일일 브리핑을 보낼 수 있도록 돕는 서비스 입니다.

<br>

### 핵심 메시지
> 여러 영유아를 돌보는 교사가 일상 중 기록을 빠르고 편하게 남겨 학부모와 돌봄 정보를 공유할 수 있도록 한다.

<br>

### 주요 내용
- 교사는 여러 아이를 담당하며, 학부모가 자녀의 관심과 돌봄 여부에 민감하게 반응하는 상황을 겪는다.
- 아이별 돌봄 내용을 일상에서 언제든 기록할 수 있도록 지원한다.
- 학부모 연락처를 서비스에 등록한 뒤 매일 기록을 작성한다.

<br>

## 🍎 iOS 팀원 소개

| <img src="https://github.com/user-attachments/assets/f68742e2-90d6-4d1d-87d9-a946cc3d1e3f" width="200"> | <img src="https://github.com/user-attachments/assets/6118a728-fb50-4996-bc13-e8aa1f7a299b" width="200"> | <img src="https://github.com/user-attachments/assets/61d4238d-8414-4190-b1cb-7e0141d7d4ad" width="200"> | <img src="https://github.com/user-attachments/assets/9f03e051-68cc-4a43-a927-bce3d56a0109" width="200"> |
| :---: | :---: | :---: | :---: |
| <b>[최주희(L)](https://github.com/dearosmar)</b> | <b>[이서영](https://github.com/amie-lee)</b> | <b>[김보민](https://github.com/bominnnkimmm)</b> | <b>[허다연](https://github.com/dxxeon)</b> |
| `돌봄 기록·음성 입력 및 공통 UI` | `일일 브리핑·메시지 발송` | `아이 등록·관리` | `홈 화면 및 공통 컴포넌트` |

<br>

## 🖼️ 시연 영상

| 음성 메모 | 워치 음성 주입 | 개별 문자 전송 | 아이 관리 |
|---|---|---|---|
|<video src="https://github.com/user-attachments/assets/db08ade0-6cd9-45f2-983d-d39d6d53ed7f">|<video src="https://github.com/user-attachments/assets/890c5c67-d6fc-4cc3-af93-d86b4e6998bd">|<video src="https://github.com/user-attachments/assets/1750d20d-381b-4392-84a8-64eb5faa7562">|<video src="https://github.com/user-attachments/assets/084dad72-c1d2-4192-b86e-1325dde25e50">|

<br>

### iOS 팀원 사진 
| Before | After |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/8308d35e-974a-4a04-88cf-ba283bb9c121" width="400"> | <img width="400" alt="after" src="https://github.com/user-attachments/assets/27d260f3-3483-46ec-ae11-08de654a9b8d" /> |

<br>



<br>

## 🛠 기술 스택
<div align="center">
  <img alt="SwiftUI" src="https://img.shields.io/badge/SwiftUI-0D96F6?style=for-the-badge&logo=swift&logoColor=white" />
  <img alt="UIKit" src="https://img.shields.io/badge/UIKit-2396F3?style=for-the-badge&logo=apple&logoColor=white" />
  <img alt="MVVM" src="https://img.shields.io/badge/MVVM-334155?style=for-the-badge" />
  <img alt="Alamofire" src="https://img.shields.io/badge/Alamofire-7C3AED?style=for-the-badge" />
  <br><br>
  <b>Apple Native Frameworks</b><br><br>
  <img alt="Speech" src="https://img.shields.io/badge/Speech-111827?style=for-the-badge&logo=apple&logoColor=white" />
  <img alt="AVFoundation" src="https://img.shields.io/badge/AVFoundation-111827?style=for-the-badge&logo=apple&logoColor=white" />
  <img alt="WatchConnectivity" src="https://img.shields.io/badge/WatchConnectivity-111827?style=for-the-badge&logo=apple&logoColor=white" />
  <img alt="UserNotifications" src="https://img.shields.io/badge/UserNotifications-111827?style=for-the-badge&logo=apple&logoColor=white" />
</div>

<br>

## 💡 주요 기능

#### ⌚️ 손목에서 바로 남기는 워치 음성 메모
폰을 꺼낼 틈이 없을 때는 애플워치로 기록해요. 버튼을 누르고 말하면 파형으로 녹음 상태를 보여 주고, 중간에 잠시 멈출 수도 있어요.
녹음을 마치면 아이폰으로 자동 전송되고, 아이폰이 백그라운드에서 글자로 바꿔 기록까지 저장합니다.
저장이 끝나면 "돌봄 기록이 저장됐어요. 지우 어린이" 알림으로 결과를 알려 줘서 폰을 열어 보지 않아도 돼요.

#### 🎙️ 말하면 기록이 되는 음성 메모
아이를 안은 채로도 기록할 수 있어요. 버튼 한 번 누르고 말하면 실시간으로 글자가 되고,
"지우가 점심을 다 먹었어요"처럼 문장 속 이름을 알아듣고 어느 아이의 기록인지 자동으로 골라 줍니다.
"지우랑 서준이가 낮잠을 잤어요"처럼 여러 아이를 한 번에 말해도 아이별로 따로 기록되고, 카테고리도 자동으로 분류돼요.
우리 반 아이 이름을 미리 알려 줘서 "서준이"처럼 성을 빼고 불러도 정확하게 알아들어요.

#### ✍️ 10초면 끝나는 돌봄 기록
아이를 고르고, 수유·식사·수면·배변·놀이·건강 중 카테고리를 누르고, 한 줄 적으면 끝.
바쁜 일과 중에도 흐름을 끊지 않고 남길 수 있도록 입력 단계를 최소화했습니다.

#### 🏠 오늘 하루가 한눈에 보이는 홈
아직 기록하지 않은 아이와 오늘 남긴 기록을 한 화면에서 확인해요.
누구를 놓쳤는지 바로 보이기 때문에 빠짐없이 챙길 수 있고, 홈에서 바로 음성 메모나 직접 기록을 시작할 수 있습니다.

#### 🤖 AI가 써 주는 일일 브리핑
하루 동안 쌓인 기록을 AI가 학부모에게 보낼 따뜻한 메시지로 정리해 줍니다.
"조금 더 짧게", "낮잠 이야기를 강조해서"처럼 원하는 방향을 말하면 그대로 다듬어 줘요.

#### 💬 문자 한 통으로 전하는 하루
완성된 브리핑은 등록해 둔 학부모 연락처와 내용이 채워진 문자 화면으로 바로 이어져요. 확인하고 보내기만 누르면 끝.
학부모는 별도 앱 설치 없이 평소 쓰던 문자로 아이의 하루를 받아 보고, 선생님은 어느 아이에게 보냈는지 한눈에 확인할 수 있어요.

#### 👶 우리 반 아이 관리
아이의 생년월일·성별, 학부모 연락처와 관계, 알레르기 같은 특이사항을 등록하고 이름으로 빠르게 찾아요.
등록한 정보는 언제든 수정할 수 있어요.


<br> 


## 🤝 Git Convention

### 🏷 작업 유형

브랜치, 커밋, 이슈, PR에 아래 유형을 사용합니다.

| 유형 | 사용 기준 |
|---|---|
| `feat` | 새로운 기능 구현 |
| `design` | 화면 및 UI 디자인 구현·변경 |
| `docs` | README, 템플릿 등 문서 수정 |
| `fix` | 일반적인 버그 수정 |
| `refactor` | 동작을 바꾸지 않는 코드 구조 개선 |
| `hotfix` | 즉시 수정해야 하는 치명적인 버그 |
| `chore` | 설정, 의존성 등 기타 유지보수 작업 |


<br>

### 🌿 브랜치 컨벤션

- 이슈를 만든 뒤 이슈 번호에 맞는 작업 브랜치를 만듭니다.
- 형식: `<유형>/#<이슈번호>-<작업내용>`
- 작업 내용은 짧은 영문 소문자와 하이픈으로 작성합니다.
- 예: `feat/#2-login-api`, `design/#3-home-view`
- 작업 시작 전 `main` 브랜치를 최신 상태로 갱신합니다.
- `develop` 브랜치는 사용하지 않습니다. 작업 브랜치에서 `main`으로 PR을 보냅니다.
  
<br>

### 📝 커밋 컨벤션

- 형식: `<유형>: #<이슈번호> <한글 요약>`
- 예: `feat: #2 로그인 API 연결`
- 유형은 소문자로, 요약은 한글로 작성합니다.
- 제목 전체를 50자 이내로 간결하게 작성합니다. 상세한 내용이 필요하면 본문에 적습니다.
- 서로 다른 목적의 변경은 커밋을 나눕니다.
- 빌드가 실패하는 상태로 커밋하지 않습니다.
- 사용자가 요청할 때만 커밋하고 푸시합니다.
- 커밋 메시지에 에이전트 관련 문구(Co-Authored-By, "Generated with ..." 등)를 넣지 않습니다.

 <br>

### 📌 이슈 컨벤션

- 제목 형식: `[유형] 작업 내용`
- 예: `[Feat] 로그인 API 연결`
- 템플릿의 제목 기본값은 `[Feat] `입니다. 다른 유형의 작업이면 머리말을 그 유형으로 바꿉니다. (`[Design] 홈 화면 구현`)
- 작업 유형 라벨과 담당자 라벨을 지정합니다. API 연결 작업에는 `API` 라벨도 지정합니다.
- 라벨의 첫 글자는 대문자로 작성합니다.
- 본문은 `.github/ISSUE_TEMPLATE/feature.md`의 구성을 그대로 사용합니다. 제목을 바꾸거나 섹션을 추가하지 않습니다.


<br>


## 📂 폴더 구조

```
├── docs/                         # 개발 문서
└── sopkathon-ios2/
    ├── sopkathon-ios2.xcodeproj/ # Xcode 프로젝트
    ├── sopkathon-ios2/           # iOS 앱
    │   ├── App/                  # 앱 진입점, 화면 이동, 의존성
    │   ├── Core/                 # 공통 디자인, 확장, 네트워크, 워치 연동, 알림
    │   ├── Feature/              # 기능별 화면과 로직
    │   └── Resource/             # 이미지, 폰트, 애니메이션, 앱 설정
    └── SopkathonWatch/           # watchOS 앱
        ├── App/                  # 워치 앱 진입점
        ├── Core/                 # 음성 녹음, 아이폰 전송
        └── Feature/              # 음성 메모 화면과 로직
```
