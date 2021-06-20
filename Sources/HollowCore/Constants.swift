//
//  Constants.swift
//  Hollow
//
//  Created by liang2kl on 2021/2/3.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// Shared constants.
///
/// The purpose of the nested structs is to provide namespaces.
struct Constants {
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    static let urlSuffix = "?v=v\(Constants.appVersion)&device=2"
}
