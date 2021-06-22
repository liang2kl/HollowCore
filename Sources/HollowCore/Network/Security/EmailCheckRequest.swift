//
//  EmailCheck.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Alamofire
import Foundation

public struct EmailCheckRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, email: String, reCAPTCHAInfo: (token: String, version: ReCAPTCHAVersion)? = nil) {
            self.apiRoot = apiRoot
            self.email = email
            self.reCAPTCHAInfo = reCAPTCHAInfo
        }
        
        public var apiRoot: String
        /// `reCAPTCHA` version
        //    NO USE!
        public enum ReCAPTCHAVersion: String {
            case v2 = "v2"
            case v3 = "v3"
        }
        /// User's email to be checked, required
        public var email: String

        /// Info of `reCAPTCHA`, optional
        public var reCAPTCHAInfo: (token: String, version: ReCAPTCHAVersion)?
    }
    
    struct Result: DefaultRequestResult {
        var code: Int
        var msg: String?
    }
    
    public enum ResultData: Int, Equatable {
        /// Old user, shuold input password to login.
        case oldUser = 0
        /// New user, should check email for valid code and create password to sign up.
        case newUser = 1
        /// New user with old thuhole token, should create password to sign up.
        case newUserWithToken = 2
        /// Need recatpcha verification, we need to create a recaptcha popover.
        case reCAPTCHANeeded = 3
    }

    public typealias Error = DefaultRequestError

    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        var parameters = ["email": self.configuration.email]
        if let reCAPTCHAInfo = self.configuration.reCAPTCHAInfo {
            parameters["recaptcha_version"] = reCAPTCHAInfo.version.rawValue
            parameters["recaptcha_token"] = reCAPTCHAInfo.token
        }
        let urlPath = "v3/security/login/check_email" + Constants.urlSuffix
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            method: .post,
            transformer: { ResultData(rawValue: $0.code) },
            completion: completion
        )
    }
}
