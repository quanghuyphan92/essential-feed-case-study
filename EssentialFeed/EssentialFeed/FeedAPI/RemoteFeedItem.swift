//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Phan Quang Huy on 1/16/22.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
