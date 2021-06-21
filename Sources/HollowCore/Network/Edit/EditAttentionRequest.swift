//
//  EditAttentionRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public struct EditAttentionRequestConfiguration {
    public init(apiRoot: String, token: String, postId: Int, switchToAttention: Bool) {
        self.apiRoot = apiRoot
        self.token = token
        self.postId = postId
        self.switchToAttention = switchToAttention
    }
    
    public var apiRoot: String
    public var token: String
    /// Post id.
    public var postId: Int
    /// `false` for cancel attention, `true` otherwise
    public var switchToAttention: Bool
}

struct EditAttentionRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
    /// The post data after editing attention
    var data: Post?
}

public struct EditAttentionRequest: DefaultRequest {
    public typealias Configuration = EditAttentionRequestConfiguration
    typealias Result = EditAttentionRequestResult
    public typealias ResultData = Post
    public typealias Error = DefaultRequestError
    
    var configuration: EditAttentionRequestConfiguration
    
    public init(configuration: EditAttentionRequestConfiguration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/edit/attention" + Constants.urlSuffix
        
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        
        let parameters: [String : Encodable] = [
            "pid" : self.configuration.postId,
            "switch": self.configuration.switchToAttention ? 1 : 0,
        ]
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            headers: headers,
            method: .post,
            transformer: { $0.data },
            completion: completion)
    }
}
