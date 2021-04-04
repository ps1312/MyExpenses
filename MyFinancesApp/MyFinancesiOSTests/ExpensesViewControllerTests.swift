//
//  ExpensesViewControllerTests.swift
//  MyFinancesiOSTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 03/04/21.
//

import XCTest

class ExpensesViewController {
    init(loader: ExpensesViewControllerTests.LoaderSpy) {

    }
}

class ExpensesViewControllerTests: XCTestCase {
    func test_init_doesNotLoadExpenses() {
        let loaderSpy = LoaderSpy()
        _ = ExpensesViewController(loader: loaderSpy)

        XCTAssertEqual(loaderSpy.callsCount, 0)
    }

    class LoaderSpy {
        var callsCount: Int = 0
    }
}
