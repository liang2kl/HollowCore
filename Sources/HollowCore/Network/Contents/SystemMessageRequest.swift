//
//  SystemMessageRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

/// The configuration parameter is the user token.
public struct SystemMessageRequestConfiguration {
    public init(apiRoot: String, token: String) {
        self.apiRoot = apiRoot
        self.token = token
    }
    
    var apiRoot: String
    var token: String
}

/// Wrapper for result of attempt to get system messages
struct SystemMessageRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
    var data: [SystemMessage]?
}

/// SystemMessageRequest same as default request
public struct SystemMessageRequest: DefaultRequest {
    public typealias Configuration = SystemMessageRequestConfiguration
    typealias Result = SystemMessageRequestResult
    public typealias ResultData = [SystemMessage]
    public typealias Error = DefaultRequestError
    var configuration: SystemMessageRequestConfiguration
    
    public init(configuration: SystemMessageRequestConfiguration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/contents/system_msg" + Constants.urlSuffix
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            headers: headers,
            method: .get,
            transformer: { $0.data },
            completion: completion)
    }
    
}
