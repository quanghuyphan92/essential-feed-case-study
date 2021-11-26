//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Phan Quang Huy on 11/9/21.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
