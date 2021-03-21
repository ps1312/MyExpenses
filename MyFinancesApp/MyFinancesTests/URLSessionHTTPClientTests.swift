//
//  URLSessionHTTPClient.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 19/03/21.
//

import XCTest
import MyFinances

class URLSessionHTTPClient {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(_ url: URL, completion: @escaping () -> Void) {
        session.dataTask(with: url)
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)

        sut.get(url) { }

        XCTAssertEqual(session.requestedURLs, [url])
    }

    class URLSessionSpy: URLSession {
        var requestedURLs = [URL]()

        override func dataTask(with url: URL) -> URLSessionDataTask {
            requestedURLs.append(url)
            return FakeURLSessionDataTask()
        }

        class FakeURLSessionDataTask: URLSessionDataTask {}
    }
}
