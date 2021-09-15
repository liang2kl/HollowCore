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
