//
//  ReportCommentRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

public struct ReportCommentRequestConfiguration {
    public init(apiRoot: String, token: String, commentId: Int, type: PostPermissionType, reason: String) {
        self.apiRoot = apiRoot
        self.token = token
        self.commentId = commentId
        self.type = type
        self.reason = reason
    }
    
    var apiRoot: String
    var token: String
    var commentId: Int
    var type: PostPermissionType
    var reason: String
}

public struct ReportCommentRequest: DefaultRequest {
    public typealias Configuration = ReportCommentRequestConfiguration
    typealias Result = ReportPostRequestResult
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    var configuration: ReportCommentRequestConfiguration
    
    public init(configuration: ReportCommentRequestConfiguration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        let urlPath = "v3/edit/report/comment" + Constants.urlSuffix
        
        let headers: HTTPHeaders = [
            "TOKEN": self.configuration.token,
            "Accept": "application/json"
        ]
        
        let parameters: [String : Encodable] = [
            "id" : self.configuration.commentId,
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
