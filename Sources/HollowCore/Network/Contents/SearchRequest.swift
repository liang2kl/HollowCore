//
//  SearchRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

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
        
        public var apiRoot: String
        public var token: String
        public var keywords: String
        public var page: Int
        public var afterTimestamp: Int?
        public var beforeTimestamp: Int?
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
