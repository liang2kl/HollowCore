//
//  EmailCheck.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Alamofire
import Foundation

/// Configurations for email check
public struct EmailCheckRequestConfiguration {
    public init(apiRoot: String, email: String, reCAPTCHAInfo: (token: String, version: EmailCheckRequestConfiguration.ReCAPTCHAVersion)? = nil) {
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

/// Result Data of EmailCheck
public enum EmailCheckType: Int, Equatable {
    /// Old user, shuold input password to login.
    case oldUser = 0
    /// New user, should check email for valid code and create password to sign up.
    case newUser = 1
    /// New user with old thuhole token, should create password to sign up.
    case newUserWithToken = 2
    /// Need recatpcha verification, we need to create a recaptcha popover.
    case reCAPTCHANeeded = 3
}

/// Result of email checking.
struct EmailCheckRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
}

public struct EmailCheckRequest: DefaultRequest {
    
    public typealias Configuration = EmailCheckRequestConfiguration
    typealias Result = EmailCheckRequestResult
    public typealias ResultData = EmailCheckType
    public typealias Error = DefaultRequestError

    var configuration: EmailCheckRequestConfiguration
    
    public init(configuration: EmailCheckRequestConfiguration) {
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
            transformer: { EmailCheckType(rawValue: $0.code) },
            completion: completion
        )
    }
}
