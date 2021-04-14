//
//  ExpensesViewModelTests.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 13/04/21.
//

import XCTest
import MyFinances

class ExpensesViewModel {
    typealias Observer<T> = ((T) -> Void)

    private let loader: ExpensesLoader

    var onIsLoadingChange: Observer<Bool>?

    init(loader: ExpensesLoader) {
        self.loader = loader
    }

    func loadExpenses() {
        onIsLoadingChange?(true)

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

    func test_loadExpenses_callsForIsLoadingChangeCallback() {
        var messages = [Messages]()
        let loaderSpy = LoaderSpy()
        let sut = ExpensesViewModel(loader: loaderSpy)

        sut.onIsLoadingChange = { isLoading in
            messages.append(.onIsLoadingChange(isLoading))
        }

        sut.loadExpenses()

        XCTAssertEqual(messages, [.onIsLoadingChange(true)])
    }

    enum Messages: Equatable {
        case onIsLoadingChange(_ isLoading: Bool)
        case onExpensesLoad(expenses: [ExpenseItem])
    }

    class LoaderSpy: ExpensesLoader {
        var callsCount: Int = 0

        func load(completion: @escaping (LoadExpensesResult) -> Void) {
            callsCount += 1
        }
    }
}
