//
//  URLSessionHTTPClient.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 19/03/21.
//

import XCTest
import MyFinances

class URLSessionHTTPClient: HTTPClient {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
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

        sut.get(from: url) { _ in }

        XCTAssertEqual(task.resumedCallsCount, 1)
    }

    func test_getFromURL_deliversErrorOnDataTaskFailure() {
        let error = NSError(domain: "domain", code: 1)
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        let exp = expectation(description: "Wait for session completion")

        session.stub(url, error: error)
        sut.get(from: url) { result in
            switch result {
            case .failure(let capturedError as NSError?):
                XCTAssertEqual(capturedError, error)

            case.success:
                XCTFail("Expected failure, instead got \(result)")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
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
