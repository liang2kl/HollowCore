//
//  Vote.swift
//  Hollow
//
//  Created by aliceinhollow on 2/19/21.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// Vote for result
public struct Vote: Codable {
    public var voted: String?
    public var voteData: [String: Int]?
    public var voteOptions: [String]?
}
