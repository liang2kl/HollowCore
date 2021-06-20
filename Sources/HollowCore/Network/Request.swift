//
//  Request.swift
//  Hollow
//
//  Created by liang2kl on 2021/1/19.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Combine

public typealias ResultType = Result

public protocol Request {
    /// Configuration type.
    associatedtype Configuration
    /// Final result produced.
    associatedtype ResultData
    /// Configuration for the request, set via initializer.
    associatedtype Error: Swift.Error
    /// - parameter configuration: Configuration for the request.
    init(configuration: Configuration)
    /// Perform request and fetch the data.
    func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void)
}

/// Protocol for HTTP request types.
protocol _Request: Request {
    var configuration: Configuration { get }
    /// Result type for the request, get directly from the server.
    associatedtype Result
}

@available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
extension Request {
    /// Async version of `performRequest(completion:)`.
    public func result() async throws -> ResultData {
        return try await withCheckedThrowingContinuation({ continuation in
            performRequest(completion: { result in
                if case .success(let data) = result {
                    continuation.resume(returning: data)
                }
                if case .failure(let error) = result {
                    continuation.resume(throwing: error)
                }
            })
        })
    }
}
