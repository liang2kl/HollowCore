//
//  SetPushRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/1/22.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation
import Alamofire

public struct SetPushRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String, type: PushNotificationType) {
            self.apiRoot = apiRoot
            self.token = token
            self.type = type
        }
        
        public var apiRoot: String
        public var token: String
        public var type: PushNotificationType
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
        let urlPath = "v3/config/set_push" + Constants.urlSuffix
        let parameters = [
            "push_system_msg": self.configuration.type.pushSystemMsg.int,
            "push_reply_me": self.configuration.type.pushReplyMe.int,
            "push_favorited": self.configuration.type.pushFavorited.int,
        ]
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            headers: headers,
            method: .post,
            transformer: { _ in () },
            completion: completion
        )
    }
}
