//
//  SendVoteRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public struct SendVoteRequestConfiguration {
    public init(apiRoot: String, token: String, option: String, postId: Int) {
        self.apiRoot = apiRoot
        self.token = token
        self.option = option
        self.postId = postId
    }
    
    public var apiRoot: String
    public var token: String
    public var option: String
    public var postId: Int
}

struct SendVoteRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
    var vote: Vote?
}

public struct SendVoteRequest: DefaultRequest {
    public typealias Configuration = SendVoteRequestConfiguration
    typealias Result = SendVoteRequestResult
    public typealias ResultData = Vote
    public typealias Error = DefaultRequestError
    var configuration: SendVoteRequestConfiguration
    
    public init(configuration: SendVoteRequestConfiguration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/send/vote" + Constants.urlSuffix
        
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        
        let parameters: [String : Encodable] = [
            "option" : self.configuration.option,
            // type will be deprecated!
            "pid" : self.configuration.postId,
        ]
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            headers: headers,
            method: .post,
            transformer: { $0.vote },
            completion: completion
        )
    }
}
