//
//  SendVoteRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

/// Vote in specific post.
public struct SendVoteRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String, option: String, postId: Int) {
            self.apiRoot = apiRoot
            self.token = token
            self.option = option
            self.postId = postId
        }
        
        /// The root components of the URL.
        public var apiRoot: String
        /// The access token.
        public var token: String
        /// The selected vote option.
        public var option: String
        /// Id of the post to be voted.
        public var postId: Int
    }

    struct Result: DefaultRequestResult {
        var code: Int
        var msg: String?
        var vote: Vote?
    }

    public typealias ResultData = Vote
    public typealias Error = DefaultRequestError
    var configuration: Configuration
    
    public init(configuration: Configuration) {
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
