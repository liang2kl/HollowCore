# HollowCore

Swift 语言的树洞网络请求库。

A library for networking in Tree Hollow, written in Swift.

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

| Request | Function |
| --- | --- |
| `GetConfigRequest` | fetch Tree Hollow config |
| `GetPushRequest` | get push notification preferences |
| `SetPushRequest` | set push notification preferences |

### Contents

| Request | Function |
| --- | --- |
| `AttentionListRequest` | fetch attention list |
| `AttentiionListSearchRequest` | search in attention list |
| `PostDetailRequest` | fetch specific post |
| `PostListRequest` | fetch timeline posts |
| `RandomListRequest` | search wander posts |
| `SearchRequest` | search in all posts |
| `SystemMessageRequest` | fetch system message |

### Edit

| Request | Function |
| --- | --- |
| `EditAttentionRequest` | toggle attention state for specific post |
| `ReportCommentRequest` | report specific comment |
| `ReportPostRequest` | report specific post |

### Security

| Request | Function |
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

| Request | Function |
| --- | --- |
| `SendCommentRequest` | send comment |
| `SendPostRequest` | send post |
| `SendVoteRequest` | send vote |

## 使用 Usage

### Completion API

```swift
let request = PostListRequest(configuration: configuration)

request.performRequest { result in
    switch result {
    case .success(let data):
        // Handle data
    case .failure(let error):
        // Handle error
    }
}
```

### Async API

> 要求 macOS 12+、iOS 15+。
> Requires macOS 12+ and iOS 15+.

```swift
let request = PostListRequest(configuration: configuration)

do {
    let data = try await request.result()
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

### Publisher

#### 单个请求 Publisher for a Single Request

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

#### 多个请求 Publisher for Multiple Requests

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
