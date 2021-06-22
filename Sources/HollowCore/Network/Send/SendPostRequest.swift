//
//  SendPostRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

/// Post a new post.
public struct SendPostRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String, text: String, tag: String? = nil, imageData: Data? = nil, voteData: [String]? = nil) {
            self.apiRoot = apiRoot
            self.token = token
            self.text = text
            self.tag = tag
            self.imageData = imageData?.base64EncodedString()
            self.voteData = voteData
        }

        public init(apiRoot: String, token: String, text: String, tag: String? = nil, imageData: String? = nil, voteData: [String]? = nil) {
            self.apiRoot = apiRoot
            self.token = token
            self.text = text
            self.tag = tag
            self.imageData = imageData
            self.voteData = voteData
        }
        
        /// The root components of the URL.
        public var apiRoot: String
        /// The access token.
        public var token: String
        /// The content of the comment.
        public var text: String
        /// The tag to be set. Must be in ``HollowConfig/sendableTags``.
        public var tag: String?
        /// The image data, encoded in `base64`.
        public var imageData: String?
        /// The vote options.
        public var voteData: [String]?
    }

    struct Result: DefaultRequestResult {
        var code: Int
        var msg: String?
    }

    public typealias ResultData = ()
    public typealias Error = DefaultRequestError

    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/send/post" + Constants.urlSuffix
        let hasImage = configuration.imageData != nil
        
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]

        var parameters: [String : Encodable] = [
            "text" : configuration.text,
            // type will be deprecated!
            "type" : hasImage ? "image" : "text",
        ]

        if let imageData = configuration.imageData {
            parameters["data"] = imageData
        }

        if let voteData = configuration.voteData {
            parameters["vote_options"] = voteData
        }

        if let tag = configuration.tag, tag != "" {
            parameters["tag"] = tag
        }
        
        performRequest(
            urlRoot: configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            headers: headers,
            method: .post,
            transformer: { _ in () },
            completion: completion
        )
    }
}
