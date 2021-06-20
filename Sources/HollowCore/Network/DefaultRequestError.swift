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
    /// Indicating that current request has finished successfully.
    case loadingCompleted
    case other(description: String)
    
    init(errorCode: Int, description: String?) {
        switch errorCode {
        case -100: self = .tokenExpiredError
        case -101: self = .noSuchPost
        default: self = .other(description: description ?? "Unknown error with error code \(errorCode)")
        }
    }
}
