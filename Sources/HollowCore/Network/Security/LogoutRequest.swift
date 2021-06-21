//
//  LogoutRequest.swift
//  Hollow
//
//  Created by aliceinhollow on 6/2/2021.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation
import Alamofire

public struct LogoutRequestConfiguration {
    public init(apiRoot: String, token: String) {
        self.apiRoot = apiRoot
        self.token = token
    }
    
    public var apiRoot: String
    public var token: String
}

struct LogoutRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
}

public struct LogoutRequest: DefaultRequest {
    public typealias Configuration = LogoutRequestConfiguration
    typealias Result = LogoutRequestResult
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    
    var configuration: LogoutRequestConfiguration
    
    public init(configuration: LogoutRequestConfiguration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/security/logout" + Constants.urlSuffix
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            headers: headers,
            method: .post,
            transformer: { _ in () },
            completion: completion
        )
    }
}

