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

        expect(sut, toCompleteWith: .connectivity) {
            let error = NSError(domain: "any", code: 0)
            client.completeWith(error: error)
        }
    }

    func test_load_deliversInvalidDataErrorOnNon200StatusCode() {
        let (sut, client) = makeSUT()

        [199, 201, 300, 400, 500].enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .invalidData) {
                client.completeWith(withStatusCode: code, at: index)
            }
        }
    }

    func test_load_deliversInvalidDataOn200StatusCodeAndInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .invalidData) {
            let invalidJSON = Data("invalid json".utf8)
            client.completeWith(withStatusCode: 200, data: invalidJSON)
        }
    }

    func makeSUT(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteExpensesLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteExpensesLoader(url: url, client: client)

        return (sut, client)
    }

    func expect(_ sut: RemoteExpensesLoader, toCompleteWith expectedError: RemoteExpensesLoader.Error, when: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for client completion")

        var receivedResult = [RemoteExpensesLoader.Result]()
        sut.load { result in
            receivedResult.append(result)
            exp.fulfill()
        }

        when()

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedResult, [.failure(expectedError)], file: file, line: line)
    }

    class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (Result<(Data, HTTPURLResponse), Error>) -> Void)]()

        var requestedUrls: [URL] {
            return messages.map { $0.url }
        }

        func get(url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
            messages.append((url: url, completion: completion))
        }

        func completeWith(error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func completeWith(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: messages[index].url, statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
    }

}
