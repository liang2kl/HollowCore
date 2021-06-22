//
//  PostListRequest.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Foundation
import Alamofire

/// Fetch posts in `Timeline`.
public struct PostListRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String, page: Int) {
            self.apiRoot = apiRoot
            self.token = token
            self.page = page
        }
        
        /// The root components of the URL.
        public var apiRoot: String
        /// The access token.
        public var token: String
        /// The `page` of the request.
        ///
        /// Starts from `1`. Increase to fetch former posts.
        public var page: Int
    }
    struct Result: DefaultRequestResult {
        var code: Int
        var msg: String?
        var data: [Post]?
        var comments: [String: [Comment]?]?
        
        func toPostWrappers() -> [PostWrapper]? {
            guard let data = data else { return nil }

            return data.map { post in
                // process comments of current post
                var commentData = [Comment]()
                if let comments = comments, let commentsOfPost = comments[post.pid.string] {
                    if let comments = commentsOfPost {
                        commentData = comments
                    }
                }
                return PostWrapper(post: post, comments: commentData)
            }
        }
    }
    public typealias ResultData = [PostWrapper]
    public typealias Error = DefaultRequestError
    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/contents/post/list" + Constants.urlSuffix
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        let parameters: [String : Encodable] = [
            "page" : configuration.page
        ]
        
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            headers: headers,
            method: .get,
            transformer: { $0.toPostWrappers() },
            completion: completion
        )
    }
    
}
