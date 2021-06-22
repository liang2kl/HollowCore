//
//  GetPushRequest.swift
//  Hollow
//
//  Created by aliceinhollow on 7/2/2021.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation
import Alamofire

public struct GetPushRequest: DefaultRequest {
    
    public struct Configuration {
        public init(apiRoot: String, token: String) {
            self.apiRoot = apiRoot
            self.token = token
        }
        
        public var apiRoot: String
        public var token: String
    }
    struct Result: DefaultRequestResult {
        public var code: Int
        public var msg: String?
        public var data: PushNotificationType?
    }
    public typealias ResultData = PushNotificationType
    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/config/get_push" + Constants.urlSuffix
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
            completion: completion
        )
    }
}
