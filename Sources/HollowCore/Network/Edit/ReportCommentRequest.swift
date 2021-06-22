//
//  ReportCommentRequest.swift
//  Hollow
//
//  Created on 2021/1/18.
//

import Foundation
import Alamofire

/// Report, fold, tag, delete, or undelete a comment; ban or unban a user.
public struct ReportCommentRequest: DefaultRequest {
    public struct Configuration {
        public init(apiRoot: String, token: String, commentId: Int, type: PostPermissionType, reason: String) {
            self.apiRoot = apiRoot
            self.token = token
            self.commentId = commentId
            self.type = type
            self.reason = reason
        }
        
        /// The root components of the URL.
        public var apiRoot: String
        /// The access token.
        public var token: String
        /// The id of the comment to report.
        public var commentId: Int
        /// The type of the report.
        public var type: PostPermissionType
        /// The reason for the report.
        ///
        /// For ``PostPermissionType/fold`` and ``PostPermissionType/setTag``, the reason is the tag to be set. For other case of ``type``, the reason is the report message.
        public var reason: String
    }
    typealias Result = ReportPostRequest.Result
    public typealias ResultData = ()
    public typealias Error = DefaultRequestError
    var configuration: Configuration
    
    public init(configuration: Configuration) {
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
