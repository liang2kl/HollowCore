//
//  LoginRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/1/18.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Alamofire
import Foundation

public struct LoginRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, email: String, password: String, deviceInfo: String, deviceToken: String? = nil) {
            self.apiRoot = apiRoot
            self.email = email
            self.password = password
            self.deviceInfo = deviceInfo
            self.deviceToken = deviceToken
        }
        
        public var apiRoot: String
        public var email: String
        public var password: String
        let deviceType = 2
        public var deviceInfo: String
        public var deviceToken: String?
    }

    struct Result: DefaultRequestResult {
        var code: Int
        var token: String?
        var uuid: UUID?
        var msg: String?
    }

    public struct ResultData {
        public var token: String
        public var uuid: UUID
        public var message: String?
    }

    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        var parameters = [
                "email": self.configuration.email,
                "password_hashed": self.configuration.password.sha256().sha256(),
                "device_type": self.configuration.deviceType.string,
                "device_info": self.configuration.deviceInfo,
            ]
        if let token = configuration.deviceToken {
            parameters["ios_device_token"] = token
        }
        let urlPath = "v3/security/login/login" + Constants.urlSuffix
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            method: .post,
            transformer: { result in
                guard let token = result.token, let uuid = result.uuid else { return nil }
                return ResultData(token: token, uuid: uuid, message: result.msg)
            },
            completion: completion
        )
    }
}
