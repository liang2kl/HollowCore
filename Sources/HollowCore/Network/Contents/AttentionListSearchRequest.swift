//
//  AttentionListSearchRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public struct AttentionListSearchRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String, keywords: String, page: Int) {
            self.apiRoot = apiRoot
            self.token = token
            self.keywords = keywords
            self.page = page
        }
        
        public var apiRoot: String
        public var token: String
        public var keywords: String
        public var page: Int
    }
    typealias Result = PostListRequest.Result
    public typealias ResultData = [PostWrapper]
    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/contents/search/attentions" + Constants.urlSuffix
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        
        let parameters: [String : Encodable] = [
            "keywords" : configuration.keywords,
            "page" : configuration.page,
        ]
        
        performRequest(
            urlRoot: configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            headers: headers,
            method: .get,
            transformer: { $0.toPostWrappers() },
            completion: completion)
    }
    
}

