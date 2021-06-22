//
//  SystemMessage.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Foundation

/// Data representation of a system message.
public struct SystemMessage: Codable {
    public init(content: String, timestamp: Int, title: String) {
        self.content = content
        self.timestamp = timestamp
        self.title = title
    }
    
    /// Message content.
    public var content: String
    /// The time when the message was sent (unix timestamp).
    public var timestamp: Int
    /// Message title.
    public var title: String
}
