//
//  DeviceInformationType.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Foundation

/// Information of a logged-in device.
public struct DeviceInformation: Codable {
    public init(deviceUUID: String, loginDate: Date, deviceInfo: String, deviceType: DeviceInformation.DeviceType) {
        self.deviceUUID = deviceUUID
        self.loginDate = loginDate
        self.deviceInfo = deviceInfo
        self.deviceType = deviceType
    }
    
    /// Device type.
    public enum DeviceType: Int, CustomStringConvertible , Codable {
        case web = 0
        case android = 1
        case ios = 2
        case unknown = -1
        
        public var description: String {
            switch self {
            // No Localization
            case .web: return "Web"
            case .android: return "Android"
            case .ios: return "iOS"
            case .unknown: return "Unknown"
            }
        }
    }
    /// UUID of the device.
    public var deviceUUID: String
    /// Login date of the device.
    public var loginDate: Date
    /// Device desciption.
    public var deviceInfo: String
    /// Device type.
    public var deviceType: DeviceType
}
