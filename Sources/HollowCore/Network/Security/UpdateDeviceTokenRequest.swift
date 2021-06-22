//
//  UpdateDeviceTokenRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/2/17.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation
import Alamofire

/// Update the device token for `APNs`.
public struct UpdateDeviceTokenRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String, deviceToken: Data) {
            self.apiRoot = apiRoot
            self.token = token
            self.deviceToken = deviceToken
        }
        
        /// The root components of the URL.
        public var apiRoot: String
        /// The access token.
        public var token: String
        /// Device token for APNs.
        public var deviceToken: Data
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
        let urlPath = "v3/security/update_ios_token" + Constants.urlSuffix
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        let parameters = [
            "ios_device_token": self.configuration.deviceToken.hexEncodedString()
        ]
        
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            headers: headers,
            method: .post,
            transformer: { _ in () },
            completion: completion
        )
    }
    
}
