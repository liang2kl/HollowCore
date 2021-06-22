//
//  LogoutRequest.swift
//  Hollow
//
//  Created by aliceinhollow on 6/2/2021.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation
import Alamofire

/// Logout.
public struct LogoutRequest: DefaultRequest {
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
    }
    
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
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

