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

## 3. 폴더 구조

```
sopkathon-ios2/sopkathon-ios2/
├─ App/                      앱 진입점, 루트 화면
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

    init(baseService: any BaseServiceProtocol = BaseService.shared) {
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
```

### ViewModel: `Feature/Home/ViewModel/HomeViewModel.swift`

```swift
import Observation

@Observable
final class HomeViewModel {
    enum State {
        case loading
        case loaded(HomeModel)
        case failed(message: String)
    }

    private(set) var state: State = .loading

    private let service: any HomeServiceProtocol

    init(service: any HomeServiceProtocol = HomeService()) {
        self.service = service
    }

    func fetchHome() async {
        state = .loading

        do {
            let home = try await service.fetchHome()
            state = .loaded(home)
        } catch {
            state = .failed(message: makeErrorMessage(from: error))
        }
    }

    private func makeErrorMessage(from error: any Error) -> String {
        switch error {
        case NetworkError.networkConnection:
            return "네트워크 연결을 확인해 주세요."
        case NetworkError.timeout:
            return "요청 시간이 초과됐어요. 다시 시도해 주세요."
        default:
            return "정보를 불러오지 못했어요."
        }
    }
}
```

### View: `Feature/Home/View/HomeView.swift`

```swift
import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        contentView
            .task {
                await viewModel.fetchHome()
            }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .loaded(let home):
            loadedView(home)
        case .failed(let message):
            failedView(message)
        }
    }

    private func loadedView(_ home: HomeModel) -> some View {
        List(home.posts) { post in
            Text(post.title)
        }
    }

    private func failedView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Text(message)

            Button("다시 시도") {
                Task { await viewModel.fetchHome() }
            }
        }
    }
}
```

## 6. 계층별 규칙

### View

- **UI를 만들거나 고치면 반드시 10번의 세 기종(iPhone 13 mini, 18 Pro, 18 Pro Max)에서 실행해 기기 대응을 확인합니다.**
- 순서: 프로퍼티 → `init` → `body` → 하위 View → `private func`
- `@State`, `@FocusState`는 항상 `private`으로 선언합니다.
- View는 `viewModel.state`를 읽어 그리기만 합니다. 네트워크 호출, 데이터 가공, 에러 문구 결정을 View에 두지 않습니다.
- 첫 데이터 요청은 `.task`에서 합니다.
- 화면에 값을 넘겨받아야 하면 `init`에서 받아 ViewModel을 만듭니다.

  ```swift
  init(postID: Int) {
      _viewModel = State(initialValue: PostDetailViewModel(postID: postID))
  }
  ```

- `#Preview`는 커밋하지 않습니다.

### ViewModel

- `@Observable final class`로 만듭니다. `ObservableObject`, `@Published`는 쓰지 않습니다.
- 순서: 공개 상태 → `private` 상태 → 의존성 → `init` → 공개 메서드 → `private` 메서드
- 서버에서 받아 오는 화면 상태는 `State` enum(`loading`, `loaded`, `failed`) 하나로 표현합니다. `isLoading`, `errorMessage`, 데이터를 따로따로 두지 않습니다.
- View가 읽기만 하는 값은 `private(set)`으로 선언합니다.
- `~ServiceProtocol`에만 의존하고, `init`에서 주입받되 기본값으로 실제 Service를 줍니다. `BaseService`, `Endpoint`, DTO, Mapper를 직접 쓰지 않습니다.
- 사용자에게 보여 줄 에러 문구는 ViewModel에서 정합니다.

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
- **Service**는 `any BaseServiceProtocol`을 주입받고 기본값으로 `BaseService.shared`를 줍니다. `BaseService`를 상속하지 않습니다.
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

## 9. 커밋

- 사용자가 요청할 때만 커밋하고 푸시합니다.
- 형식: `태그: 한국어 한 줄 요약` (예: `setting: 네트워크 레이어 세팅`, `docs: .gitignore 작성`)
- 변경 단위별로 커밋을 나눕니다.
- 빌드가 실패하는 상태로 커밋하지 않습니다.
- 커밋 메시지와 PR 설명에 에이전트 관련 문구(Co-Authored-By, "Generated with ..." 등)를 넣지 않습니다.

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
