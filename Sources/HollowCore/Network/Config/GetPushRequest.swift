//
//  GetPushRequest.swift
//  Hollow
//
//  Created by aliceinhollow on 7/2/2021.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation
import Alamofire

/// Get the user's push notification preferences.
public struct GetPushRequest: DefaultRequest {
    
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
        struct Data: Codable {
            var pushSystemMsg: Int
            var pushReplyMe: Int
            var pushFavorited: Int
        }
        var code: Int
        var msg: String?
        var data: Data?
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
            transformer: {
                guard let data = $0.data else { return nil }
                return .init(pushSystemMsg: data.pushSystemMsg, pushReplyMe: data.pushReplyMe, pushFavorited: data.pushFavorited)
            },
            completion: completion
        )
    }
}
