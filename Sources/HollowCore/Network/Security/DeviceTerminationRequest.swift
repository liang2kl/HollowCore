//
//  DeviceTerminationRequest.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Foundation
import Alamofire

/// The request parameter is the UUID of the device.
public struct DeviceTerminationRequestConfiguration {
    public init(apiRoot: String, token: String, deviceUUID: String) {
        self.apiRoot = apiRoot
        self.token = token
        self.deviceUUID = deviceUUID
    }
    
    public var apiRoot: String
    public var token: String
    public var deviceUUID: String
}

struct DeviceTerminationRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
}

public struct DeviceTerminationRequest: DefaultRequest {
    
    public typealias Configuration = DeviceTerminationRequestConfiguration
    typealias Result = DeviceTerminationRequestResult
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    
    var configuration: DeviceTerminationRequestConfiguration
    
    public init(configuration: DeviceTerminationRequestConfiguration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/security/devices/terminate" + Constants.urlSuffix
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        let parameters = ["device_uuid": self.configuration.deviceUUID]
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
