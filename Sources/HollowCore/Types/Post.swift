//
//  Post.swift
//  Hollow
//
//  Created by aliceinhollow on 11/2/2021.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// Permissions of a post or a comment.
public enum PostPermissionType: String, Codable, CaseIterable {
    /// The user can report this post / comment.
    case report = "report"
    /// The user can fold this post / comment with specific tag.
    case fold = "fold"
    /// The user can set specific tag.
    case setTag = "set_tag"
    /// The user can delete this post / comment.
    case delete = "delete"
    /// The user can undelete this post / comment and unban the user.
    case undeleteUnban = "undelete_unban"
    /// The user can delete this post / comment.
    case deleteBan = "delete_ban"
    /// The user can undelete the user.
    case unban = "unban"
}

/// The data type representing a post.
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
    
    /// Whether this post is in the attention list.
    public var attention: Bool
    /// Whether this post has been deleted.
    public var deleted: Bool
    /// The total attention count of this post.
    public var likenum: Int
    /// The permissions that current user have on this post.
    public var permissions: [PostPermissionType]
    /// Post id.
    public var pid: Int
    /// The total reply count of this post.
    public var reply: Int
    /// The tag of the post.
    public var tag: String?
    /// The content of the post.
    public var text: String
    /// The time when the post posted (unix timestamp).
    public var timestamp: Int
    /// The last time this post is modified.
    public var updatedAt: Int
    /// The URL suffix for the image.
    public var url: String?
    /// Height and width information of the image.
    public var imageMetadata: ImageMetadata?
    /// The information of the vote within this post.
    public var vote: Vote?
}
