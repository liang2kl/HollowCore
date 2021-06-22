//
//  PostListRequestGroup.swift
//  Hollow
//
//  Created by liang2kl on 2021/2/26.
//  Copyright © 2021 treehollow. All rights reserved.
//

import Foundation

/// A wrapper for a group of similar request for posts.
public struct PostListRequestGroup: Request {
    public enum Configuration {
        case postList(PostListRequest.Configuration)
        case search(SearchRequest.Configuration)
        case searchTrending(SearchRequest.Configuration)
        case attentionList(AttentionListRequest.Configuration)
        case attentionListSearch(AttentionListSearchRequest.Configuration)
        case wander(RandomListRequest.Configuration)
    }
    typealias Result = PostListRequest.Result
    public typealias ResultData = [PostWrapper]
    public typealias Error = DefaultRequestError

    var configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func performRequest(completion: @escaping (ResultType<ResultData, Error>) -> Void) {
        switch configuration {
        case .postList(let configuration):
            PostListRequest(configuration: configuration)
                .performRequest(completion: completion)
        case .search(let configuration),
             .searchTrending(let configuration):
            SearchRequest(configuration: configuration)
                .performRequest(completion: completion)
        case .attentionList(let configuration):
            AttentionListRequest(configuration: configuration)
                .performRequest(completion: completion)
        case .attentionListSearch(let configuration):
            AttentionListSearchRequest(configuration: configuration)
                .performRequest(completion: completion)
        case .wander(let configuration):
            RandomListRequest(configuration: configuration)
                .performRequest(completion: completion)
        }
    }
    
}

public extension PostListRequestGroup {
    enum RequestType {
        case postList, search, searchTrending, attentionList, attentionListSearch, wander
    }
}
