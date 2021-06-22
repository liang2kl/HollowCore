//
//  GetConfigRequest.swift
//  Hollow
//
//  Created by liang2kl on 2021/1/18.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// Get Config Request
public struct GetConfigRequest: _Request {
    public struct Configuration {
        public init(configUrl: String) {
            self.configUrl = configUrl
        }
        public var configUrl: String
    }
    typealias Result = HollowConfig
    public enum Error: Swift.Error, LocalizedError {
        case serverError
        case decodeFailed
        case incorrectFormat
        case invalidConfigUrl
        case invalidConfiguration
        case other(description: String)
        
        public var errorDescription: String? {
            switch self {
            case .serverError: return NSLocalizedString("GET_CONFIG_ERR_SERVER_ERROR", bundle: .module, comment: "")
            case .decodeFailed: return NSLocalizedString("GET_CONFIG_ERR_DECODE_FAILED", bundle: .module, comment: "")
            case .incorrectFormat: return NSLocalizedString("GET_CONFIG_ERR_INCORRECT_FORMAT", bundle: .module, comment: "")
            case .invalidConfigUrl: return NSLocalizedString("GET_CONFIG_ERR_INVALID_CONFIG_URL", bundle: .module, comment: "")
            case .invalidConfiguration: return NSLocalizedString("GET_CONFIG_ERR_INVALID_CONFIGURATION", bundle: .module, comment: "")
            case .other(let description): return description
            }
        }
    }
    public typealias ResultData = HollowConfig
    
    var configuration: Configuration
    
    public init(configuration: Configuration) {
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
    
    static private func validateConfig(_ config: HollowConfig) -> Bool {
        return (!config.apiRootUrls.isEmpty &&
        !config.emailSuffixes.isEmpty &&
        !config.imgBaseUrls.isEmpty &&
        !config.name.isEmpty &&
        !config.recaptchaUrl.isEmpty &&
        !config.tosUrl.isEmpty &&
        !config.privacyUrl.isEmpty &&
        !config.rulesUrl.isEmpty)
    }
}
