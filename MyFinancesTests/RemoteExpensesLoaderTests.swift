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
        let (_, client) = makeSUT()

        XCTAssertEqual(client.requestCount, 0)
    }

    func test_load_makeRequestWithURL() {
        let url = URL(string: "http://another-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestCount, 1)
        XCTAssertEqual(client.requestedUrl, url)
    }

    func test_load_deliversNoConnectivityErrorOnClientError() {
        let (sut, _) = makeSUT()

        var receivedErrors = [RemoteExpensesLoader.Error]()
        sut.load { err in
            receivedErrors.append(err)
        }

        XCTAssertEqual(receivedErrors, [.connectivity])
    }

    func makeSUT(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteExpensesLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteExpensesLoader(url: url, client: client)

        return (sut, client)
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
