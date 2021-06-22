//
//  PostWrapper.swift
//  HollowCore
//
//  Created by 梁业升 on 2021/6/20.
//

import Foundation

/// The wrapper for a post and its comments.
public struct PostWrapper: Codable {
    public init(post: Post, comments: [Comment]) {
        self.post = post
        self.comments = comments
    }
    
    public var post: Post
    public var comments: [Comment]
}
