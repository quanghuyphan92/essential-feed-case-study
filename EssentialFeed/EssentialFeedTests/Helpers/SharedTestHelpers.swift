//
//  ShareTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Phan Quang Huy on 1/16/22.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
