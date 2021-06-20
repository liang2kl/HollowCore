//
//  UnregisterCheckEmailRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/5/1.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

public struct UnregisterCheckEmailRequestConfiguration {
    public init(apiRoot: String, email: String, recaptchaToken: String? = nil) {
        self.apiRoot = apiRoot
        self.email = email
        self.recaptchaToken = recaptchaToken
    }
    
    var apiRoot: String
    var email: String
    var recaptchaToken: String?
    let recaptchaVersion = "v2"
}

struct UnregisterCheckEmailRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
}

public enum UnregisterCheckEmailRequestResultData: Int {
    case success = 1
    case needReCAPTCHA = 3
}

public struct UnregisterCheckEmailRequest: DefaultRequest {
    public typealias Configuration = UnregisterCheckEmailRequestConfiguration
    typealias Result = UnregisterCheckEmailRequestResult
    public typealias ResultData = UnregisterCheckEmailRequestResultData
    public typealias Error = DefaultRequestError
    
    var configuration: UnregisterCheckEmailRequestConfiguration
    
    public init(configuration: UnregisterCheckEmailRequestConfiguration) {
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
