//
//  SendPostRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public struct SendPostRequestConfiguration {
    public init(apiRoot: String, token: String, text: String, tag: String? = nil, imageData: String? = nil, voteData: [String]? = nil) {
        self.apiRoot = apiRoot
        self.token = token
        self.text = text
        self.tag = tag
        self.imageData = imageData
        self.voteData = voteData
    }
    
    var apiRoot: String
    var token: String
    var text: String
    var tag: String?
    var imageData: String?
    var voteData: [String]?
}

struct SendPostRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
}

public struct SendPostRequest: DefaultRequest {
    public typealias Configuration = SendPostRequestConfiguration
    typealias Result = SendPostRequestResult
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError

    var configuration: SendPostRequestConfiguration
    
    public init(configuration: SendPostRequestConfiguration) {
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
