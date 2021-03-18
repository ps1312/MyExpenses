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

        XCTAssertEqual(client.requestedUrls, [])
    }

    func test_load_makeRequestWithURL() {
        let url = URL(string: "http://another-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedUrls, [url])
    }

    func test_load_deliversNoConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: [.connectivity]) {
            let error = NSError(domain: "any", code: 0)
            client.completeWith(error: error)
        }
    }

    func test_load_deliversInvalidDataErrorOnNon200StatusCode() {
        let (sut, client) = makeSUT()

        [199, 201, 300, 400, 500].enumerated().forEach { index, code in
            expect(sut, toCompleteWith: [.invalidData]) {
                client.completeWith(withStatusCode: code, at: index)
            }
        }
    }

    func makeSUT(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteExpensesLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteExpensesLoader(url: url, client: client)

        return (sut, client)
    }

    func expect(_ sut: RemoteExpensesLoader, toCompleteWith expectedError: [RemoteExpensesLoader.Error], when: () -> Void) {
        let exp = expectation(description: "wait for client completion")

        var receivedErrors = [RemoteExpensesLoader.Error]()
        sut.load { err in
            receivedErrors.append(err)
            exp.fulfill()
        }

        when()

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedErrors, expectedError)
    }

    class HTTPClientSpy: HTTPClient {
        var requestedUrls = [URL]()
        var completions = [(Swift.Result<HTTPURLResponse, Error>) -> Void]()

        func get(url: URL, completion: @escaping (Swift.Result<HTTPURLResponse, Error>) -> Void) {
            requestedUrls.append(url)
            completions.append(completion)
        }

        func completeWith(error: Error) {
            completions[0](.failure(error))
        }

        func completeWith(withStatusCode code: Int, at index: Int) {
            let response = HTTPURLResponse(url: requestedUrls[0], statusCode: code, httpVersion: nil, headerFields: nil)!
            completions[index](.success(response))
        }
    }

}
