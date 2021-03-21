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
    func test_getFromURL_deliversErrorOnDataTaskFailure() {
        URLProtocolStub.startInterceptingRequests()
        let error = NSError(domain: "domain", code: 1)
        let url = URL(string: "http://any-url.com")!
        let sut = URLSessionHTTPClient()
        let exp = expectation(description: "Wait for session completion")

        URLProtocolStub.setStub(url, error: error)

        sut.get(from: url) { result in
            switch result {
            case .failure(let capturedError as NSError?):
                XCTAssertNotNil(capturedError)

            case.success:
                XCTFail("Expected failure, instead got \(result)")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.stopInterceptingRequests()
    }

    class URLProtocolStub: URLProtocol {
        private static var stub: Stub?

        private struct Stub {
            let error: Error?
        }

        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }

        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
        }

        static func setStub(_ url: URL, error: Error) {
            stub = Stub(error: error)
        }

        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            guard let stub = URLProtocolStub.stub else {
                fatalError("Expected to have a stub")
            }

            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}
    }

}
