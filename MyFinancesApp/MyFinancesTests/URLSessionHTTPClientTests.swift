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
        session.dataTask(with: url).resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_resumesDataTask() {
        let url = URL(string: "http://any-url.com")!
        let task = URLSessionDataTaskSpy()
        let session = URLSessionSpy()
        session.stub(url, with: task)
        let sut = URLSessionHTTPClient(session: session)

        sut.get(url) { }

        XCTAssertEqual(task.resumedCallsCount, 1)
    }

    class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumedCallsCount = 0

        override func resume() {
            resumedCallsCount += 1
        }
    }

    class URLSessionSpy: URLSession {
        var requestedURLs = [URL]()
        var stubs = [URL: URLSessionDataTask]()

        func stub(_ url: URL, with task: URLSessionDataTask) {
            stubs[url] = task
        }

        override func dataTask(with url: URL) -> URLSessionDataTask {
            requestedURLs.append(url)
            return stubs[url] ?? FakeURLSessionDataTask()
        }

        class FakeURLSessionDataTask: URLSessionDataTask {
            override func resume() {
            }
        }
    }
}
