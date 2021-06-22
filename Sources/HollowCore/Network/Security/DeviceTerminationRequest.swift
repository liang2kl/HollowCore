//
//  DeviceTerminationRequest.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Foundation
import Alamofire

public struct DeviceTerminationRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String, deviceUUID: String) {
            self.apiRoot = apiRoot
            self.token = token
            self.deviceUUID = deviceUUID
        }
        
        public var apiRoot: String
        public var token: String
        public var deviceUUID: String
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
