//
//  UnregisterRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/5/1.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// Unregister.
public struct UnregisterRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, email: String, nonce: String, validCode: String) {
            self.apiRoot = apiRoot
            self.email = email
            self.nonce = nonce
            self.validCode = validCode
        }
        
        /// The root components of the URL.
        public var apiRoot: String
        /// User's email.
        public var email: String
        /// The identifier received from the registration process
        public var nonce: String
        /// The valid code received by the user.
        public var validCode: String
    }

    struct Result: DefaultRequestResult {
        var code: Int
        var msg: String?
    }

    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let parameters: [String : Any] = [
            "email" : configuration.email,
            "nonce" : configuration.nonce,
            "valid_code" : configuration.validCode
        ]
        
        let urlPath = "v3/security/login/unregister" + Constants.urlSuffix
        
        performRequest(
            urlRoot: configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            method: .post,
            transformer: { _ in () },
            completion: completion
        )
    }
}
