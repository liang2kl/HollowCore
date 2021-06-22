//
//  ImageMetadata.swift
//  Hollow
//
//  Created by aliceinhollow on 2/19/21.
//  Copyright © 2021 treehollow. All rights reserved.
//

import SwiftUI

/// Width and height information of the image associated with a post.
public struct ImageMetadata: Codable {
    public init(w: CGFloat? = nil, h: CGFloat? = nil) {
        self.w = w
        self.h = h
    }
    
    /// Width.
    public var w: CGFloat?
    /// Height.
    public var h: CGFloat?
}
