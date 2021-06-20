//
//  UnregisterRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/5/1.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

public struct UnregisterRequestConfiguration {
    public init(apiRoot: String, email: String, nonce: String, validCode: String) {
        self.apiRoot = apiRoot
        self.email = email
        self.nonce = nonce
        self.validCode = validCode
    }
    
    var apiRoot: String
    var email: String
    var nonce: String
    var validCode: String
}

struct UnregisterRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
}

public struct UnregisterRequest: DefaultRequest {
    public typealias Configuration = UnregisterRequestConfiguration
    typealias Result = UnregisterRequestResult
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    
    var configuration: UnregisterRequestConfiguration
    
    public init(configuration: UnregisterRequestConfiguration) {
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
