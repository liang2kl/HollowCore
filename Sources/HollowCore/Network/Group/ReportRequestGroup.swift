//
//  ReportRequestGroup.swift
//  Hollow
//
//  Created by liang2kl on 2021/3/5.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Combine

public struct ReportRequestGroup: DefaultRequest {
    
    public enum Configuration {
        case post(ReportPostRequest.Configuration)
        case comment(ReportCommentRequest.Configuration)
    }
    struct Result: DefaultRequestResult {
        var code: Int
        var msg: String?
    }
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<(), DefaultRequestError>) -> Void) {
        switch configuration {
        case .post(let configuration):
            ReportPostRequest(configuration: configuration).performRequest(completion: completion)
        case .comment(let configuration):
            ReportCommentRequest(configuration: configuration).performRequest(completion: completion)
        }
    }
}
