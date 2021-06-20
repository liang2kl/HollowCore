//
//  AccountCreation.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Alamofire
import Foundation

/// Configuraions for creating an account.
public struct AccountCreationRequestConfiguration {
    public init(apiRoot: String, email: String, password: String, deviceInfo: String, validCode: String? = nil, deviceToken: String? = nil) {
        self.apiRoot = apiRoot
        self.email = email
        self.password = password
        self.deviceInfo = deviceInfo
        self.validCode = validCode
        self.deviceToken = deviceToken
    }
    
    var apiRoot: String
    /// User's email.
    var email: String
    /// store passwd
    var password: String
    /// Device type, 2 for iOS.
    let deviceType = 2
    /// Device information.
    var deviceInfo: String
    /// Email valid code, optional, but one of `oldToken` and `validCode` must be present.
    var validCode: String?
    // TODO: Device token for APNs
    var deviceToken: String?
}

/// Result of account creation attempt.
public struct AccountCreationRequestResultData {
    /// Access token.
    public var token: String
    /// Device UUID
    public var uuid: UUID
}

struct AccountCreationRequestResult: DefaultRequestResult {
    /// The type of result received.
    var code: Int
    /// Access token.
    var token: String?
    /// Device UUID
    var uuid: UUID?
    /// Error mssage.
    var msg: String?
}

public struct AccountCreationRequest: DefaultRequest {
    public typealias Configuration = AccountCreationRequestConfiguration
    typealias Result = AccountCreationRequestResult
    public typealias ResultData = AccountCreationRequestResultData
    public typealias Error = DefaultRequestError
    
    var configuration: AccountCreationRequestConfiguration
    
    public init(configuration: AccountCreationRequestConfiguration) {
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
