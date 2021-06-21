//
//  ImageMetadata.swift
//  Hollow
//
//  Created by aliceinhollow on 2/19/21.
//  Copyright © 2021 treehollow. All rights reserved.
//

import SwiftUI

/// ImageMetadata
public struct ImageMetadata: Codable {
    public init(w: CGFloat? = nil, h: CGFloat? = nil) {
        self.w = w
        self.h = h
    }
    
    public var w: CGFloat?
    public var h: CGFloat?
}
