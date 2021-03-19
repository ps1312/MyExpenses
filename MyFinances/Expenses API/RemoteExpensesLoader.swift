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

    public init(url: URL,  client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = Swift.Result<[ExpenseItem], Error>

    public func load(completion: @escaping (Result) -> Void) {
        client.get(url: url) { result in
            switch result {
            case .failure:
                completion(.failure(.connectivity))

            case let .success((data, response)):
                completion(ExpenseItemsMapper.map(response, data))
            }
        }
    }
}
