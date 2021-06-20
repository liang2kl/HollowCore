//
//  ReportPostRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public struct ReportPostRequestConfiguration {
    public init(apiRoot: String, token: String, postId: Int, type: PostPermissionType, reason: String) {
        self.apiRoot = apiRoot
        self.token = token
        self.postId = postId
        self.type = type
        self.reason = reason
    }
    
    var apiRoot: String
    var token: String
    var postId: Int
    var type: PostPermissionType
    // reason can't be empty
    var reason: String
}

struct ReportPostRequestResult: DefaultRequestResult {
    var code: Int
    var msg: String?
}

public struct ReportPostRequest: DefaultRequest {
    public typealias Configuration = ReportPostRequestConfiguration
    typealias Result = ReportPostRequestResult
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    var configuration: ReportPostRequestConfiguration
    
    public init(configuration: ReportPostRequestConfiguration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/edit/report/post" + Constants.urlSuffix
        
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        
        let parameters: [String : Encodable] = [
            "id" : self.configuration.postId,
            "type": self.configuration.type.rawValue,
            "reason" : self.configuration.reason,
        ]
        performRequest(
            urlRoot: self.configuration.apiRoot,
            urlPath: urlPath,
            parameters: parameters,
            headers: headers,
            method: .post,
            transformer: { _ in () },
            completion: completion)
    }
    
}
