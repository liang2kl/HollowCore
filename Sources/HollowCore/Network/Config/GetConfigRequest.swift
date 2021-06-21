//
//  GetConfigRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/1/18.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// config of GetConfig query
public struct GetConfigRequestConfiguration {
    /// - parameter configUrl: The url of the configuration file.
    public init(configUrl: String) {
        self.configUrl = configUrl
    }
    public var configUrl: String
}

public enum GetConfigRequestError: Error {
    case serverError
    case decodeFailed
    case incorrectFormat
    case invalidConfigUrl
    case invalidConfiguration
    case loadingCompleted
    case other(description: String)
}

/// Get Config Request
public struct GetConfigRequest: _Request {
    public typealias Configuration = GetConfigRequestConfiguration
    typealias Result = HollowConfig
    public typealias Error = GetConfigRequestError
    public typealias ResultData = HollowConfig
    
    var configuration: GetConfigRequestConfiguration
    
    public init(configuration: GetConfigRequestConfiguration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        guard let url = URL(string: configuration.configUrl) else {
            completion(.failure(.invalidConfigUrl))
            return
        }
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.other(description: error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completion(.failure(.serverError))
                return
            }
            
            guard let mimeType = httpResponse.mimeType, mimeType == "text/plain",
                  let data = data,
                  let string = String(data: data, encoding: .utf8) else {
                      completion(.failure(.incorrectFormat))
                return
            }
            let components1 = string.components(separatedBy: "-----BEGIN TREEHOLLOW CONFIG-----")
            if components1.count == 2 {
                let component2 = components1[1].components(separatedBy: "-----END TREEHOLLOW CONFIG-----")
                if component2.count >= 1, let apiInfo = component2[0].data(using: .utf8) {
                    // finally match the format, then process it
                    let jsonDecoder = JSONDecoder()
                    // convert Snake Case
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let result = try jsonDecoder.decode(Result.self, from: apiInfo)
                        
                        if GetConfigRequest.validateConfig(result) {
                            // Call the callback
                            completion(.success(result))
                        } else {
                            completion(.failure(.invalidConfigUrl))
                        }
                    } catch {
                        completion(.failure(.decodeFailed))
                    }
                    return
                }
                
            }
            
            // Cannot match the format
            completion(.failure(.incorrectFormat))
        }
        task.resume()
    }
    
    static private func validateConfig(_ config: GetConfigRequestResult) -> Bool {
        return
        !config.apiRootUrls.isEmpty &&
        !config.emailSuffixes.isEmpty &&
        !config.imgBaseUrls.isEmpty &&
        !config.name.isEmpty &&
        !config.recaptchaUrl.isEmpty &&
        !config.tosUrl.isEmpty &&
        !config.privacyUrl.isEmpty &&
        !config.rulesUrl.isEmpty
    }
}
