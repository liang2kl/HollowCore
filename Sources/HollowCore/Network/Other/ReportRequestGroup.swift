//
//  ReportRequestGroup.swift
//  Hollow
//
//  Created by liang2kl on 2021/3/5.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Combine

public enum ReportRequestGroupConfiguration {
    case post(ReportPostRequestConfiguration)
    case comment(ReportCommentRequestConfiguration)
}

public struct ReportRequestGroupResult: DefaultRequestResult {
    var code: Int
    var msg: String?
}

public struct ReportRequestGroup: DefaultRequest {
    
    public typealias Configuration = ReportRequestGroupConfiguration
    typealias Result = ReportRequestGroupResult
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    
    var configuration: ReportRequestGroupConfiguration
    
    public init(configuration: ReportRequestGroupConfiguration) {
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
