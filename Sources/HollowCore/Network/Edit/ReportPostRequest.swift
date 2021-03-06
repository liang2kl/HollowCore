//
//  ReportPostRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

/// Report, fold, tag, delete, or undelete a post; ban or unban a user.
public struct ReportPostRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String, postId: Int, type: PostPermissionType, reason: String) {
            self.apiRoot = apiRoot
            self.token = token
            self.postId = postId
            self.type = type
            self.reason = reason
        }
        
        /// The root components of the URL.
        public var apiRoot: String
        /// The access token.
        public var token: String
        /// The id of the post to report.
        public var postId: Int
        /// The type of the report.
        public var type: PostPermissionType
        /// The reason for the report.
        public var reason: String
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
