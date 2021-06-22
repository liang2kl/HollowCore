//
//  AttentionListRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

/// Fetch the posts in the user's attention list.
public struct AttentionListRequest: DefaultRequest {
    public typealias Configuration = PostListRequest.Configuration
    typealias Result = PostListRequest.Result
    public typealias ResultData = [PostWrapper]
    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/contents/post/attentions" + Constants.urlSuffix
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
