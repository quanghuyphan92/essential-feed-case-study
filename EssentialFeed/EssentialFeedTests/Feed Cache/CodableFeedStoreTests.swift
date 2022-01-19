//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Phan Quang Huy on 1/19/22.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }
}

class CodableFeedStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()
        
        let exp = expectation(description: "Wait for retrieve completion")
        sut.retrieve { result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("expected empty, got \(result) instead.")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
