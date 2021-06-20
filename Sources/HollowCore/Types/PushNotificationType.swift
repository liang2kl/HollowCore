//
//  PushNotificationType.swift
//  Hollow
//
//  Created by aliceinhollow on 7/2/2021.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

public struct PushNotificationType: Codable {
    public var pushSystemMsg: Bool
    public var pushReplyMe: Bool
    public var pushFavorited: Bool
}

