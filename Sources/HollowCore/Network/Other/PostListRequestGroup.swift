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
    public typealias Configuration = PostListRequestGroupConfiguration
    typealias Result = PostListRequestResult
    public typealias ResultData = [PostWrapper]
    public typealias Error = DefaultRequestError

    var configuration: PostListRequestGroupConfiguration
    
    public init(configuration: PostListRequestGroupConfiguration) {
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

public enum PostListRequestGroupConfiguration {
    case postList(PostListRequestConfiguration)
    case search(SearchRequestConfiguration)
    case searchTrending(SearchRequestConfiguration)
    case attentionList(AttentionListRequestConfiguration)
    case attentionListSearch(AttentionListSearchRequestConfiguration)
    case wander(RandomListRequestConfiguration)
}

public enum PostListRequestGroupType {
    case postList, search, searchTrending, attentionList, attentionListSearch, wander
}
