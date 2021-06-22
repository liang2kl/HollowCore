//
//  DefaultRequestError.swift
//  Hollow
//
//  Created by aliceinhollow on 9/2/2021.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

public enum DefaultRequestError: Error {
    case decodeFailed
    case tokenExpiredError
    case fileTooLarge
    case unknown
    case noSuchPost
    case other(description: String)
    
    init(errorCode: Int, description: String?) {
        switch errorCode {
        case -100: self = .tokenExpiredError
        case -101: self = .noSuchPost
        default: self = .other(description: description ?? "Unknown error with error code \(errorCode)")
        }
    }
    
    var localizedDescription: String {
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
