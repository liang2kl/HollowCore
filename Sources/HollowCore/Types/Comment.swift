//
//  Comment.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation

/// Comment used for result
public struct Comment: Codable {
    /// comment ID
    public var cid: Int
    public var deleted: Bool
    public var name: String
    public var permissions: [PostPermissionType]
    /// postID
    public var pid: Int
    public var tag: String?
    public var text: String?
    /// unix timestamp
    public var timestamp: Int
    /// comment ID
    public var replyTo: Int
    public var isDz: Bool
    /// image url
    public var url: String?
    public var imageMetadata: ImageMetadata?
}
