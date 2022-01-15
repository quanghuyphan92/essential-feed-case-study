//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Phan Quang Huy on 1/15/22.
//

import XCTest

class LocalFeedLoader {
    init(store: FeedStore) {
        
    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let feedStore = FeedStore()
        _ = LocalFeedLoader(store: feedStore)
        XCTAssertEqual(feedStore.deleteCachedFeedCallCount, 0)
    }

}
