//
//  RandomListRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public typealias RandomListRequestConfiguration = PostListRequestConfiguration

typealias RandomListRequestResult = PostListRequestResult

public typealias RandomListRequestResultData = [PostWrapper]

public struct RandomListRequest: DefaultRequest {
    public typealias Configuration = RandomListRequestConfiguration
    typealias Result = RandomListRequestResult
    public typealias ResultData = RandomListRequestResultData
    public typealias Error = DefaultRequestError
    
    var configuration: RandomListRequestConfiguration
    
    public init(configuration: RandomListRequestConfiguration) {
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
