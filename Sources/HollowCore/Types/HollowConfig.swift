//
//  HollowConfig.swift
//  Hollow
//
//  Created by liang2kl on 2021/3/24.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

public struct HollowConfig: Codable {
    public init(name: String, recaptchaUrl: String, apiRootUrls: [String], tosUrl: String, rulesUrl: String, privacyUrl: String, contactEmail: String, emailSuffixes: [String], announcement: String, foldTags: [String], reportableTags: [String], sendableTags: [String], imgBaseUrls: [String], websocketUrl: String, searchTrending: String, searchPrompts: [HollowConfig.SearchPrompt]) {
        self.name = name
        self.recaptchaUrl = recaptchaUrl
        self.apiRootUrls = apiRootUrls
        self.tosUrl = tosUrl
        self.rulesUrl = rulesUrl
        self.privacyUrl = privacyUrl
        self.contactEmail = contactEmail
        self.emailSuffixes = emailSuffixes
        self.announcement = announcement
        self.foldTags = foldTags
        self.reportableTags = reportableTags
        self.sendableTags = sendableTags
        self.imgBaseUrls = imgBaseUrls
        self.websocketUrl = websocketUrl
        self.searchTrending = searchTrending
        self.searchPrompts = searchPrompts
    }
    
    public struct SearchPrompt: Codable {
        public init(keywords: [String], description: String, buttons: [HollowConfig.SearchPrompt.ButtonInfo]) {
            self.keywords = keywords
            self.description = description
            self.buttons = buttons
        }
        
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
