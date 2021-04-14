//
//  ExpensesViewModelTests.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 13/04/21.
//

import XCTest
import MyFinances

class ExpensesViewModel {
    private let loader: ExpensesLoader

    init(loader: ExpensesLoader) {
        self.loader = loader
    }

    func loadExpenses() {
        loader.load { _ in }
    }

}

class ExpensesViewModelTests: XCTestCase {
    func test_loadExpenses_callsExpensesLoader() {
        let loaderSpy = LoaderSpy()
        let sut = ExpensesViewModel(loader: loaderSpy)

        sut.loadExpenses()

        XCTAssertEqual(loaderSpy.callsCount, 1)
    }

    class LoaderSpy: ExpensesLoader {
        var callsCount: Int = 0

        func load(completion: @escaping (LoadExpensesResult) -> Void) {
            callsCount += 1
        }
    }
}
