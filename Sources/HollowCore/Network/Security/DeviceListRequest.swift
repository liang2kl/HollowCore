//
//  DeviceListRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public struct DeviceListRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String) {
            self.apiRoot = apiRoot
            self.token = token
        }
        
        public var apiRoot: String
        public var token: String
    }
    
    struct Result: DefaultRequestResult {
        struct DeviceListResult: Codable {
            var deviceUuid: String
            var loginDate: String
            var deviceInfo: String
            var deviceType: Int
        }
        var code: Int
        var msg: String?
        var data: [DeviceListResult]?
        var thisDevice: String?
    }
    
    public struct ResultData: Codable {
        public init(devices: [DeviceInformation], thisDeviceUUID: String) {
            self.devices = devices
            self.thisDeviceUUID = thisDeviceUUID
        }
        
        public var devices: [DeviceInformation]
        public var thisDeviceUUID: String
    }
    
    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/security/devices/list" + Constants.urlSuffix
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            headers: headers,
            method: .get,
            transformer: { result in
                guard let data = result.data, let thisDeviceUUIDString = result.thisDevice else { return nil }
                let devices = data.map({
                    DeviceInformation(
                        deviceUUID: $0.deviceUuid,
                        loginDate: $0.loginDate.toDate() ?? Date(),
                        deviceInfo: $0.deviceInfo,
                        deviceType:
                            DeviceInformation.DeviceType(rawValue: $0.deviceType) ??
                            DeviceInformation.DeviceType.unknown
                    )
                })
                return ResultData(devices: devices, thisDeviceUUID: thisDeviceUUIDString)
            },
            completion: completion
        )
    }
}
