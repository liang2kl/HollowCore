//
//  Comment.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation

/// Comment used for result
public struct Comment: Codable {
    public init(cid: Int, deleted: Bool, name: String, permissions: [PostPermissionType], pid: Int, tag: String? = nil, text: String? = nil, timestamp: Int, replyTo: Int, isDz: Bool, url: String? = nil, imageMetadata: ImageMetadata? = nil) {
        self.cid = cid
        self.deleted = deleted
        self.name = name
        self.permissions = permissions
        self.pid = pid
        self.tag = tag
        self.text = text
        self.timestamp = timestamp
        self.replyTo = replyTo
        self.isDz = isDz
        self.url = url
        self.imageMetadata = imageMetadata
    }
    
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
