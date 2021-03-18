//
//  MyFinancesTests.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 17/03/21.
//

import XCTest
@testable import MyFinances

protocol HTTPClient {
    func get(url: URL)
}

class FirebaseExpensesLoader {
    let url: URL
    let client: HTTPClient

    init(url: URL,  client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load() {
        client.get(url: url)
    }
}

class FirebaseExpensesLoaderTests: XCTestCase {

    func test_init_doesMakeRequests() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        _ = FirebaseExpensesLoader(url: url, client: client)

        XCTAssertEqual(client.requestCount, 0)
    }

    func test_load_makeRequestWithURL() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        let sut = FirebaseExpensesLoader(url: url, client: client)

        sut.load()

        XCTAssertEqual(client.requestCount, 1)
        XCTAssertEqual(client.requestedUrl, url)

    }

    class HTTPClientSpy: HTTPClient {
        var requestCount: Int = 0
        var requestedUrl: URL? = nil

        func get(url: URL) {
            requestCount += 1
            requestedUrl = url
        }
    }

}
