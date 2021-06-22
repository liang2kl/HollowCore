//
//  ChangePassword.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Alamofire
import Foundation

public struct ChangePasswordRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, email: String, oldPassword: String, newPassword: String) {
            self.apiRoot = apiRoot
            self.email = email
            self.oldPassword = oldPassword
            self.newPassword = newPassword
        }
        
        public var apiRoot: String
        /// User's email
        public var email: String
        /// Previous hashed password
        public var oldPassword: String
        /// New hashed password
        public var newPassword: String
    }
    struct Result: DefaultRequestResult {
        /// Result type of changing password.
        /// The type of result received.
        var code: Int
        /// Error mssage.
        var msg: String?
    }
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
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
