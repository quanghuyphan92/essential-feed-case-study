//
//  XCCaseTest+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by Phan Quang Huy on 12/11/21.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(instance: AnyObject?, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
