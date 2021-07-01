//
//  Request.swift
//  Hollow
//
//  Created by liang2kl on 2021/1/19.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Combine

public typealias ResultType = Result

/// Protocol for HTTP request types.
public protocol Request {
    /// Configuration type for the request.
    associatedtype Configuration
    /// The result produced.
    associatedtype ResultData
    /// Error type.
    associatedtype Error: Swift.Error
    /// - parameter configuration: Configuration for the request.
    init(configuration: Configuration)
    /// Perform request and fetch the data.
    /// - Parameter completion: The completion handler.
    ///
    /// The completion handler will be executed on a background thread.
    func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void)
}

/// Internal used protocol.
protocol _Request: Request {
    /// Configuration.
    var configuration: Configuration { get }
    /// Result type for the request, get directly from the server.
    associatedtype Result
}

#if swift(>=5.5)
@available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
extension Request {
    /// Async version of `performRequest(completion:)`.
    /// - Returns: The fetched data.
    /// - Throws: An ``Error`` instance.
    public func data() async throws -> ResultData {
        let result = await result()
        switch result {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }
    
    /// Async version of `performRequest(completion:)`.
    /// - Returns: The `Result` type of `ResultData` and `Error`.
    public func result() async -> ResultType<ResultData, Error> {
        return await withCheckedContinuation { continuation in
            performRequest { result in
                continuation.resume(returning: result)
            }
        }
    }
}
#endif
