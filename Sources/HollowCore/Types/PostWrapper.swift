//
//  PostWrapper.swift
//  HollowCore
//
//  Created by 梁业升 on 2021/6/20.
//

import Foundation

public struct PostWrapper: Codable {
    public var post: Post
    public var comments: [Comment]
}
