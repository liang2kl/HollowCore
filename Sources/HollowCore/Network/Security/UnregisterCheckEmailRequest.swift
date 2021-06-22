//
//  UnregisterCheckEmailRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/5/1.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// Check for registration state.
public struct UnregisterCheckEmailRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, email: String, recaptchaToken: String? = nil) {
            self.apiRoot = apiRoot
            self.email = email
            self.recaptchaToken = recaptchaToken
        }
        
        /// The root components of the URL.
        public var apiRoot: String
        /// User's email.
        var email: String
        /// `reCAPTCHA` validation token. Required when the previous request result is ``UnregisterCheckEmailRequest/ResultData/needReCAPTCHA``.
        var recaptchaToken: String?
        let recaptchaVersion = "v2"
    }

    struct Result: DefaultRequestResult {
        var code: Int
        var msg: String?
    }
    
    public enum ResultData: Int {
        case success = 1
        case needReCAPTCHA = 3
    }

    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        var parameters: [String : Any] = [
            "email" : configuration.email,
            "recaptcha_version" : configuration.recaptchaVersion
        ]
        
        if let token = configuration.recaptchaToken {
            parameters["recaptcha_token"] = token
        }
        
        let urlPath = "v3/security/login/check_email_unregister" + Constants.urlSuffix
        
        performRequest(
            urlRoot: configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            method: .post,
            transformer: { result in
                guard result.code == 1 || result.code == 3 else { return nil }
                return ResultData(rawValue: result.code)
            },
            completion: completion
        )
    }
}
