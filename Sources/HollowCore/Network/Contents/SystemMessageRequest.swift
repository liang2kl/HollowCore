//
//  SystemMessageRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

/// Fetch system messages.
public struct SystemMessageRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String) {
            self.apiRoot = apiRoot
            self.token = token
        }
        
        /// The root components of the URL.
        public var apiRoot: String
        /// The access token.
        public var token: String
    }
    struct Result: DefaultRequestResult {
        var code: Int
        var msg: String?
        var data: [SystemMessage]?
    }
    public typealias ResultData = [SystemMessage]
    public typealias Error = DefaultRequestError
    var configuration: Configuration
    
    public init(configuration: Configuration) {
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
