//
//  ChangePassword.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Alamofire
import Foundation

/// Configurations for changing password.
public struct ChangePasswordRequestConfiguration {
    public init(apiRoot: String, email: String, oldPassword: String, newPassword: String) {
        self.apiRoot = apiRoot
        self.email = email
        self.oldPassword = oldPassword
        self.newPassword = newPassword
    }
    
    var apiRoot: String
    /// User's email
    var email: String
    /// Previous hashed password
    var oldPassword: String
    /// New hashed password
    var newPassword: String
}

/// Result of an changing password attempt.
struct ChangePasswordRequestResult: DefaultRequestResult {
    /// Result type of changing password.
    /// The type of result received.
    var code: Int
    /// Error mssage.
    var msg: String?
}

public struct ChangePasswordRequest: DefaultRequest {
    public typealias Configuration = ChangePasswordRequestConfiguration
    typealias Result = ChangePasswordRequestResult
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    
    var configuration: ChangePasswordRequestConfiguration
    
    public init(configuration: ChangePasswordRequestConfiguration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let parameters = [
            "email": self.configuration.email,
            "old_password_hashed": self.configuration.oldPassword.sha256().sha256(),
            "new_password_hashed": self.configuration.newPassword.sha256().sha256(),
        ]
        let urlPath = "v3/security/login/change_password" + Constants.urlSuffix
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            method: .post,
            transformer: { _ in () },
            completion: completion
        )
    }
}
