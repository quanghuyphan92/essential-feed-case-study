//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Phan Quang Huy on 1/18/22.
//

import Foundation

internal final class FeedCachePolicy {
    private static let calendar = Calendar(identifier: .gregorian)
    
    private init() {}
    
    private static var maxAgeCacheInDays: Int {
        return 7
    }
    
    internal static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxAgeCache = Calendar(identifier: .gregorian).date(byAdding: .day, value: maxAgeCacheInDays, to: timestamp) else {
            return false
        }
        return date < maxAgeCache
    }
}
