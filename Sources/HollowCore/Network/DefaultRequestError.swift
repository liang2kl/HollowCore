//
//  DefaultRequestError.swift
//  Hollow
//
//  Created by aliceinhollow on 9/2/2021.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// Common errors occured during requests.
public enum DefaultRequestError: Error, LocalizedError {
    /// Failed to decode result from the response.
    case decodeFailed
    /// The access token provided has expired.
    case tokenExpiredError
    /// The uploaded file is too large and is refused by the server.
    case fileTooLarge
    case unknown
    /// The request post does not exist.
    case noSuchPost
    case other(description: String)
    
    init(errorCode: Int, description: String?) {
        switch errorCode {
        case -100: self = .tokenExpiredError
        case -101: self = .noSuchPost
        default: self = .other(description: description ?? "Unknown error with error code \(errorCode)")
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .decodeFailed: return NSLocalizedString("DEF_ERR_DECODE_FAILED", bundle: .module, comment: "")
        case .tokenExpiredError: return NSLocalizedString("DEF_ERR_TOKEN_EXPIRED", bundle: .module, comment: "")
        case .fileTooLarge: return NSLocalizedString("DEF_ERR_FILE_TOO_LARGE", bundle: .module, comment: "")
        case .unknown: return NSLocalizedString("DEF_ERR_UNKNOWN", bundle: .module, comment: "")
        case .noSuchPost: return NSLocalizedString("DEF_ERR_NO_SUCH_POST", bundle: .module, comment: "")
        case .other(let description): return description
        }
    }
}
