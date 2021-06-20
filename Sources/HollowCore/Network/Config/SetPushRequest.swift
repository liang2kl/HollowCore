//
//  SetPushRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/1/22.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation
import Alamofire

public struct SetPushRequestConfiguration {
    public init(apiRoot: String, token: String, type: PushNotificationType) {
        self.apiRoot = apiRoot
        self.token = token
        self.type = type
    }
    
    var apiRoot: String
    var token: String
    var type: PushNotificationType
}

struct SetPushRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
}

public struct SetPushRequest: DefaultRequest {
    public typealias Configuration = SetPushRequestConfiguration
    typealias Result = SetPushRequestResult
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    
    var configuration: SetPushRequestConfiguration
    
    public init(configuration: SetPushRequestConfiguration) {
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
