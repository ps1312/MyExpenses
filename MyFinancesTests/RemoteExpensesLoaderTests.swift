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

        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let error = NSError(domain: "any", code: 0)
            client.completeWith(error: error)
        }
    }

    func test_load_deliversInvalidDataErrorOnNon200StatusCodeEvenWithValidJSON() {
        let (sut, client) = makeSUT()

        let subjects = [199, 201, 300, 400, 500]
        subjects.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                let emptyListJSON = Data("{ \"items\": []}".utf8)
                client.completeWith(withStatusCode: code, data: emptyListJSON, at: index)
            }
        }
    }

    func test_load_deliversInvalidDataOn200StatusCodeAndInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.completeWith(withStatusCode: 200, data: invalidJSON)
        }
    }

    func test_load_deliversNoItemsOn200StatusCodeAndValidJSONEmptyList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = Data("{ \"items\": []}".utf8)
            client.completeWith(withStatusCode: 200, data: emptyListJSON)
        }
    }

    func test_load_deliversExpenseItemsOn200StatusCodeAndValidJSON() {
        let (sut, client) = makeSUT()

        let (item1, item1JSON) = makeExpenseItem(
            id: UUID(),
            title: "a title",
            amount: 35.99,
            createdAt: (date: Date(timeIntervalSince1970: 1616112660), iso8601String: "2021-03-19T15:07:00+11:00")
        )

        let (item2, item2JSON) = makeExpenseItem(
            id: UUID(),
            title: "another title",
            amount: 0.99,
            createdAt: (date: Date(timeIntervalSince1970: 1561255200), iso8601String: "2019-06-23T02:00:00+00:00")
        )

        let listJSON = [
            "items": [item1JSON, item2JSON]
        ]

        expect(sut, toCompleteWith: .success([item1, item2])) {
            let json = try! JSONSerialization.data(withJSONObject: listJSON)
            client.completeWith(withStatusCode: 200, data: json)
        }
    }

    func makeSUT(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteExpensesLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteExpensesLoader(url: url, client: client)

        return (sut, client)
    }

    func makeExpenseItem(id: UUID, title: String, amount: Float, createdAt: (date: Date, iso8601String: String)) -> (ExpenseItem, [String: Any]) {
        let model = ExpenseItem(id: UUID(), title: "a title", amount: 33.99, createdAt: Date(timeIntervalSince1970: 1598627222))

        let json: [String: Any] = [
            "id": model.id.uuidString,
            "title": model.title,
            "amount": model.amount,
            "created_at": "2020-08-28T15:07:02+00:00"
        ]

        return (model, json)
    }

    func expect(_ sut: RemoteExpensesLoader, toCompleteWith expectedResult: RemoteExpensesLoader.Result, when: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for client completion")

        var receivedResult = [RemoteExpensesLoader.Result]()
        sut.load { result in
            receivedResult.append(result)
            exp.fulfill()
        }

        when()

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedResult, [expectedResult], file: file, line: line)
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
