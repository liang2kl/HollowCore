//
//  DefaultRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/2/9.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation
import Alamofire
import Combine

protocol DefaultRequestResult: Codable {
    var code: Int { get }
    var msg: String? { get }
}

/// Protocol for default requests.
///
/// The term `Default` means: normal and share some same attributes.
/// The protocol can apply to almost all requests.
///
/// # Associated type explained
/// - `Error == DefaultRequestError`
/// - `Result` should conform to `DefaultRequestResult`
/// - `Configuration` and `ResultData` can be any type
protocol DefaultRequest: _Request where Error == DefaultRequestError, Result: DefaultRequestResult { }

extension DefaultRequest {
    /// Default implementation of `performRequest`.
    /// - parameter urlPath: Path for HTTP request.
    /// - parameter parameters: Paramenters for the request. Use an empty [String : String] dictionary when there are no parameters.
    /// - parameter headers: HTTP headers to be included.
    /// - parameter method: `.post` or `.get`.
    /// - parameter transformer: Method to generate result data from result.
    /// - parameter completion: Handler to call to handle returned data.
    internal func performRequest(
        urlRoot: String,
        urlPath: String,
        parameters: [String : Any]? = nil,
        headers: HTTPHeaders? = nil,
        method: HTTPMethod,
        transformer: @escaping (Result) -> ResultData?,
        completion: @escaping (ResultType<ResultData, Error>) -> Void
    ) {
        AF.request(
            urlRoot + urlPath,
            method: method,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate()
        .responseJSON { response in
            DispatchQueue.global(qos: .background).async {
                switch response.result {
                case .success:
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        guard let data = response.data else {
                            completion(.failure(.unknown))
                            return
                        }
                        let result = try jsonDecoder.decode(Result.self, from: data)
                        if result.code >= 0 {
                            // result code >= 0 valid!
                            if let data = transformer(result) {
                                completion(.success(data))
                            } else {
                                completion(.failure(.unknown))
                            }
                        } else {
                            let error = DefaultRequestError(errorCode: result.code, description: result.msg)
                            completion(.failure(error))
                            return
                        }
                        
                    } catch {
                        completion(.failure(.decodeFailed))
                        return
                    }
                    
                case let .failure(error):
                    
                    if let errorCode = error.responseCode, errorCode == 413 {
                        completion(.failure(.fileTooLarge))
                        return
                    } else {
                        completion(.failure(.other(description: error.localizedDescription)))
                        return
                    }
                }
                
            }
        }
    }
    
}
