//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Phan Quang Huy on 1/15/22.
//

import Foundation

public class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public typealias SaveResult = Error?
    public typealias LoadResult = FeedLoader.Result
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, completion: completion)
            }
        }
    }
    
    private func cache(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: self.currentDate(), completion: { [weak self] error in
            guard self != nil else { return }
            completion(error)
        })
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case let .success(.some(cachedFeed)) where FeedCachePolicy.validate(cachedFeed.timestamp, against: self.currentDate()):
                completion(.success(cachedFeed.feed.toModels()))
                
            case .success:
                completion(.success([]))
            }
        }
    }
    
    public func validateCache() {
        store.retrieve { [unowned self] result in
            switch result {
            case .failure:
                self.store.deleteCachedFeed { _ in }
            case let .success(.some(cachedFeed)) where !FeedCachePolicy.validate(cachedFeed.timestamp, against: self.currentDate()):
                self.store.deleteCachedFeed { _ in }
            default:
                break
            }
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}
