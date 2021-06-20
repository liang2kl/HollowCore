//
//  PostWrapper.swift
//  HollowCore
//
//  Created by 梁业升 on 2021/6/20.
//

import Foundation

public struct PostWrapper: Codable {
    var post: Post
    var comments: [Comment]
}
