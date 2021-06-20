//
//  AttentionListSearchRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public struct AttentionListSearchRequestConfiguration {
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

typealias AttentionListSearchRequestResult = PostListRequestResult

public struct AttentionListSearchRequest: DefaultRequest {

    public typealias Configuration = AttentionListSearchRequestConfiguration
    typealias Result = AttentionListSearchRequestResult
    public typealias ResultData = [PostWrapper]
    public typealias Error = DefaultRequestError
    
    var configuration: AttentionListSearchRequestConfiguration
    
    public init(configuration: AttentionListSearchRequestConfiguration) {
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

