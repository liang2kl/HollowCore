//
//  RandomListRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

/// Fetch posts in `Wander`.
public struct RandomListRequest: DefaultRequest {
    public typealias Configuration = PostListRequest.Configuration
    typealias Result = PostListRequest.Result
    public typealias ResultData = [PostWrapper]
    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/contents/post/randomlist" + Constants.urlSuffix
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            headers: headers,
            method: .get,
            transformer: { $0.toPostWrappers() },
            completion: completion
        )
    }
}
