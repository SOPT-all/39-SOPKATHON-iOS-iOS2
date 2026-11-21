# AGENTS.md

sopkathon-ios2에서 작업하는 코딩 에이전트가 따라야 하는 규칙입니다. 팀원마다 다른 에이전트를 써도 같은 모양의 코드가 나오게 하는 것이 목적입니다.

## 1. 프로젝트 정보

- SwiftUI 앱, 최소 iOS 17.0, Swift 5 언어 모드
- 구조: MVVM, 기능(Feature) 단위 폴더
- 라이브러리: Alamofire(통신), Kingfisher(이미지)
- 기본 actor 격리가 `MainActor`입니다(`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`). View, ViewModel, Service에 `@MainActor`를 붙이거나 `DispatchQueue.main`, `MainActor.run`으로 감싸지 않습니다.
- Xcode 폴더 동기화 방식입니다. 파일을 폴더에 만들면 자동으로 타깃에 포함되므로 `project.pbxproj`를 수정하지 않습니다.
- `Config.xcconfig`는 git에서 제외된 파일이고 없으면 빌드가 실패합니다. 이 파일을 만들거나 커밋하지 않고, 없으면 사용자에게 알립니다.
- 네트워크 레이어 사용법은 `docs/NetworkLayer.md`에 있습니다. API를 붙이기 전에 읽습니다.

## 2. 빌드 확인

작업을 끝냈다고 말하기 전에 아래 명령으로 빌드가 성공하는지 확인합니다.

```bash
xcodebuild -project sopkathon-ios2/sopkathon-ios2.xcodeproj -scheme sopkathon-ios2 -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

워치 앱(`SopkathonWatch` 타깃)을 건드렸다면 아래 명령으로 워치 빌드도 확인합니다.

```bash
xcodebuild -project sopkathon-ios2/sopkathon-ios2.xcodeproj -scheme SopkathonWatch -destination 'generic/platform=watchOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

- 워치 앱 코드는 `sopkathon-ios2/SopkathonWatch/`에 둡니다.
- 워치는 `Core/Network`, `Feature/CareRecord`, `App/AppDependency.swift`를 아이폰 앱과 같이 씁니다. 이 파일들이 SwiftUI나 UIKit 전용 API, 워치 타깃에 없는 타입을 쓰면 워치 빌드가 깨지므로, 수정했다면 워치 빌드도 확인합니다.
- 워치에서 같이 쓸 파일을 늘리려면 Xcode에서 그 파일의 Target Membership에 `SopkathonWatch`를 체크합니다.

## 3. 폴더 구조

```
sopkathon-ios2/sopkathon-ios2/
├─ App/                      앱 진입점, RootView, AppDependency, AppRouter, Route
├─ Core/
│  ├─ Network/               공통 네트워크 레이어 (6개 파일 고정)
│  ├─ DesignSystem/          색, 폰트, 두 기능 이상에서 쓰는 공통 컴포넌트
│  └─ Extension/             <타입>+.swift
├─ Feature/
│  └─ <기능>/
│     ├─ View/               <기능>View.swift
│     ├─ ViewModel/          <기능>ViewModel.swift
│     ├─ Model/              <기능>Model.swift
│     └─ Network/
│        ├─ <기능>Endpoint.swift
│        ├─ <기능>Service.swift
│        ├─ Mock<기능>Service.swift
│        ├─ <기능>Mapper.swift
│        └─ DTO/<이름>ResponseDTO.swift, <이름>RequestDTO.swift
└─ Resource/                 Assets.xcassets, Info.plist, 폰트
```

- 새 화면은 `Feature/<기능>` 폴더를 만들어 그 안에 작성합니다.
- `Core/Network`에는 파일을 추가하지 않습니다.
- 폴더에 첫 파일을 넣을 때 그 폴더의 `.gitkeep`은 지웁니다.

## 4. 네이밍

타입 이름에는 **기능 이름과 역할을 모두** 적습니다. 역할이 빠진 이름(`Home`, `HomePost`)은 쓰지 않습니다.

| 종류 | 파일·타입 이름 | 예 |
|---|---|---|
| 화면 | `<기능>View` | `HomeView` |
| 화면에서 분리한 View | `<기능><이름>View` | `HomePostCardView` |
| ViewModel | `<기능>ViewModel` | `HomeViewModel` |
| 화면의 대표 Model | `<기능>Model` | `HomeModel` |
| 그 밖의 Model | `<기능><이름>Model` | `HomePostModel` |
| Service | `<기능>ServiceProtocol`, `<기능>Service` | `HomeServiceProtocol`, `HomeService` |
| Mock Service | `Mock<기능>Service` | `MockHomeService` |
| Endpoint | `<기능>Endpoint` | `HomeEndpoint` |
| Mapper | `<기능>Mapper` | `HomeMapper` |
| DTO | `<이름>ResponseDTO`, `<이름>RequestDTO` | `HomeResponseDTO`, `CreatePostRequestDTO` |

- 타입·파일·에셋은 UpperCamelCase, 함수·변수·enum case는 lowerCamelCase를 씁니다.
- 약어는 `ID`, `URL`, `DTO`만 허용하고 대문자로 씁니다. (`userID`, `imageURL`, `HomeResponseDTO`)
- Bool은 `is`, `has`, `can`, `should`로 시작합니다.
- API 함수 이름은 HTTP 메서드에 맞춥니다: GET `fetch~`, POST `post~`/`create~`, PUT·PATCH `update~`, DELETE `delete~`.
- 한 기능의 Model은 모두 `<기능>Model.swift` 한 파일에 둡니다.

## 5. 기준 구현

새 기능은 아래 모양을 그대로 따릅니다. 기능 이름 `Home`과 필드는 예시입니다.

### DTO: `Feature/Home/Network/DTO/HomeResponseDTO.swift`

```swift
struct HomeResponseDTO: Decodable {
    let userID: Int
    let nickname: String
    let posts: [Post]

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname
        case posts
    }
}

extension HomeResponseDTO {
    struct Post: Decodable {
        let postID: Int
        let title: String

        enum CodingKeys: String, CodingKey {
            case postID = "postId"
            case title
        }
    }
}
```

### Endpoint: `Feature/Home/Network/HomeEndpoint.swift`

```swift
enum HomeEndpoint {
    case fetchHome
    case deletePost(postID: Int)
}

extension HomeEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchHome:
            return "/home"
        case .deletePost(let postID):
            return "/posts/\(postID)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchHome:
            return .get
        case .deletePost:
            return .delete
        }
    }
}
```

### Model: `Feature/Home/Model/HomeModel.swift`

```swift
struct HomeModel {
    let userID: Int
    let nickname: String
    let posts: [HomePostModel]
}

struct HomePostModel: Identifiable {
    let id: Int
    let title: String
    var isBookmarked = false
}
```

### Mapper: `Feature/Home/Network/HomeMapper.swift`

```swift
enum HomeMapper {
    static func map(_ dto: HomeResponseDTO) -> HomeModel {
        HomeModel(
            userID: dto.userID,
            nickname: dto.nickname,
            posts: dto.posts.map { map($0) }
        )
    }

    private static func map(_ dto: HomeResponseDTO.Post) -> HomePostModel {
        HomePostModel(id: dto.postID, title: dto.title)
    }
}
```

### Service: `Feature/Home/Network/HomeService.swift`

```swift
protocol HomeServiceProtocol {
    func fetchHome() async throws -> HomeModel
    func deletePost(postID: Int) async throws
}

final class HomeService {
    private let baseService: any BaseServiceProtocol

    init(baseService: any BaseServiceProtocol) {
        self.baseService = baseService
    }
}

extension HomeService: HomeServiceProtocol {
    func fetchHome() async throws -> HomeModel {
        let response: HomeResponseDTO = try await baseService.request(HomeEndpoint.fetchHome)
        return HomeMapper.map(response)
    }

    func deletePost(postID: Int) async throws {
        try await baseService.request(HomeEndpoint.deletePost(postID: postID))
    }
}

extension AppDependency {
    var homeService: any HomeServiceProtocol {
        switch mode {
        case .live:
            return HomeService(baseService: baseService)
        case .mock:
            return MockHomeService()
        }
    }
}
```

### Mock Service: `Feature/Home/Network/MockHomeService.swift`

```swift
struct MockHomeService {}

extension MockHomeService: HomeServiceProtocol {
    func fetchHome() async throws -> HomeModel {
        HomeModel(
            userID: 1,
            nickname: "솝트",
            posts: [
                HomePostModel(id: 1, title: "첫 번째 글"),
                HomePostModel(id: 2, title: "두 번째 글")
            ]
        )
    }

    func deletePost(postID: Int) async throws {}
}
```

### ViewModel: `Feature/Home/ViewModel/HomeViewModel.swift`

```swift
import Observation

@Observable
final class HomeViewModel {
    private(set) var home: HomeModel?

    private let service: any HomeServiceProtocol

    init(service: any HomeServiceProtocol) {
        self.service = service
    }

    func fetchHome() async {
        guard let home = try? await service.fetchHome() else { return }
        self.home = home
    }
}
```

### View: `Feature/Home/View/HomeView.swift`

```swift
import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        List(viewModel.home?.posts ?? []) { post in
            Text(post.title)
        }
        .task {
            await viewModel.fetchHome()
        }
    }
}
```

### 화면 등록과 이동: `App/Route.swift`, `App/RootView.swift`

화면을 새로 만들면 `Route`에 case를 추가하고, `RootView`의 `destinationView(for:)`에서 그 화면을 만듭니다. ViewModel은 여기서 `AppDependency`의 Service를 넣어 만듭니다. 탭의 첫 화면(`HomeView`, `BriefingView`, `ChildListView`)은 `Route`에 넣지 않고 `RootView`의 `tabContentView`에 둡니다.

```swift
enum Route: Hashable {
    case postDetail(postID: Int)
}
```

```swift
struct RootView: View {
    @Environment(AppRouter.self) private var router
    @Environment(AppDependency.self) private var dependency

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            tabContentView
                .safeAreaInset(edge: .bottom) {
                    tabBarView
                }
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private var tabContentView: some View {
        switch router.selectedTab {
        case .home:
            HomeView(viewModel: HomeViewModel(service: dependency.homeService))
        case .briefing:
            BriefingView()
        case .childList:
            ChildListView()
        }
    }

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .postDetail(let postID):
            PostDetailView(
                viewModel: PostDetailViewModel(
                    postID: postID,
                    service: dependency.postDetailService
                )
            )
        }
    }
}
```

화면에서는 `AppRouter`로 이동합니다.

```swift
struct HomeView: View {
    @Environment(AppRouter.self) private var router

    private func postRowView(_ post: HomePostModel) -> some View {
        Button(post.title) {
            router.push(.postDetail(postID: post.id))
        }
    }
}
```

## 6. 계층별 규칙

### 의존성 주입

- **`BaseService.shared`를 직접 쓰지 않습니다.** 앱 루트(`App/sopkathon_ios2App.swift`)에서 `AppDependency`를 만들 때 한 번만 넣고, 그 밖의 코드는 모두 프로토콜(`any BaseServiceProtocol`, `any <기능>ServiceProtocol`)로 주입받습니다.
- Service와 ViewModel의 `init`에 기본값을 주지 않습니다. (`= BaseService.shared`, `= HomeService()` 금지)
- 실제 구현과 Mock 중 무엇을 쓸지는 앱 루트의 `AppDependency(mode:)` 한 곳에서 정합니다. `.live`는 실제 Service, `.mock`은 Mock Service를 씁니다.
- 기능마다 `<기능>Service.swift` 맨 아래에 `extension AppDependency`를 두고, `mode`에 따라 실제 Service나 Mock Service를 돌려주는 프로퍼티를 만듭니다. `App/AppDependency.swift`는 수정하지 않습니다.
- ViewModel은 `RootView`의 `destinationView(for:)`에서 `AppDependency`의 Service를 넣어 만듭니다. 기능 화면은 `AppDependency`를 직접 꺼내 쓰지 않습니다.
- `mode: .mock`으로 바꾼 채 커밋하지 않습니다.

### 화면 이동

- 화면 이동은 `AppRouter` 하나로 합니다. `push(_:)`로 들어가고, `pop()`으로 한 단계 돌아가고, `popToRoot()`로 첫 화면까지 돌아갑니다.
- 하단 탭은 `App/AppTab.swift`의 `AppTab`(홈·브리핑·아이관리)으로 정하고, 탭을 바꿀 때는 `router.selectTab(_:)`을 호출합니다. 탭 바는 `RootView`에만 두고, `push`로 들어간 화면에서는 보이지 않습니다.
- 화면 위에 뜨는 시트는 `App/AppSheet.swift`의 `AppSheet`에 case로 등록하고, `router.presentSheet(_:)`으로 띄우고 `router.dismissSheet()`으로 닫습니다. 시트 화면은 `RootView`의 `sheetView(for:)`에서 만듭니다.
- 탭의 첫 화면은 `Route`에 넣지 않습니다. 탭을 추가하면 `AppTab`에 case를 추가하고 `RootView`의 `tabContentView`에 화면을 둡니다.
- 이동할 수 있는 화면은 모두 `App/Route.swift`의 `Route` enum에 case로 등록합니다. 화면에 넘길 값은 case의 연관값으로 넣고, 연관값에는 `Hashable`한 값(ID 등)만 넣습니다. Model이나 ViewModel을 통째로 넣지 않습니다.
- `Route`의 case 이름은 화면 이름에서 `View`를 뺀 lowerCamelCase로 짓습니다. (`ChildDetailView` → `.childDetail`, `PostDetailView` → `.postDetail`)
- case를 추가하면 `App/RootView.swift`의 `destinationView(for:)`에 그 화면을 만드는 코드를 같이 추가합니다.
- `NavigationStack`과 `navigationDestination`은 `RootView` 한 곳에만 둡니다. 기능 화면에서 `NavigationStack`을 새로 만들지 않습니다.
- 기능 화면에서 `NavigationLink`를 쓰지 않습니다. `Button`에서 `router.push(_:)`를 호출합니다.
- 화면 이동은 View에서 합니다. ViewModel이 `AppRouter`를 갖지 않습니다.
- `App/AppRouter.swift`는 수정하지 않습니다.

### View

- **UI를 만들거나 고치면 반드시 10번의 세 기종(iPhone 13 mini, 18 Pro, 18 Pro Max)에서 실행해 기기 대응을 확인합니다.**
- 순서: 프로퍼티 → `init` → `body` → 하위 View → `private func`
- `@State`, `@FocusState`는 항상 `private`으로 선언합니다.
- View는 ViewModel의 값을 읽어 그리기만 합니다. 네트워크 호출과 데이터 가공을 View에 두지 않습니다.
- 로딩 화면과 실패 화면을 만들지 않습니다. `ProgressView`, "다시 시도" 버튼, 에러 문구를 넣지 않고, 데이터가 아직 없으면 빈 상태로 둡니다.
- 첫 데이터 요청은 `.task`에서 합니다.
- View는 ViewModel을 직접 만들지 않고 `init`으로 받습니다. 화면에 넘길 값(`postID` 등)은 띄우는 쪽에서 ViewModel을 만들 때 넣습니다.

  ```swift
  init(viewModel: PostDetailViewModel) {
      _viewModel = State(initialValue: viewModel)
  }
  ```

- `#Preview`는 커밋하지 않습니다.

### ViewModel

- `@Observable final class`로 만듭니다. `ObservableObject`, `@Published`는 쓰지 않습니다.
- 순서: 공개 상태 → `private` 상태 → 의존성 → `init` → 공개 메서드 → `private` 메서드
- 서버에서 받아 온 데이터는 ViewModel의 프로퍼티로 그대로 둡니다. 하나짜리는 옵셔널(`var home: HomeModel?`), 목록은 빈 배열(`var posts: [HomePostModel] = []`)로 시작합니다.
- 로딩·실패 상태를 만들지 않습니다. `State` enum, `isLoading`, `errorMessage`를 두지 않습니다.
- 요청이 실패하면 기존 값을 그대로 두고 아무것도 하지 않습니다. (`guard let home = try? await service.fetchHome() else { return }`)
- View가 읽기만 하는 값은 `private(set)`으로 선언합니다.
- `~ServiceProtocol`에만 의존하고 `init`에서 기본값 없이 주입받습니다. `BaseService`, `Endpoint`, DTO, Mapper를 직접 쓰지 않습니다.

### Model

- 화면에서 쓰기 좋은 모양으로 만듭니다. 서버 JSON 구조를 그대로 따르지 않습니다.
- `Decodable`을 채택하지 않고, DTO를 알지 못합니다. (`init(dto:)`를 만들지 않습니다)
- 서버에 없는 값은 기본값을 가진 `var`로 둡니다. (`var isBookmarked = false`)

### Network

- 추가 순서는 `DTO → Endpoint → Model → Mapper → Service → ViewModel`입니다.
- **DTO**는 서버 JSON과 1:1로 맞춘 데이터만 가집니다. `ID`, `URL` 표기는 `CodingKeys`로 맞추고, 중첩 타입은 DTO의 extension 안에 둡니다. DTO에 `toModel()` 같은 변환 함수를 넣지 않습니다.
- **Mapper**가 DTO와 Model 사이의 변환을 모두 맡습니다.
  - 기능마다 `enum <기능>Mapper`를 하나 만들고, 변환 함수 이름은 전부 `static func map(_:)`으로 통일합니다.
  - 중첩 타입 변환처럼 Mapper 안에서만 쓰는 함수는 `private static`으로 둡니다.
  - 서버 문자열을 enum으로 바꾸거나 문자열을 `URL`로 바꾸는 일도 Mapper에서 합니다.
  - Model을 요청 DTO로 바꿔야 할 때도 같은 Mapper에 `map`을 추가합니다.
- **Endpoint**는 기능마다 enum을 따로 만들고 `path`, `method`만 구현합니다. `queryItems`, `body`는 필요한 경우에만 구현합니다.
- **Service**는 `any BaseServiceProtocol`을 `init`에서 기본값 없이 주입받습니다. `BaseService`를 상속하지 않습니다.
- **Mock Service**는 같은 `~ServiceProtocol`을 채택하고, 서버 없이 화면을 확인할 수 있는 가짜 Model을 돌려줍니다.
- Service는 요청을 보내고 `Mapper.map`으로 바꾼 Model을 돌려줍니다. DTO를 밖으로 내보내지 않습니다.
- 기능 폴더에서 `import Alamofire`를 하지 않습니다.

## 7. 컴포넌트 분리 기준

기준은 **두 번 이상 쓰이는가** 하나입니다.

| 쓰이는 곳 | 만드는 방법 | 위치 |
|---|---|---|
| 한 화면에서 한 번 | `private var <이름>View: some View` 또는 `private func <이름>View(_:) -> some View` | 그 화면 파일 안 |
| 한 기능 안에서 두 번 이상 | `struct <기능><이름>View: View` | `Feature/<기능>/View/<기능><이름>View.swift` |
| 두 기능 이상 | `struct <이름>View: View` | `Core/DesignSystem` |

- 한 번만 쓰이는 View를 미리 `struct`로 빼지 않습니다. 두 번째로 쓰이게 될 때 분리합니다.
- `body`가 40줄을 넘으면 `private var` 하위 View로 나눕니다. 이때도 `struct`로 빼지 않습니다.
- 새로 만들기 전에 `Core/DesignSystem`과 같은 기능 폴더에 같은 역할의 컴포넌트가 있는지 먼저 찾아봅니다.
- 공통 컴포넌트는 `Core/DesignSystem/Component` 아래 종류별 폴더에 둡니다: `Button`(버튼), `Input`(입력 필드·검색), `Overlay`(바텀시트·모달), `Chip`(칩·태그), `Profile`(아이 프로필 카드·색), `Header`(화면 상단 헤더). 여러 화면에서 쓰는 레이아웃은 `Core/DesignSystem/Layout`에 둡니다. 맞는 폴더가 없으면 새 폴더를 만듭니다.

## 8. 코드 스타일

- 파일 맨 위에 Xcode 기본 헤더 주석을 넣습니다. 작성자 이름은 사용자가 만든 기존 파일의 표기를 따릅니다.

  ```swift
  //
  //  HomeView.swift
  //  sopkathon-ios2
  //
  //  Created by <작성자> on 11/19/26.
  //
  ```

- 헤더 외의 주석은 커밋하지 않습니다.
- import는 알파벳 순으로 쓰고, 애플 프레임워크를 먼저 쓴 뒤 한 줄 띄우고 서드파티를 씁니다.

  ```swift
  import SwiftUI

  import Kingfisher
  ```

- 더 상속하지 않는 클래스는 `final`로 선언합니다.
- 프로토콜 구현은 프로토콜마다 `extension`을 나눠서 합니다.
- 외부에서 쓰지 않는 프로퍼티와 함수는 `private`으로 선언합니다.
- 강제 언래핑(`!`)과 강제 캐스팅(`as!`)은 쓰지 않고 `guard let`으로 빠져나옵니다.
- 한 줄이 100자를 넘거나 파라미터가 3개 이상이면 파라미터마다 줄을 바꿉니다.
- `Spacer()` 앞뒤, 프로퍼티와 `body` 사이는 한 줄 띄웁니다.
- 하드코딩을 최대한 없앱니다. 헤더 키, URL, 설정값은 문자열로 직접 쓰지 않고 `HeaderType`, `Endpoint`, `Info.plist`를 씁니다.
- 쓰지 않는 코드를 남기지 않습니다.

## 9. Git 협업 규칙

### 작업 유형

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

API 연결 작업은 `feat`를 사용하고, 이슈와 PR에 `API` 라벨을 추가합니다.

### 브랜치

- 이슈를 만든 뒤 이슈 번호에 맞는 작업 브랜치를 만듭니다.
- 형식: `<유형>/#<이슈번호>-<작업내용>`
- 작업 내용은 짧은 영문 소문자와 하이픈으로 작성합니다.
- 예: `feat/#2-login-api`, `design/#3-home-view`
- 작업 시작 전 `main` 브랜치를 최신 상태로 갱신합니다.
- `develop` 브랜치는 사용하지 않습니다. 작업 브랜치에서 `main`으로 PR을 보냅니다.

### 커밋

- 형식: `<유형>: #<이슈번호> <한글 요약>`
- 예: `feat: #2 로그인 API 연결`
- 유형은 소문자로, 요약은 한글로 작성합니다.
- 제목 전체를 50자 이내로 간결하게 작성합니다. 상세한 내용이 필요하면 본문에 적습니다.
- 서로 다른 목적의 변경은 커밋을 나눕니다.
- 빌드가 실패하는 상태로 커밋하지 않습니다.
- 사용자가 요청할 때만 커밋하고 푸시합니다.
- 커밋 메시지에 에이전트 관련 문구(Co-Authored-By, "Generated with ..." 등)를 넣지 않습니다.

### 이슈

- 제목 형식: `[유형] 작업 내용`
- 예: `[Feat] 로그인 API 연결`
- 템플릿의 제목 기본값은 `[Feat] `입니다. 다른 유형의 작업이면 머리말을 그 유형으로 바꿉니다. (`[Design] 홈 화면 구현`)
- 작업 유형 라벨과 담당자 라벨을 지정합니다. API 연결 작업에는 `API` 라벨도 지정합니다.
- 라벨의 첫 글자는 대문자로 작성합니다.
- 본문은 `.github/ISSUE_TEMPLATE/feature.md`의 구성을 그대로 사용합니다. 제목을 바꾸거나 섹션을 추가하지 않습니다.

```markdown
## 🛠 작업 내용
- 작업 설명

## 🍎 To-do
- [ ] 할 일 1
- [ ] 할 일 2

## 💬 기타 사항
없으면 지우기
```

| 섹션 | 적는 내용 |
|---|---|
| 🛠 작업 내용 | 구현할 기능이나 수정할 문제 |
| 🍎 To-do | 완료 조건을 확인할 수 있는 할 일을 체크박스로 |
| 💬 기타 사항 | 참고할 내용. 없으면 섹션을 통째로 지웁니다 |

### PR

- 제목 형식: `[유형/#이슈번호] 작업 내용`
- 예: `[Feat/#2] 로그인 API 연결`
- 작업 유형 라벨과 담당자 라벨을 지정합니다. API 연결 작업에는 `API` 라벨도 지정합니다.
- 라벨의 첫 글자는 대문자로 작성합니다.
- 작성자를 제외한 팀원 모두를 리뷰어로 지정합니다.
- PR 작성자 외의 팀원이 리뷰하고, 문제가 없으면 승인합니다.
- 충돌이 발생하면 리드와 관련 팀원에게 공유합니다.
- PR 설명에 에이전트 관련 문구를 넣지 않습니다.
- 본문은 `.github/PULL_REQUEST_TEMPLATE.md`의 구성을 그대로 사용합니다. 제목을 바꾸거나 섹션을 추가하지 않습니다.

````markdown
## 🔗 관련 이슈
- Resolved: #이슈번호

<br>

## 🍎 작업한 내용
<!-- 자신이 어떤 작업을 했는지 적어주세요! -->
-

<!--
```swift
넣고싶은 코드가 있다면 적어주세요
```
-->

<br>

## 🪄 PR Point
<!-- 이 코드에서 쩔어주네. 하는 부분을 작성해주세요! -->

<!--
```swift
넣고싶은 코드가 있다면 적어주세요
```
-->

<br>


## 💬 To Reviewers
<!-- 리뷰어들에게 하고 싶은 말 -->
````

| 섹션 | 적는 내용 |
|---|---|
| 🔗 관련 이슈 | `- Resolved: #이슈번호` 형식을 유지합니다. 머지되면 이슈가 함께 닫힙니다 |
| 🍎 작업한 내용 | 작업한 내용을 항목으로 적습니다. UI를 만들거나 고쳤다면 iPhone 13 mini, iPhone 18 Pro, iPhone 18 Pro Max에서 확인한 결과도 여기에 적습니다 |
| 🪄 PR Point | 리뷰어가 집중해서 봐 줬으면 하는 코드나 결정 |
| 💬 To Reviewers | 리뷰어에게 전할 말이나 참고 사항 |

## 10. 기기 대응 확인

해커톤 심사 기준에 기기 대응이 있습니다. 화면(View)을 만들거나 고친 작업은 아래 세 기종 시뮬레이터에서 직접 실행해 확인한 뒤에 끝냅니다. 빌드 성공만으로 끝내지 않습니다.

| 기종 | 확인하는 이유 |
|---|---|
| iPhone 13 mini | 가장 작은 화면 |
| iPhone 18 Pro | 기준 화면 |
| iPhone 18 Pro Max | 가장 큰 화면 |

순서는 다음과 같습니다.

1. 시뮬레이터용으로 빌드합니다. 결과물은 git에서 제외된 `build/` 폴더에 생깁니다.

   ```bash
   xcodebuild -project sopkathon-ios2/sopkathon-ios2.xcodeproj -scheme sopkathon-ios2 -destination 'generic/platform=iOS Simulator' -derivedDataPath build CODE_SIGNING_ALLOWED=NO build
   ```

2. 세 기종 각각에 대해 부팅, 설치, 실행, 스크린샷을 합니다. `<기종>`에는 위 표의 이름을 그대로 넣습니다.

   ```bash
   xcrun simctl boot "<기종>"
   xcrun simctl bootstatus "<기종>"
   xcrun simctl install "<기종>" build/Build/Products/Debug-iphonesimulator/sopkathon-ios2.app
   xcrun simctl launch "<기종>" com.h2e.sopkathon-ios2
   xcrun simctl io "<기종>" screenshot build/<기종>.png
   xcrun simctl shutdown "<기종>"
   ```

3. 작업한 화면까지 이동해 스크린샷을 직접 열어 보고 아래를 확인합니다.
   - 잘리거나 겹치는 글자, 버튼, 이미지가 없는가
   - 13 mini에서 내용이 화면 밖으로 넘치면 스크롤로 끝까지 볼 수 있는가
   - Pro Max에서 한쪽으로 쏠리거나 어색하게 비는 곳이 없는가
   - 노치·다이내믹 아일랜드·홈 인디케이터에 가려지는 요소가 없는가
   - 입력 화면이면 키보드가 올라왔을 때 입력창과 버튼이 가려지지 않는가

4. 문제가 있으면 고친 뒤 세 기종을 처음부터 다시 확인합니다.

5. 끝낼 때 세 기종에서 확인한 결과를 사용자에게 알립니다. 확인하지 못한 기종이나 화면이 있으면 그것도 그대로 알립니다.

- 시뮬레이터를 조작하는 전용 도구가 있으면 `simctl` 대신 그 도구를 써도 됩니다.
- 해당 기종의 시뮬레이터가 설치되어 있지 않으면 다른 기종으로 바꾸지 말고 사용자에게 알립니다.

## 11. 끝내기 전 확인

1. 2번의 명령으로 빌드가 성공했는가
2. 새 타입 이름이 4번의 표와 맞는가
3. DTO와 Model에 변환 코드가 없고, 변환이 전부 Mapper에 있는가
4. 한 번만 쓰이는 View를 `struct`로 빼지 않았는가
5. 헤더 주석이 있고, 그 외 주석과 `#Preview`는 없는가
6. 화면을 건드렸다면 10번의 세 기종에서 실행해 확인했는가
7. `BaseService.shared`를 직접 쓰거나 `init`에 기본값을 준 곳이 없는가
8. 새 화면을 `Route`와 `RootView`에 등록했고, `NavigationLink` 대신 `AppRouter`로 이동하는가
