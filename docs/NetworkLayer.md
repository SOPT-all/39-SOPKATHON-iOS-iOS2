# 네트워크 레이어 가이드

sopkathon-ios2의 공통 네트워크 레이어 설정 방법과 새로운 API 연결을 위한 사용 방법에 대한 설명 문서입니다.

- 통신 라이브러리: Alamofire 5.12.2 (SPM)
- 비동기 방식: `async`/`await`
- 위치: `sopkathon-ios2/sopkathon-ios2/Core/Network`

## 목차

1. [처음 클론했을 때 할 일](#1-처음-클론했을-때-할-일)
2. [폴더 구조](#2-폴더-구조)
3. [요청이 처리되는 흐름](#3-요청이-처리되는-흐름)
4. [파일별 설명](#4-파일별-설명)
5. [새로운 API를 추가하는 법](#5-새로운-api를-추가하는-법)
6. [에러 처리](#6-에러-처리)
7. [로그 보는 법](#7-로그-보는-법)
8. [설정값(BASE_URL) 주입 구조](#8-설정값base_url-주입-구조)
9. [서버 명세 완료 후 수정할 점](#9-서버-명세-완료-후-수정할-점)
10. [자주 겪는 문제](#10-자주-겪는-문제)
11. [Alamofire가 하는 역할](#11-alamofire가-하는-역할)

---

## 1. 처음 클론했을 때 할 일

`Config.xcconfig`에는 서버 주소가 포함되어있어 git에 push하지 않습니다. 파일이 없으면 빌드가 되지 않기 때문에 클론 후 수동으로 생성해야 합니다.

1. `.xcodeproj`와 동일한 디렉토리에 `Config.xcconfig`를 생성합니다.

   ```
   39-SOPKATHON-iOS-iOS2/
   └─ sopkathon-ios2/
      ├─ Config.xcconfig          ← 여기
      ├─ sopkathon-ios2.xcodeproj
      └─ sopkathon-ios2/
   ```

2. 여기에 한줄을 넣습니다. 호스트를 팀에서 공유해준 서버주소로 변경합니다.

   ```
   BASE_URL = https:/$()/api.example.com
   ```

`https://`를 `https:/$()/`라고 쓰는 것은 xcconfig에서 `//`를 주석의 시작으로 인식하기 때문입니다. `https://...`라고 쓰면 `https:` 까지만 값이 들어갑니다. `$()`는 빈 값으로 치환되면서 최종적으로 `https://api.example.com`이 됩니다.

파일이 존재하지 않을 경우 빌드 에러 메시지는 아래와 같습니다.

```
error: Unable to open base configuration reference file '.../sopkathon-ios2/Config.xcconfig'.
```

## 2. 폴더 구조

공통 코드는 `Core/Network`에, 기능별 코드는 각 기능 폴더의 `Network`에 위치시킵니다.

```
Core/Network
├─ BaseService.swift       BaseServiceProtocol + BaseService(shared)
│                          요청생성 → 통신 → 상태코드 확인 → 디코딩, 공통헤더, BASE_URL 읽기
├─ Endpoint.swift          Endpoint 프로토콜, 기본값, makeURLRequest
├─ HTTPMethod.swift        HTTPMethod, HeaderType, ContentType
├─ BaseResponseDTO.swift   BaseResponseDTO<T>, ErrorResponseDTO, EmptyData
├─ NetworkError.swift      NetworkError, ServerErrorCode
└─ NetworkLogger.swift     DEBUG 빌드에서만 요청/응답 로그 출력

Feature/<기능>/Network
├─ <기능>Endpoint.swift     기능별 enum, Endpoint 채택
├─ <기능>Service.swift      <기능>ServiceProtocol + <기능>Service
├─ <기능>Mapper.swift       DTO ↔ Model 변환
└─ DTO/<이름>ResponseDTO.swift
```

규칙은 이렇습니다.

- `Core/Network` 폴더에는 위의 6개 파일만 유지합니다. 필요한 타입은 별도의 파일을 생성하지 않고 동일 파일 내에 작성합니다.
- Endpoint는 하나의 enum으로 합치지 않고 각 기능폴더별로 별도의 enum을 사용합니다.
- 기능별 Service는 `BaseService`를 상속받지 않고 `any BaseServiceProtocol`을 주입받습니다.
- ViewModel은 `~ServiceProtocol` 에만 의존합니다.

## 3. 요청이 처리되는 흐름

```
ViewModel
  │  service.fetchHome()
  ▼
HomeService                     DTO → Model 변환(HomeMapper)
  │  baseService.request(HomeEndpoint.fetchHome)
  ▼
BaseService
  ├─ 1. makeRequest    BASE_URL + Endpoint → URLRequest, 공통헤더 추가
  ├─ 2. perform        Alamofire로 통신
  ├─ 3. decode         상태 코드 확인
  │                     ├─ 2xx    → BaseResponseDTO<T> 디코딩
  │                     └─ 기타   → ErrorResponseDTO 디코딩 NetworkError.server
  └─ 4. data 반환      BaseResponseDTO에서 data를 추출하여 반환
```

Alamofire는 `BaseService` 내부의 통신(2번)시에 사용됩니다. 상태코드 체크와 디코딩을 직접 수행하기 때문에 다른 파일에서는 `import Alamofire`가 불필요합니다.

## 4. 파일별 설명

### BaseService.swift

외부에서 호출하는 메서드 2개입니다.

```swift
protocol BaseServiceProtocol {
    func request<Response: Decodable>(_ endpoint: some Endpoint) async throws -> Response
    func request(_ endpoint: some Endpoint) async throws
}
```

| 메서드 | 쓰는 경우 | 동작 |
|---|---|---|
| `request<Response>` | 응답 `data`를 받아야 할 때 | `data`를 `Response`로 디코딩해 반환. `data`가 없으면 `NetworkError.emptyData` |
| `request` (Void) | 성공 여부만 필요할 때 | `data`를 `EmptyData`로 읽고 버림 |

- `BaseService.shared`는 앱 루트에서 `AppDependency`를 만들 때 한 번만 사용합니다. 그 외에는 직접 쓰지 않고 `any BaseServiceProtocol`로 주입받습니다.
- 공통 헤더를 여기서 붙입니다. `Accept: application/json`은 언제나, `Content-Type: application/json`은 body가 있는 경우에만 붙습니다.
- `BASE_URL`은 `Info.plist`로부터 가져옵니다. 값이 존재하지 않거나 비어있는 경우 `NetworkError.invalidBaseURL`을 던집니다.

### Endpoint.swift

```swift
protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var body: (any Encodable)? { get }
}
```

- `path`, `method`가 필수입니다.
- `queryItems`의 기본값은 빈 배열이고, `body`는 기본값이 `nil`이므로 필요한 case에 대해서만 구현하면 됩니다.
- `body`에 전달한 데이터는 `JSONEncoder`를 거쳐 인코딩됩니다.
- `makeURLRequest(baseURL:)` 함수는 `BASE_URL + path + queryItems` 형태로 `URLRequest`를 생성합니다. 헤더는 여기서 추가하지 않습니다.

### HTTPMethod.swift

```swift
enum HTTPMethod: String { case get, post, put, patch, delete }   // rawValue는 "GET" 등 대문자
enum HeaderType: String { case contentType, accept }              // "Content-Type", "Accept"
enum ContentType: String { case json }                            // "application/json"
```

헤더 키와 값에는 문자열을 직접 사용하지 않고 `HeaderType`, `ContentType`을 사용합니다. 인증헤더 등 새로운 헤더가 필요하다면 `HeaderType`에 case를 추가하고 `BaseService.makeRequest`에서 추가합니다.

### BaseResponseDTO.swift

```swift
struct BaseResponseDTO<T: Decodable>: Decodable {
    let data: T?
}

struct ErrorResponseDTO: Decodable {
    let code: String
    let message: String
}

struct EmptyData: Decodable {}
```

- 성공 응답(2xx)은 `BaseResponseDTO<T>`를 통해 파싱하고 `data`를 추출합니다.
- 실패 응답(2xx 이외)은 `ErrorResponseDTO`를 통해 별도로 읽어 들입니다. 따라서 실패 응답의 `data`가 다르더라도 `code`, `message`를 읽어올 수 있습니다.

### NetworkError.swift

`NetworkError`와 서버 에러 코드를 나타내는 enum `ServerErrorCode`가 있습니다. 자세한 설명은 [6. 에러 처리](#6-에러-처리) 부분을 확인하세요.

### NetworkLogger.swift

DEBUG 빌드에서만 콘솔로 요청·응답·에러를 출력합니다. 더 자세한 사항은 [7. 로그 보는 법](#7-로그-보는-법)을 보세요.

## 5. 새로운 API를 추가하는 법

`DTO → Endpoint → Model → Mapper → Service → ViewModel` 순서대로 기능 폴더에 추가합니다. 아래는 홈 화면 가상 API 연동 예시입니다. API 경로 및 필드는 설명을 위한 허구이므로 실제 명세대로 변경하세요.

```
Feature/Home
├─ View/HomeView.swift
├─ ViewModel/HomeViewModel.swift
├─ Model/HomeModel.swift
└─ Network
   ├─ HomeEndpoint.swift
   ├─ HomeService.swift
   ├─ MockHomeService.swift
   ├─ HomeMapper.swift
   └─ DTO
      ├─ HomeResponseDTO.swift
      └─ CreatePostRequestDTO.swift
```

### 5-1. DTO

서버 JSON과 일치시킵니다. `ID`, `URL` 약어는 `CodingKeys`에 맞추고, 중첩 타입은 DTO의 extension 안에 위치시킵니다.

```swift
struct HomeResponseDTO: Decodable {
    let userID: Int
    let nickname: String
    let profileImageURL: String?
    let posts: [Post]

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname
        case profileImageURL = "profileImageUrl"
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

DTO에는 서버 JSON 모양의 데이터만 작성합니다. Model로 변환하는 코드는 DTO가 아니라 Mapper에 작성합니다.

요청 body를 `Encodable`로 생성합니다.

```swift
struct CreatePostRequestDTO: Encodable {
    let title: String
    let content: String
}
```

DTO는 `BaseResponseDTO` 내부의 `data` 구조만 작성합니다. `data`에 대한 외곽 구조는 `BaseService`에서 담당합니다.

### 5-2. Endpoint

기능별로 enum을 생성하고 extension으로 `Endpoint`를 채택합니다.

```swift
import Foundation

enum HomeEndpoint {
    case fetchHome
    case fetchPosts(page: Int)
    case createPost(CreatePostRequestDTO)
    case deletePost(postID: Int)
}

extension HomeEndpoint: Endpoint {
    var path: String {
        switch self {
        case .fetchHome:
            return "/home"
        case .fetchPosts, .createPost:
            return "/posts"
        case .deletePost(let postID):
            return "/posts/\(postID)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchHome, .fetchPosts:
            return .get
        case .createPost:
            return .post
        case .deletePost:
            return .delete
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchPosts(let page):
            return [URLQueryItem(name: "page", value: String(page))]
        default:
            return []
        }
    }

    var body: (any Encodable)? {
        switch self {
        case .createPost(let request):
            return request
        default:
            return nil
        }
    }
}
```

쿼리나 body가 없는 Endpoint라면 `queryItems`, `body`를 전혀 구현할 필요가 없습니다.

### 5-3. Model

화면타입입니다. 서버에 없는 데이터는 기본값으로 설정합니다. 타입 이름은 `<기능>Model`, `<기능><이름>Model`로 짓고 `Model/HomeModel.swift` 한 파일에 작성합니다.

```swift
import Foundation

struct HomeModel {
    let userID: Int
    let nickname: String
    let profileImageURL: URL?
    let posts: [HomePostModel]
}

struct HomePostModel: Identifiable {
    let id: Int
    let title: String
    var isBookmarked = false
}
```

### 5-4. Mapper와 Service

DTO와 Model 사이의 변환은 `<기능>Mapper`에 모읍니다. 변환 함수 이름은 모두 `map`으로 통일하고, Mapper 안에서만 쓰는 함수는 `private static`으로 선언합니다.

```swift
import Foundation

enum HomeMapper {
    static func map(_ dto: HomeResponseDTO) -> HomeModel {
        HomeModel(
            userID: dto.userID,
            nickname: dto.nickname,
            profileImageURL: dto.profileImageURL.flatMap(URL.init(string:)),
            posts: dto.posts.map { map($0) }
        )
    }

    private static func map(_ dto: HomeResponseDTO.Post) -> HomePostModel {
        HomePostModel(id: dto.postID, title: dto.title)
    }
}
```

Service는 `~ServiceProtocol`을 정의한 뒤, extension으로 구현합니다. 응답 DTO를 `HomeMapper.map`으로 변환해 Model을 반환합니다.

```swift
protocol HomeServiceProtocol {
    func fetchHome() async throws -> HomeModel
    func createPost(title: String, content: String) async throws
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

    func createPost(title: String, content: String) async throws {
        let request = CreatePostRequestDTO(title: title, content: content)
        try await baseService.request(HomeEndpoint.createPost(request))
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

`init`에 기본값을 주지 않습니다. 파일 맨 아래의 `extension AppDependency`가 앱 루트에서 정한 `mode`에 따라 실제 Service나 Mock Service를 돌려줍니다.

두 `request`는 수신 타입에 따라 결정됩니다.

- `let response: HomeResponseDTO = try await baseService.request(...)` → `data` 디코딩 후 반환하는 쪽
- `try await baseService.request(...)` (결과값 안 받음) → Void쪽

함수명은 HTTP 메서드에 따라 결정합니다.

| HTTP 메서드 | 함수 이름 |
|---|---|
| GET | `fetch~` |
| POST | `post~` 또는 `create~` |
| PUT / PATCH | `update~` |
| DELETE | `delete~` |

### 5-5. ViewModel

`~ServiceProtocol`만을 사용하며, 화면출력 문구를 정의하는 곳입니다.

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

    init(service: any HomeServiceProtocol) {
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
            return "요청 시간이 초과됐습니다. 다시 시도해 주세요."
        case NetworkError.server(_, let code, _):
            switch code {
            case .unknown:
                return "서버 에러가 발생했어요. 잠시 후에 다시 시도해주세요."
            }
        default:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
```

화면 상태는 `State` enum 하나로 관리합니다. `isLoading`, `errorMessage`, 데이터를 따로 두지 않습니다. `NetworkError`가 아닌 에러는 `default`에서 처리합니다.

### 5-6. View

`.task`에서 호출 시 화면이 사라지면 요청도 같이 취소됩니다.

```swift
import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

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
            Text(home.nickname)
        case .failed(let message):
            Text(message)
        }
    }
}
```

View는 ViewModel을 직접 만들지 않고 `init`으로 받습니다. 화면을 띄우는 상위 View가 `AppDependency`에서 Service를 꺼내 ViewModel을 만들어 넘깁니다.

```swift
struct ContentView: View {
    @Environment(AppDependency.self) private var dependency

    var body: some View {
        HomeView(viewModel: HomeViewModel(service: dependency.homeService))
    }
}
```

### 5-7. 서버 없이 테스트하기

Service와 ViewModel은 프로토콜에만 의존하기 때문에 가짜 구현체를 넣을 수 있습니다. 기능마다 `Mock<기능>Service`를 만들어 가짜 Model을 반환합니다.

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

실제 구현과 Mock 중 무엇을 쓸지는 앱 루트 한 곳에서 정합니다. `App/sopkathon_ios2App.swift`의 `mode`를 `.mock`으로 바꾸면 모든 기능이 Mock Service를 사용합니다.

```swift
@State private var dependency = AppDependency(mode: .mock, baseService: BaseService.shared)
```

`.mock`으로 바꾼 상태는 커밋하지 않습니다.

## 6. 에러 처리

네트워크 레이어는 오류의 종류만 정의합니다. 사용자에게 표시될 메시지는 ViewModel에서 결정합니다.

### NetworkError

| case | 발생하는 경우 |
|---|---|
| `invalidBaseURL` | `Info.plist`에 `BASE_URL`이 없거나 비어 있음 |
| `invalidURL` | `path`, `queryItems`로 URL을 만들지 못함 |
| `encodingFailed(Error)` | 요청 body를 JSON으로 인코딩하지 못함 |
| `networkConnection` | 인터넷에 연결되어 있지 않거나 연결이 끊김 |
| `timeout` | 요청 시간 초과 |
| `transportFailed(Error)` | 그 밖의 통신 실패 |
| `invalidResponse` | HTTP 응답을 받지 못했는데 에러 정보도 없음 |
| `decodingFailed(Error)` | 상태 코드는 2xx인데 응답을 디코딩하지 못함 |
| `emptyData` | 상태 코드는 2xx인데 `data`가 없음 (`data`를 받는 `request`에서만) |
| `server(statusCode:code:message:)` | 상태 코드가 2xx가 아님 |

요청을 취소하면 `NetworkError` 대신 Swift 표준 `CancellationError`를 발생시킵니다.

### 서버 에러 코드

서버에서 내려주는 `code` 문자열은 `ServerErrorCode` enum으로 변환됩니다. enum에 정의되지 않은 코드는 `.unknown`이 됩니다.

현재는 API 명세가 없기 때문에 `.unknown` 뿐입니다. 명세가 생성되면 `NetworkError.swift`에서 case를 추가합니다.

```swift
enum ServerErrorCode: String {
    case userNotFound = "USER_NOT_FOUND"
    case alreadyJoined = "ALREADY_JOINED"
    case unknown

    init(code: String?) {
        self = code.flatMap(ServerErrorCode.init(rawValue:)) ?? .unknown
    }
}
```

case를 추가하면 ViewModel의 `switch code`에서 컴파일 에러가 발생하여 문구를 누락한 위치를 가리킵니다.

```swift
case NetworkError.server(_, let code, _):
    switch code {
    case .userNotFound:
        return "존재하지않는 유저입니다."
    case .alreadyJoined:
        return "이미 참여된 모임이에요."
    case .unknown:
        return "서버 오류가 발생했습니다. 나중에 다시 시도해 주세요."
    }
```

서버로부터 받은 `message`를 있는 그대로 띄우고 싶으면 `NetworkError.server(_, _, let message)`를 통해 가져오면 됩니다. 실패 응답을 못읽으면 빈 문자열이 들어오므로 비어있을 때의 문구를 별도로 준비하세요.

## 7. 로그 보는 법

DEBUG 빌드에서는 요청할 때마다 Xcode 콘솔에 다음과 같이 찍힙니다. Release 빌드에는 출력이 없습니다.

```
[Request] POST https://api.example.com/posts
[Headers] Accept: ***, Content-Type: ***
[Body] {"title":"제목","content":"내용"}
[Response] 201 https://api.example.com/posts
[Body] {"data":null}
```

실패 시 `[Error]` 줄이 추가됩니다.

```
[Error] https://api.example.com/posts server(statusCode: 404, code: ..., message: "...")
```

- 헤더의 경우 키값만 표시되고 `***`으로 마스킹됩니다. 콘솔에 토큰을 남기지 않기 위함입니다.
- 요청/응답 body가 필터링 없이 출력됩니다.
- 콘솔 필터에서 `[Request]`, `[Response]`, `[Error]`를 입력하여 선택할 수 있습니다.

## 8. 설정값(BASE_URL) 주입 구조

```
Config.xcconfig          BASE_URL = https:/$()/api.example.com      (git 제외)
      │  타겟의 Debug/Release 기본 설정파일로 연결
      ▼
Resource/Info.plist      <key>BASE_URL</key><string>$(BASE_URL)</string>
      │  빌드 시 치환됨
      ▼
BaseService              Bundle.main.object(forInfoDictionaryKey: "BASE_URL")
```

- `Info.plist`에 `BASE_URL` 키값만 명시하고 다른 키들은 Xcode에서 자동 생성하여 결합합니다(`GENERATE_INFOPLIST_FILE = YES`).
- 설정값을 추가하려면 세 군데를 모두 수정합니다.
  1. `Config.xcconfig`에 `NEW_KEY = 값` 추가 (팀원들에게도 공유)
  2. `Resource/Info.plist`에 `<key>NEW_KEY</key><string>$(NEW_KEY)</string>` 추가
  3. `BaseService` 내 `InfoKey`에 case 추가 및 사용을 위해 읽어오기

## 9. 서버 명세 완료 후 수정할 점

지금은 API 명세 없이 가정으로 응답 형식을 설정해 두었습니다. 명세가 나오면 확인해주세요.

| 가정한 내용 | 다르면 고칠 곳 |
|---|---|
| 성공 응답의 실제 데이터가 `data` 키에 들어 있음 | `BaseResponseDTO` |
| 실패 응답에 문자열 `code`와 `message`가 있음 | `ErrorResponseDTO`, `ServerErrorCode` |
| 성공 여부는 HTTP 상태 코드(2xx)로 판단함 | `BaseService.decode` |
| 인증 헤더 없음 | `HeaderType`, `BaseService.makeRequest` |

실패 응답 형식이 가정과 다를 경우 디코딩에 실패하더라도 앱은 멈추지 않으며, `NetworkError.server`의 `code`는 `.unknown`, `message`는 빈 문자열로 전달됩니다.

## 10. 자주 겪는 문제

**Q. 빌드 시 `Unable to open base configuration reference file` 오류가 발생합니다.**

`Config.xcconfig` 파일이 존재하지 않습니다. [1. 처음 클론했을 때 할 일](#1-처음-클론했을-때-할-일)을 따라 만드세요.

**Q. 모든 요청이 `invalidBaseURL` 로 실패합니다.**

`Config.xcconfig` 파일에 `BASE_URL`이 없거나 `https://`로 되어있습니다. `https:/$()/호스트` 인지 확인하세요. 변경 후에는 재빌드를 해야 적용됩니다.

**Q. 응답이 200인데 `decodingFailed`가 발생합니다.**

DTO의 속성명과 타입이 서버 JSON과 일치하지 않습니다. 콘솔 `[Body]`와 DTO를 대조하여 `null` 허용 가능한 필드를 옵셔널로 전환하세요. `userId` 등 약어 표기가 다른 키값은 `CodingKeys`가 필요합니다.

**Q. 응답은 200인데 `emptyData` 가 나옵니다.**

서버에서 `data`를 주지 않는 API입니다. 반환값이 없는 Void `request`를 사용하세요.

**Q. 본문 없는 응답(204 등)에 `decodingFailed`가 발생합니다.**

Void `request` 역시 응답 본문을 JSON으로 파싱하므로 본문이 완전히 없으면 실패합니다. 그런 API가 존재한다면 `BaseService`의 Void `request`를 빈 본문을 허용하도록 수정해야 합니다.

**Q. `Core/Network` 외부에 Alamofire 타입을 사용하고 싶습니다.**

Alamofire는 `BaseService`에서만 사용하도록 강제되어 있습니다. 멀티파트 업로드와 같이 기능 확장이 필요한 경우 `BaseServiceProtocol`에 메서드를 추가하여 확장하십시오.

## 11. Alamofire가 하는 역할

Alamofire는 `URLSession` 기반의 통신 라이브러리입니다. 이 프로젝트에서는 "요청을 보내고 응답을 받아오는 일"을 맡기며, 그 외에는 직접 합니다. 따라서 `import Alamofire`는 `BaseService.swift` 하나에서만 이루어집니다.

### Alamofire를 쓰는 곳

사실 Alamofire를 호출하는 코드는 `BaseService.perform`에서 한 줄 뿐입니다.

```swift
let response = await session.request(request).serializingData().response
```

| 코드 | 하는 일 |
|---|---|
| `session` | Alamofire의 `Session`. 내부에서 `URLSession`을 관리하며, 기본값으로 `Session.default`를 씁니다 |
| `.request(request)` | 우리가 만든 `URLRequest`를 그대로 전송합니다 |
| `.serializingData()` | 응답 본문을 가공하지 않은 `Data`로 받습니다 |
| `.response` | `async`/`await`로 결과를 기다립니다. 에러를 던지지 않고 응답·데이터·에러를 한 묶음으로 돌려줍니다 |

반환된 결과로부터 사용되는 값은 세 가지입니다.

- `response.response`: 상태 코드를 포함하는 `HTTPURLResponse`
- `response.data`: 응답 데이터 `Data`
- `response.error`: 통신 실패 시 `AFError`

### Alamofire가 대신 해 주는 것

- 통신 수행: `URLSession` 태스크 생성, 실행, 대기
- `async`/`await` 연결: 콜백함수 없이 `await`로 결과값을 얻음
- 요청 취소: `.task`를 취소할 시 진행중인 요청이 같이 취소됨
- 실패 정보 제공: 인터넷 연결 오류, 타임아웃 등 실패 정보를 `AFError`로 래핑하여 제공

### 직접 처리하는 것

Alamofire에 동일한 기능이 있으나, 아래는 사용하지 않고 직접 구현하였습니다.

| 하는 일 | 담당 | Alamofire 기능을 쓰지 않는 이유 |
|---|---|---|
| URL·쿼리·body 조립 | `Endpoint.makeURLRequest` | `Endpoint`가 Alamofire를 모르게 해서 기능 폴더에서 임포트가 필요 없게 함 |
| 공통 헤더 추가 | `BaseService.makeRequest` | 헤더를 한 곳에서 `HeaderType`으로 관리 |
| 상태 코드 검사 | `BaseService.decode` | `validate()`를 쓰면 실패 응답 본문을 읽기 전에 에러가 나서, 서버의 `code`·`message`를 꺼내기 번거로움 |
| JSON 디코딩 | `BaseService.decode` | 성공은 `BaseResponseDTO`, 실패는 `ErrorResponseDTO`로 나눠 읽기 위함 |
| 에러 종류 정리 | `BaseService.makeNetworkError` | 화면 쪽이 `AFError`가 아니라 `NetworkError`만 알면 되게 함 |
| 로그 | `NetworkLogger` | 헤더 값 마스킹, DEBUG 전용 출력을 직접 제어 |

### AFError가 NetworkError로 바뀌는 과정

HTTP 응답을 전혀 못 받은 경우에만 `AFError`를 `NetworkError`로 변환합니다. 응답을 받았다면 상태코드가 4xx, 5xx라 하더라도 Alamofire는 성공한 것으로 간주하고 이후의 처리는 `decode`가 담당합니다.

| Alamofire가 알려 준 실패 | 바뀌는 에러 |
|---|---|
| 요청이 취소됨 | `CancellationError` |
| 인터넷 미연결, 연결 끊김 | `NetworkError.networkConnection` |
| 시간 초과 | `NetworkError.timeout` |
| 그 밖의 통신 실패 | `NetworkError.transportFailed` |
| 응답도 에러도 없음 | `NetworkError.invalidResponse` |

### Alamofire 기능을 더 쓰고 싶을 때

`BaseService`는 `init`에서 `Session`을 주입받기 때문에, 설정이 변경된 `Session`을 생성하여 주입하면 됩니다. 다른 파일들은 수정할 것이 없습니다.

- 타임아웃 수정: `URLSessionConfiguration`의 `timeoutIntervalForRequest`을 수정한 `Session` 이용
- 토큰 자동 첨부/재발급: `RequestInterceptor` 구현 후 `Session(interceptor:)`으로 전달
- 실패시 재시도: `RetryPolicy`를 `interceptor`에 전달
- 이미지 등 파일 업로드: `session.upload(multipartFormData:)`를 사용하는 메서드를 `BaseServiceProtocol`에 정의
