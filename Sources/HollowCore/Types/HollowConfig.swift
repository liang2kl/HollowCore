//
//  HollowConfig.swift
//  Hollow
//
//  Created by liang2kl on 2021/3/24.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

public struct HollowConfig: Codable {
    public struct SearchPrompt: Codable {
        public struct ButtonInfo: Codable {
            public var text: String
            public var url: String
        }
        public var keywords: [String]
        public var description: String
        public var buttons: [ButtonInfo]
    }
    public var name: String
    public var recaptchaUrl: String
    public var apiRootUrls: [String]
    public var tosUrl: String
    public var rulesUrl: String
    public var privacyUrl: String
    public var contactEmail: String
    public var emailSuffixes: [String]
    public var announcement: String
    public var foldTags: [String]
    public var reportableTags: [String]
    public var sendableTags: [String]
    public var imgBaseUrls: [String]
    public var websocketUrl: String
    public var searchTrending: String
    public var searchPrompts: [SearchPrompt]
}
