//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Phan Quang Huy on 1/19/22.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
    private struct Cache: Codable {
        let feed: [LocalFeedImage]
        let timestamp: Date
    }
    
    private let storeURL = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!.appendingPathComponent("feed-image.store")
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: storeURL)
            do {
                let cache = try decoder.decode(Cache.self, from: data)
                completion(.found(feed: cache.feed, timestamp: cache.timestamp))
            } catch {
                completion(.failure(error))
            }
        } catch {
            completion(.empty)
        }
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        guard let dataEncoded = try? encoder.encode(Cache(feed: feed, timestamp: timestamp)) else {
            completion(anyNSError())
            return
        }
        do {
            try dataEncoded.write(to: storeURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}

class CodableFeedStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        try? FileManager.default.removeItem(at: storeURL())
    }
    
    override func tearDown() {
        super.tearDown()
        
        try? FileManager.default.removeItem(at: storeURL())
    }

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for retrieve completion")
        sut.retrieve { result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("Expected empty, got \(result) instead.")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for retrieve completion")
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                    case (.empty, .empty):
                    break
                default:
                    XCTFail("Expected retrieving twice from empty cache to delivers same empty result, got \(firstResult) and \(secondResult) instead.")
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let feed = uniqueFeedImage().local
        let timestamp = Date()
        
        let exp = expectation(description: "Wait for retrieve completion")
        sut.insert(feed, timestamp: timestamp) { insertedError in
            XCTAssertNil(insertedError)
            
            sut.retrieve { retrivedResult in
                switch retrivedResult {
                    case let .found(feed: retrievedFeed, timestamp: retrievedTimestamp):
                        XCTAssertEqual(feed, retrievedFeed)
                        XCTAssertEqual(timestamp, retrievedTimestamp)
                    break
                default:
                    XCTFail("Expected inserted values, got \(retrivedResult) instead.")
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func storeURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!.appendingPathComponent("feed-image.store")
    }
}
