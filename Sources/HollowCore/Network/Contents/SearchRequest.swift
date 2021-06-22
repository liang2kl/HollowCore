//
//  SearchRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

/// Search in all posts.
public struct SearchRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String, keywords: String, page: Int, afterTimestamp: Int? = nil, beforeTimestamp: Int? = nil, includeComment: Bool) {
            self.apiRoot = apiRoot
            self.token = token
            self.keywords = keywords
            self.page = page
            self.afterTimestamp = afterTimestamp
            self.beforeTimestamp = beforeTimestamp
            self.includeComment = includeComment
        }
        
        /// The root components of the URL.
        public var apiRoot: String
        /// The access token.
        public var token: String
        /// The keywords to search.
        public var keywords: String
        /// The `page` of the request.
        ///
        /// Starts from `1`. Increase to fetch former posts.
        public var page: Int
        /// The lower bound of the time interval.
        public var afterTimestamp: Int?
        /// The upper bound of the time interval.
        public var beforeTimestamp: Int?
        /// Whether to also search comments.
        public var includeComment: Bool
    }
    typealias Result = PostListRequest.Result
    public typealias ResultData = [PostWrapper]
    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/contents/search" + Constants.urlSuffix
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        
        var parameters: [String : Encodable] = [
            "keywords" : configuration.keywords,
            "page" : configuration.page,
            "include_comment" : configuration.includeComment ? "true" : "false"
        ]
        
        if let before = configuration.beforeTimestamp {
            parameters["before"] = before
        }
        
        if let after = configuration.afterTimestamp {
            parameters["after"] = after
        }
        
        performRequest(
            urlRoot: configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            headers: headers,
            method: .get,
            transformer: { $0.toPostWrappers() },
            completion: completion
        )
    }
    
}
