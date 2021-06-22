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
    public init(voted: String? = nil, voteData: [String : Int]? = nil, voteOptions: [String]? = nil) {
        self.voted = voted
        self.voteData = voteData
        self.voteOptions = voteOptions
    }
    
    public var voted: String?
    public var voteData: [String: Int]?
    public var voteOptions: [String]?
}
