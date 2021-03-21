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

    func get(_ url: URL, completion: @escaping (Error) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(error)
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_resumesDataTask() {
        let url = URL(string: "http://any-url.com")!
        let task = URLSessionDataTaskSpy()
        let session = URLSessionSpy()
        session.stub(url, with: task)
        let sut = URLSessionHTTPClient(session: session)

        sut.get(url) { _ in }

        XCTAssertEqual(task.resumedCallsCount, 1)
    }

    func test_getFromURL_deliversErrorOnDataTaskFailure() {
        let error = NSError(domain: "domain", code: 1)
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        session.stub(url, error: error)
        let sut = URLSessionHTTPClient(session: session)

        var capturedError: Error?
        sut.get(url) { capturedError = $0 }

        XCTAssertEqual(capturedError as NSError?, error)
    }

    class URLSessionSpy: URLSession {
        private struct Stub {
            let task: URLSessionDataTask
            let error: Error?
        }

        private var stubs = [URL: Stub]()

        func stub(_ url: URL, with task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Expected a stub for given url \(url)")
            }

            completionHandler(nil, nil, stub.error)
            return stub.task
        }

        class FakeURLSessionDataTask: URLSessionDataTask {
            override func resume() {
            }
        }
    }

    class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumedCallsCount = 0

        override func resume() {
            resumedCallsCount += 1
        }
    }
}
