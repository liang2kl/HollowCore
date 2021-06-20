//
//  PostDetail.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public struct PostDetailRequestConfiguration {
    var apiRoot: String
    var token: String
    var postId: Int
    /// when don't need comments, only need main post, set `needComments` to false
    var includeComments: Bool
    var lastUpdateTimestamp: Int?
    var cachedPost: PostWrapper?
    
    public init(apiRoot: String, token: String, postId: Int, includeComments: Bool) {
        self.apiRoot = apiRoot
        self.token = token
        self.postId = postId
        self.includeComments = includeComments
    }
    
    public init(apiRoot: String, token: String, postId: Int, includeComments: Bool, lastUpdateTimestamp: Int, cachedPost: PostWrapper) {
        self.apiRoot = apiRoot
        self.token = token
        self.postId = postId
        self.includeComments = includeComments
        self.lastUpdateTimestamp = lastUpdateTimestamp
        self.cachedPost = cachedPost
    }
}

struct PostDetailRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
    var post: Post?
    var data: [Comment]?
}

public enum PostDetailRequestResultData {
    case cached(PostWrapper)
    case new(PostWrapper)
}

public struct PostDetailRequest: DefaultRequest {
    
    public typealias Configuration = PostDetailRequestConfiguration
    typealias Result = PostDetailRequestResult
    public typealias ResultData = PostDetailRequestResultData
    public typealias Error = DefaultRequestError
    
    var configuration: PostDetailRequestConfiguration
    
    public init(configuration: PostDetailRequestConfiguration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/contents/post/detail" + Constants.urlSuffix
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        
        var parameters: [String : Encodable] = [
            "pid" : configuration.postId.string,
            "include_comment" : configuration.includeComments.int.string
        ]
        
        if let oldUpdated = configuration.lastUpdateTimestamp,
           let cachedPost = configuration.cachedPost {
            // If at least one of the comments has `delete` permission
            // but no `delete_ban` permission, then we should not rely
            // on cache because that permission has a fixed timeout and
            // the backend will not update `update_at` on permissions change
            // for compatibility consideration.
            var canRemoveButCannotBan = false
            if !cachedPost.comments.isEmpty {
                for comment in cachedPost.comments {
                    if comment.permissions.contains(.delete) &&
                        !comment.permissions.contains(.deleteBan) {
                        canRemoveButCannotBan = true
                        break
                    }
                }
            }
            
            if !canRemoveButCannotBan {
                parameters["old_updated_at"] = oldUpdated
            }
        }
        
        let transformer: (Result) -> ResultData? = { result in
            guard let post = result.post else { return nil }
            
            if result.code == 1, let cachedPost = configuration.cachedPost {
                // The post has been cached and there's no update.
                // The only thing that is certain to remain unchanged is the comment data,
                // thus we need to integrate other part of the latest result.
                return .cached(PostWrapper(post: post, comments: cachedPost.comments))
                
            } else {
                return .new(PostWrapper(post: post, comments: result.data ?? []))
            }
        }
        
        performRequest(
            urlRoot: configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            headers: headers,
            method: .get,
            transformer: transformer,
            completion: completion
        )
    }
}
