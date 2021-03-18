//
//  MyFinancesTests.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 17/03/21.
//

import XCTest
@testable import MyFinances

class FirebaseExpensesLoader {

}

class FirebaseExpensesLoaderTests: XCTestCase {

    func test_init_doesMakeRequests() {
        let client = HTTPClientSpy()
        _ = FirebaseExpensesLoader()

        XCTAssertEqual(client.requestCount, 0)
    }

    class HTTPClientSpy {
        var requestCount: Int = 0
    }

}
