//
//  SendPostRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public struct SendPostRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String, text: String, tag: String? = nil, imageData: String? = nil, voteData: [String]? = nil) {
            self.apiRoot = apiRoot
            self.token = token
            self.text = text
            self.tag = tag
            self.imageData = imageData
            self.voteData = voteData
        }
        
        public var apiRoot: String
        public var token: String
        public var text: String
        public var tag: String?
        public var imageData: String?
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
