//
//  Vote.swift
//  Hollow
//
//  Created by aliceinhollow on 2/19/21.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// Data type representing a vote.
///
/// The ``voteData`` is unordered. Use ``voteOptions`` as ordered keys to reorder.
public struct Vote: Codable {
    public init(voted: String? = nil, voteData: [String : Int]? = nil, voteOptions: [String]? = nil) {
        self.voted = voted
        self.voteData = voteData
        self.voteOptions = voteOptions
    }
    
    /// The vote that the user selects.
    public var voted: String?
    /// The options (`[<option> : <vote_count>]`).
    public var voteData: [String: Int]?
    /// The ordered options.
    public var voteOptions: [String]?
}
