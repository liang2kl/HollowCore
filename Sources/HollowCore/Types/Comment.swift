//
//  Comment.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation

/// Data type representing a comment.
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
    
    /// Comment id.
    public var cid: Int
    /// Whether the comment has been deleted.
    public var deleted: Bool
    /// The nickname to display.
    public var name: String
    /// The permissions that current user have on this comment.
    public var permissions: [PostPermissionType]
    /// The id of the post.
    public var pid: Int
    /// The tag of the comment.
    public var tag: String?
    /// The content of the comment.
    public var text: String?
    /// The time of the comment (unix timestamp).
    public var timestamp: Int
    /// The id of the comment that this comment is replying to.
    ///
    /// This value is `-1` if replying to the post.
    public var replyTo: Int
    /// Whether the author of the comment is the author of the post.
    public var isDz: Bool
    /// Image url.
    public var url: String?
    /// Height and width information of the image.
    public var imageMetadata: ImageMetadata?
}
