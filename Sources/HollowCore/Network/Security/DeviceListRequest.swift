//
//  DeviceListRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public struct DeviceListRequestConfiguration {
    public init(apiRoot: String, token: String) {
        self.apiRoot = apiRoot
        self.token = token
    }
    
    var apiRoot: String
    var token: String
}

struct DeviceListRequestResult: DefaultRequestResult {
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

public struct DeviceListRequestResultData: Codable {
    public var devices: [DeviceInformationType]
    public var thisDeviceUUID: String
}

public struct DeviceListRequest: DefaultRequest {
    
    public typealias Configuration = DeviceListRequestConfiguration
    typealias Result = DeviceListRequestResult
    public typealias ResultData = DeviceListRequestResultData
    public typealias Error = DefaultRequestError
    
    var configuration: DeviceListRequestConfiguration
    
    public init(configuration: DeviceListRequestConfiguration) {
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
                    DeviceInformationType(
                        deviceUUID: $0.deviceUuid,
                        loginDate: $0.loginDate.toDate() ?? Date(),
                        deviceInfo: $0.deviceInfo,
                        deviceType:
                            DeviceInformationType.DeviceType(rawValue: $0.deviceType) ??
                            DeviceInformationType.DeviceType.unknown
                    )
                })
                return ResultData(devices: devices, thisDeviceUUID: thisDeviceUUIDString)
            },
            completion: completion
        )
    }
}
