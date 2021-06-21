//
//  PostListRequest.swift
//  Hollow
//
//  Created on 2021/1/17.
//

import Foundation
import Alamofire

/// Configuration for PostListRequest
public struct PostListRequestConfiguration {
    public init(apiRoot: String, token: String, page: Int) {
        self.apiRoot = apiRoot
        self.token = token
        self.page = page
    }
    
    public var apiRoot: String
    public var token: String
    public var page: Int
}

/// Result for PostListRequest
struct PostListRequestResult: DefaultRequestResult {
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

public typealias PostListRequestResultData = [PostWrapper]

/// PostListRequest
public struct PostListRequest: DefaultRequest {
    public typealias Configuration = PostListRequestConfiguration
    typealias Result = PostListRequestResult
    public typealias ResultData = PostListRequestResultData
    public typealias Error = DefaultRequestError
    var configuration: PostListRequestConfiguration
    
    public init(configuration: PostListRequestConfiguration) {
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
