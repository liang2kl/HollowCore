//
//  SendCommentRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public struct SendCommentRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String, text: String, imageData: String? = nil, postId: Int, replyCommentId: Int? = nil) {
            self.apiRoot = apiRoot
            self.token = token
            self.text = text
            self.imageData = imageData
            self.postId = postId
            self.replyCommentId = replyCommentId
        }
        
        public var apiRoot: String
        public var token: String
        
        public var text: String
        public var imageData: String?
        /// Id of the post to be commented
        public var postId: Int
        public var replyCommentId: Int?
    }

    struct Result: DefaultRequestResult {
        var code: Int
        var msg: String?
        var commentId: Int?
    }

    public struct ResultData {
        public var commentId: Int?
    }

    public typealias Error = DefaultRequestError
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/send/comment" + Constants.urlSuffix
        let hasImage = configuration.imageData != nil
        
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]

        var parameters: [String : Encodable] = [
            "text" : configuration.text,
            "type" : hasImage ? "image" : "text",
            "pid" : configuration.postId,
        ]
        
        // Optionals are not allowed.
        if let imageData = configuration.imageData {
            parameters["data"] = imageData
        }
        
        if let replyToCommentId = configuration.replyCommentId {
            parameters["reply_to_cid"] = replyToCommentId
        }

        performRequest(
            urlRoot: configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            headers: headers,
            method: .post,
            transformer: { .init(commentId: $0.commentId) },
            completion: completion
        )
    }
}
