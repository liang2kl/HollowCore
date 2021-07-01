# HollowCore

Swift 语言的树洞网络请求库。

A library for networking in Tree Hollow, written in Swift.

使用此库的一个例子：[treehollow-v3-ios](https://github.com/treehollow/treehollow-v3-ios)

An example of using this package can be found in [treehollow-v3-ios](https://github.com/treehollow/treehollow-v3-ios).

## 要求 Requirements

| Platform | Minimum Swift Version | Installation | Status |
| --- | --- | --- | --- |
| iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+ | 5.3 | Swift Package Manager | Partially Tested |

## 安装 Installation

使用 Swift Package Manager：

Using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/liang2kl/HollowCore.git", .upToNextMajor(from: "0.1"))
]
```

## API 列表 List

### Config

| Request | Intent |
| --- | --- |
| `GetConfigRequest` | fetch Tree Hollow config |
| `GetPushRequest` | get push notification preferences |
| `SetPushRequest` | set push notification preferences |

### Contents

| Request | Intent |
| --- | --- |
| `AttentionListRequest` | fetch attention list |
| `AttentiionListSearchRequest` | search in attention list |
| `PostDetailRequest` | fetch specific post |
| `PostListRequest` | fetch timeline posts |
| `RandomListRequest` | fetch wander posts |
| `SearchRequest` | search in all posts |
| `SystemMessageRequest` | fetch system message |

### Edit

| Request | Intent |
| --- | --- |
| `EditAttentionRequest` | toggle attention state for specific post |
| `ReportCommentRequest` | report specific comment |
| `ReportPostRequest` | report specific post |

### Security

| Request | Intent |
| --- | --- |
| `AccountCreationRequest` | register |
| `ChangePasswordRequest` | change password |
| `DeviceListRequest` | fetch info of currently-online devices |
| `DeviceTerminationRequest` | terminate session of specific device |
| `EmailCheckRequest` | check registration state |
| `LoginRequest` | login |
| `LogoutRequest` | logout |
| `UnregisterCheckRequest` | check unregistration state |
| `UnregisterRequest` | unregister |
| `UpdateDeviceTokenRequest` | update token for remote notifications |

### Send

| Request | Intent |
| --- | --- |
| `SendCommentRequest` | send comment |
| `SendPostRequest` | send post |
| `SendVoteRequest` | send vote |

## 使用 Usage

### Completion API

```swift
let request = PostListRequest(configuration: configuration)

request.performRequest { result in  // Swift.Result<ResultData, Error>
    switch result {
    case .success(let data):
        // Handle data
    case .failure(let error):
        // Handle error
    }
}
```

### Async API

> 要求 macOS 12+、iOS 15+ / Requires macOS 12+ and iOS 15+

```swift
let request = PostListRequest(configuration: configuration)

do {
    let data = try await request.data() // ResultData
    // Handle result
} catch let error as PostListRequest.Error {
    // Handle error with specific type
    switch error {
    case .tokenExpiredError:
        ...
    }
} catch {
    // Not reachable
}
```

```swift
let request = PostListRequest(configuration: configuration)
let result = await request.result() // Swift.Result<ResultData, Error>

switch result {...}
```

### Publisher

#### 单个请求 Single Request

```swift
let request = PostListRequest(configuration: configuration)

request.publisher
    .sink(
        receiveCompletion: { completion in
            switch completion {
            case .finished:
                // Request completed
            case .failure(let error)
                // Handler error
            }
        }, 
        receiveValue: { data in
            // Handle data
        }
    )
    .store(...)
```

#### 多个请求 Multiple Requests

```swift
let requests: [PostDetailRequest] = [...]

PostDetailRequest.publisher(for: requests)
    .sink(
        receiveCompletion: {...}, 
        receiveValue: { index, result in
            // Handle result for request at `index`
        }
    )
    .store(...)
```

## TODO

- 注释
- 文档
- Unit Test
