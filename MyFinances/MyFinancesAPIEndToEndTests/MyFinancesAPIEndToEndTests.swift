//
//  MyFinancesAPIEndToEndTests.swift
//  MyFinancesAPIEndToEndTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 21/03/21.
//

import XCTest
import MyFinances

class MyFinancesAPIEndToEndTests: XCTestCase {

    func test_getExpenses_returnExpectedExpensesOnAPIEndpoint() {
        switch getExpensesResult() {
        case .success(let expenses):
            XCTAssertEqual(expenses.count, 2)
            XCTAssertEqual(expenses[0], expectedItem(at: 0))
            XCTAssertEqual(expenses[1], expectedItem(at: 1))

        case .failure:
            XCTFail("Expected success, instead got error")
        }
    }

    func getExpensesResult(file: StaticString = #file, line: UInt = #line) -> RemoteExpensesLoader.Result {
        let url = URL(string: "https://nextjs-vercel-jzg31jrxq-ps1312.vercel.app/api/static-expenses")!
        let client = URLSessionHTTPClient()
        let loader = RemoteExpensesLoader(url: url, client: client)

        testMemoryLeak(client, file: file, line: line)
        testMemoryLeak(loader, file: file, line: line)

        let exp = expectation(description: "Wait for request completion")

        var capturedResult: RemoteExpensesLoader.Result!
        loader.load { result in
            capturedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)

        return capturedResult
    }

    func expectedItem(at index: Int) -> ExpenseItem {
        return ExpenseItem(id: id(at: index), title: title(at: index), amount: amount(at: index), createdAt: createdAt(at: index))
    }

    func id(at index: Int) -> UUID {
        let ids = [
            "0B8FB609-39D8-4E6E-8F57-0DCBEBD23850",
            "1ACD6801-CDFA-4C11-9BA8-803A774EC49D"
        ]
        return UUID(uuidString: ids[index])!
    }

    func title(at index: Int) -> String {
        let titles = [
            "move",
            "mc germes"
        ]
        return titles[index]
    }

    func amount(at index: Int) -> Double {
        let amounts: [Double] = [
            99999.99,
            19.9
        ]
        return amounts[index]
    }

    func createdAt(at index: Int) -> Date {
        let timestamps = [
            "2021-03-20T19:00:00+00:00",
            "2021-03-19T00:11:00+00:00"
        ]

        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: timestamps[index])!

        return date
    }

}
