//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Phan Quang Huy on 11/9/21.
//

import XCTest

class RemoteFeedLoader {
    
}

class HTTPClient {
    static let shared = HTTPClient()
    
    var requestedURL: URL?
    
    private init() {}
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient.shared
        let _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
