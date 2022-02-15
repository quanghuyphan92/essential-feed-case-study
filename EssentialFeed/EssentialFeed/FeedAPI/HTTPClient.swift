//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Phan Quang Huy on 11/25/21.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
