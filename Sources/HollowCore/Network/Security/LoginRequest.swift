//
//  LoginRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/1/18.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Alamofire
import Foundation

/// Login.
public struct LoginRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, email: String, password: String, deviceInfo: String, deviceToken: Data? = nil) {
            self.apiRoot = apiRoot
            self.email = email
            self.password = password
            self.deviceInfo = deviceInfo
            self.deviceToken = deviceToken
        }
        
        /// The root components of the URL.
        public var apiRoot: String
        /// User's email.
        public var email: String
        /// The original password string.
        public var password: String
        /// Device type, 2 for iOS.
        let deviceType = 2
        /// Device information.
        public var deviceInfo: String
        /// Device token for APNs.
        public var deviceToken: Data?
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
            parameters["ios_device_token"] = token.hexEncodedString()
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
