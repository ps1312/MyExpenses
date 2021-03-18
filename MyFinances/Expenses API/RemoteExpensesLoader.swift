//
//  RemoteExpensesLoader.swift
//  MyFinances
//
//  Created by Paulo Sergio da Silva Rodrigues on 17/03/21.
//

import Foundation

public class RemoteExpensesLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
    }

    public init(url: URL,  client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Error) -> Void) {
        client.get(url: url)
        completion(.connectivity)
    }
}
