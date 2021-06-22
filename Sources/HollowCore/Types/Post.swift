//
//  Post.swift
//  Hollow
//
//  Created by aliceinhollow on 11/2/2021.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// Post permissions
public enum PostPermissionType: String, Codable, CaseIterable {
    case report = "report"
    case fold = "fold"
    case setTag = "set_tag"
    case delete = "delete"
    case undeleteUnban = "undelete_unban"
    case deleteBan = "delete_ban"
    case unban = "unban"
}

/// Post for request result, see `http-api doc`
public struct Post: Codable {
    public init(attention: Bool, deleted: Bool, likenum: Int, permissions: [PostPermissionType], pid: Int, reply: Int, tag: String? = nil, text: String, timestamp: Int, updatedAt: Int, url: String? = nil, imageMetadata: ImageMetadata? = nil, vote: Vote? = nil) {
        self.attention = attention
        self.deleted = deleted
        self.likenum = likenum
        self.permissions = permissions
        self.pid = pid
        self.reply = reply
        self.tag = tag
        self.text = text
        self.timestamp = timestamp
        self.updatedAt = updatedAt
        self.url = url
        self.imageMetadata = imageMetadata
        self.vote = vote
    }
    
    public var attention: Bool
    public var deleted: Bool
    public var likenum: Int
    public var permissions: [PostPermissionType]
    /// postId
    public var pid: Int
    public var reply: Int
    public var tag: String?
    public var text: String
    public var timestamp: Int
    /// updateTimestamp
    public var updatedAt: Int
    /// `url` entry in backend API, imageURL, this name will be deprecated
    public var url: String?
    public var imageMetadata: ImageMetadata?
    public var vote: Vote?
}
