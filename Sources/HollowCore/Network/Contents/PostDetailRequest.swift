//
//  PostDetail.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

/// Fetch a single post.
public struct PostDetailRequest: DefaultRequest {
    public struct Configuration {
        /// The root components of the URL.
        public var apiRoot: String
        /// The access token.
        public var token: String
        /// The post id of the request post.
        public var postId: Int
        /// Whether to request comments.
        public var includeComments: Bool
        /// The wrapper for the cached post, if there's one.
        ///
        /// The updated time will be examine and some result will not be fetched if there's no update since the last fetch.
        public var cachedPost: PostWrapper?
        
        public init(apiRoot: String, token: String, postId: Int, includeComments: Bool, cachedPost: PostWrapper? = nil) {
            self.apiRoot = apiRoot
            self.token = token
            self.postId = postId
            self.includeComments = includeComments
            self.cachedPost = cachedPost
        }
    }
    struct Result: DefaultRequestResult {
        var code: Int
        var msg: String?
        var post: Post?
        var data: [Comment]?
    }
    public enum ResultData {
        /// There's no update since the time when the cached post was fetched.
        case cached(PostWrapper)
        /// The result is newly fetched, or here is update since the time when the cached post was fetched.
        case new(PostWrapper)
    }
    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
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
        
        if let cachedPost = configuration.cachedPost {
            let oldUpdated = cachedPost.post.updatedAt
            
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
