//
//  SystemMessage.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Foundation

/// Data representation of a system message
public struct SystemMessage: Codable {
    public init(content: String, timestamp: Int, title: String) {
        self.content = content
        self.timestamp = timestamp
        self.title = title
    }
    
    /// message content
    public var content: String
    /// unix time stamp of this message
    public var timestamp: Int
    /// message title
    public var title: String
}
