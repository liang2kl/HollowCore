//
//  UpdateDeviceTokenRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/2/17.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation
import Alamofire

public struct UpdateDeviceTokenRequestConfiguration {
    public init(apiRoot: String, token: String, deviceToken: Data) {
        self.apiRoot = apiRoot
        self.token = token
        self.deviceToken = deviceToken
    }
    
    public var apiRoot: String
    public var token: String
    public var deviceToken: Data
}

struct UpdateDeviceTokenRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
}

public struct UpdateDeviceTokenRequest: DefaultRequest {
    public typealias Configuration = UpdateDeviceTokenRequestConfiguration
    typealias Result = UpdateDeviceTokenRequestResult
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError

    var configuration: UpdateDeviceTokenRequestConfiguration
    
    public init(configuration: UpdateDeviceTokenRequestConfiguration) {
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
