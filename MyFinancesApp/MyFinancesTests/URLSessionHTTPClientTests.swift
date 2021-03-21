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

    private struct UnexpectedError: Error {}

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UnexpectedError()))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    override func setUp() {
        URLProtocolStub.startInterceptingRequests()
    }

    override func tearDown() {
        URLProtocolStub.stopInterceptingRequests()
    }

    func test_getFromURL_makesGETRequestWithCorrectURL() {
        let url = URL(string: "http://another-url.com")!
        let exp = expectation(description: "Wait for session completion")

        URLProtocolStub.setStub(data: nil, response: nil, error: anyNSError())
        URLProtocolStub.setRequestObserver { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }

        makeSUT().get(from: url) { _ in }

        wait(for: [exp], timeout: 1.0)
    }

    func test_getFromURL_deliversErrorOnRequestFailure() {
        let receivedError = resultErrorFor(data: nil, response: nil, error: anyNSError())

        XCTAssertNotNil(receivedError)
    }

    func test_getFromURL_deliversErrorOnInvalidCases() {
        let nonHTTPURLResponse = URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
        let anyHTTPURLResponse = HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
        let anyData = Data()

        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nil, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nonHTTPURLResponse, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: anyHTTPURLResponse, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(data: anyData, response: nonHTTPURLResponse, error: nil))
    }

    func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        testMemoryLeak(sut, file: file, line: line)
        return sut
    }

    func resultErrorFor(data: Data?, response: URLResponse?, error: Error?) -> Error? {
        let exp = expectation(description: "Wait for completion")
        URLProtocolStub.setStub(data: data, response: response, error: error)

        var capturedError: Error?
        makeSUT().get(from: anyURL()) { result in
            switch result {
            case .failure(let error as NSError?):
                capturedError = error

            case.success:
                XCTFail("Expected failure, instead got \(result)")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        return capturedError
    }

    class URLProtocolStub: URLProtocol {
        private static var stub: Stub?

        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }

        static var requestObserver: ((URLRequest) -> Void)?

        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }

        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }

        static func setStub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }

        static func setRequestObserver(completion: @escaping (URLRequest) -> Void) {
            requestObserver = completion
        }

        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}
    }

}
