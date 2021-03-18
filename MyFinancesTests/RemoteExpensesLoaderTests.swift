//
//  MyFinancesTests.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 17/03/21.
//

import XCTest
import MyFinances

class RemoteExpensesLoaderTests: XCTestCase {

    func test_init_doesMakeRequests() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        _ = RemoteExpensesLoader(url: url, client: client)

        XCTAssertEqual(client.requestCount, 0)
    }

    func test_load_makeRequestWithURL() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteExpensesLoader(url: url, client: client)

        sut.load { _ in }

        XCTAssertEqual(client.requestCount, 1)
        XCTAssertEqual(client.requestedUrl, url)
    }

    func test_load_deliversNoConnectivityErrorOnClientError() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteExpensesLoader(url: url, client: client)

        var receivedErrors = [RemoteExpensesLoader.Error]()
        sut.load { err in
            receivedErrors.append(err)
        }

        XCTAssertEqual(receivedErrors, [.connectivity])
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
