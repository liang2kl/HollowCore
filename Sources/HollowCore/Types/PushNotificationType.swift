//
//  PushNotificationType.swift
//  Hollow
//
//  Created by aliceinhollow on 7/2/2021.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// The preference of notifications.
public struct PushNotificationType: Codable, Equatable {
    public init(pushSystemMsg: Bool, pushReplyMe: Bool, pushFavorited: Bool) {
        self.pushSystemMsg = pushSystemMsg
        self.pushReplyMe = pushReplyMe
        self.pushFavorited = pushFavorited
    }
    
    init(pushSystemMsg: Int, pushReplyMe: Int, pushFavorited: Int) {
        self.pushSystemMsg = pushSystemMsg != 0
        self.pushReplyMe = pushReplyMe != 0
        self.pushFavorited = pushFavorited != 0
    }
    
    /// Whether to send notification on receiving system messages.
    public var pushSystemMsg: Bool
    /// Whether to send notification on receiving replies.
    public var pushReplyMe: Bool
    /// Whether to send notification on receiving updates of posts on attention list.
    public var pushFavorited: Bool
}

