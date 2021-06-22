//
//  AccountCreation.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Alamofire
import Foundation

public struct AccountCreationRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, email: String, password: String, deviceInfo: String, validCode: String? = nil, deviceToken: String? = nil) {
            self.apiRoot = apiRoot
            self.email = email
            self.password = password
            self.deviceInfo = deviceInfo
            self.validCode = validCode
            self.deviceToken = deviceToken
        }
        
        public var apiRoot: String
        /// User's email.
        public var email: String
        /// store passwd
        public var password: String
        /// Device type, 2 for iOS.
        let deviceType = 2
        /// Device information.
        public var deviceInfo: String
        /// Email valid code, optional, but one of `oldToken` and `validCode` must be present.
        public var validCode: String?
        // TODO: Device token for APNs
        public var deviceToken: String?
    }
    
    struct Result: DefaultRequestResult {
        /// The type of result received.
        var code: Int
        /// Access token.
        var token: String?
        /// Device UUID
        var uuid: UUID?
        /// Error mssage.
        var msg: String?
    }
    
    public struct ResultData {
        /// Access token.
        public var token: String
        /// Device UUID
        public var uuid: UUID
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
        
        if let validCode = self.configuration.validCode {
            parameters["valid_code"] = validCode
        }
        
        let urlPath = "v3/security/login/create_account" + Constants.urlSuffix
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            method: .post,
            transformer: { result in
                guard let token = result.token, let uuid = result.uuid else { return nil }
                return ResultData(token: token, uuid: uuid)
            },
            completion: completion
        )
    }
}
