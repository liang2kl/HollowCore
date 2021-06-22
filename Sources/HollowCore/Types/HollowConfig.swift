//
//  HollowConfig.swift
//  Hollow
//
//  Created by liang2kl on 2021/3/24.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// The configuration for a tree hollow program.
public struct HollowConfig: Codable {
    public init(name: String, recaptchaUrl: String, apiRootUrls: [String], tosUrl: String, rulesUrl: String, privacyUrl: String, contactEmail: String, emailSuffixes: [String], announcement: String, foldTags: [String], reportableTags: [String], sendableTags: [String], imgBaseUrls: [String], searchTrending: String, searchPrompts: [HollowConfig.SearchPrompt]) {
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
            /// The displayed text for the button.
            public var text: String
            /// The url to jump to.
            public var url: String
        }
        /// The keywords to be interferenced.
        public var keywords: [String]
        /// The description of the interference.
        public var description: String
        /// The information to display buttons.
        public var buttons: [ButtonInfo]
    }
    
    /// The name of the tree hollow host.
    public var name: String
    /// The url for the reCAPTCHA page.
    public var recaptchaUrl: String
    /// The root URL of the server API.
    public var apiRootUrls: [String]
    /// The URL for Terms and Service page.
    public var tosUrl: String
    /// The URL for community rules.
    public var rulesUrl: String
    /// The URL for privacy page.
    public var privacyUrl: String
    /// The contact email.
    public var contactEmail: String
    /// The permitted email suffixes for registration.
    public var emailSuffixes: [String]
    /// The announcement.
    public var announcement: String
    /// The tags to be folded by default.
    public var foldTags: [String]
    /// Reportable tags.
    public var reportableTags: [String]
    /// Sendable tags.
    public var sendableTags: [String]
    /// URL base for image requests.
    public var imgBaseUrls: [String]
    /// The keyword used to show trending posts.
    public var searchTrending: String
    /// Inteference information for specific serach.
    public var searchPrompts: [SearchPrompt]
}
