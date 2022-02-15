//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Phan Quang Huy on 11/9/21.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
