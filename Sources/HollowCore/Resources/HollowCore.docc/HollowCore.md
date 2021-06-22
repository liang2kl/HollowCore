# ``HollowCore``

A framework for networking in `TreeHollow`.

## Overview

HollowCore provides a unified, simple set of APIs to interact with the HTTP APIs that the `TreeHollow` backend server provides.

## Usage

All APIs are provided in the context of protocol ``Request``. A request type is a `struct` that takes its configuration parameters from its nested type ``Request/Configuration`` and returns a strongly-typed ``Request/ResultData`` instance which you can directly use in Swift.

### Initialization

To create a request, simply provide the configuration:

```swift
let configuration = PostListRequest.Configuration(...)
let request = PostListRequest(configuration: configuration)
```

### Starting the Request, Receiving Result, and Handling Errors

There are three ways to start an ``Request``:

#### Completion Handler

Provide the ``Request/performRequest(completion:)`` with a completion handler that takes `Result<R.ResultData, R.Error>` as the argument, where `R` is the request type. The handler will be called when the request is finished.

```swift
request.performRequest { result in
    switch result {
    case .success(let data):
        // Handle data
    case .failure(let error):
        // Handle error
    }
}
```

Noted that `R.Error` is a specific type which provides information of the error you can make use of.

#### async/await

For Swift 5.5+, an `async` method ``Request/result()`` is provided in addition to ``Request/performRequest(completion:)``.

```swift
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

As the type for the error of a `PostListRequest` is `PostListRequest.Error`, the third block will never be reached.

#### Publisher

For `Combine` framwork users, a publisher API is provided. You can make use of this API to combine multiple requests.

For a single request, use the ``Request/publisher`` property:

```swift
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

For multiple requests, use the static ``Request/publisher(for:retries:)`` method:

```swift
let requests: [PostListRequest] = [...]

PostListRequest.publisher(for: requests)
    .sink(
        receiveCompletion: {...}, 
        receiveValue: { index, result in
            // Handle result for request at `index`
        }
    )
    .store(...)
```

## Topics

### Request Protocol

- ``Request``

### Tree Hollow Configuration

- ``GetConfigRequest``

### Registeration and Login

- ``EmailCheckRequest``
- ``AccountCreationRequest``
- ``LoginRequest``

### Account Operations

- ``ChangePasswordRequest``
- ``DeviceListRequest``
- ``DeviceTerminationRequest``
- ``LogoutRequest``
- ``UnregisterCheckEmailRequest``
- ``UnregisterRequest``
- ``UpdateDeviceTokenRequest``

### Notification Configurations

- ``GetPushRequest``
- ``SetPushRequest``

### Retrieving Contents

- ``PostDetailRequest``
- ``PostListRequest``
- ``RandomListRequest``
- ``AttentionListRequest``
- ``SearchRequest``
- ``AttentionListSearchRequest``
- ``SystemMessageRequest``

### Sending Contents

- ``SendPostRequest``
- ``SendCommentRequest``
- ``SendVoteRequest``

### Editing and Reporting

- ``EditAttentionRequest``
- ``ReportPostRequest``
- ``ReportCommentRequest``

### Request Groups

The request group is a type conforming to ``Request`` that can be used to perform different request. These requests share the same ``Request/ResultData`` type.

- ``PostListRequestGroup``
- ``ReportRequestGroup``

### Result Types

- ``HollowConfig``
- ``PostWrapper``
- ``Post``
- ``Comment``
- ``Vote``
- ``ImageMetadata``
- ``SystemMessage``
- ``DeviceInformation``
- ``PushNotificationType``
- ``PostPermissionType``

### Others

- ``RequestPublisher``
- ``DefaultRequestError``
