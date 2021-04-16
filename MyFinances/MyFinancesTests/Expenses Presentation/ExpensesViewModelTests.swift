//
//  ExpensesViewModelTests.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 13/04/21.
//

import XCTest
import MyFinances

class ExpensesViewModelTests: XCTestCase {
    func test_title_isLocalized() {
        let title = ExpensesViewModel.title

        let bundle = Bundle(for: ExpensesViewModel.self)
        let localizedKey = "EXPENSES_VIEW_TITLE"
        let localizedTitle = bundle.localizedString(forKey: localizedKey, value: nil, table: "Expenses")

        XCTAssertEqual(title, localizedTitle)
    }

    func test_loadExpenses_callsExpensesLoader() {
        let (sut, loaderSpy) = makeSUT()

        sut.loadExpenses()

        XCTAssertEqual(loaderSpy.callsCount, 1)
    }

    func test_loadExpenses_executeCallbacksCorrectlyInOrderOnLoadError() {
        let (sut, loaderSpy) = makeSUT()

        let expectedMessages: [Messages] = [
            .onIsLoadingChange(true),
            .onIsLoadingChange(false)
        ]

        assertMessages(sut, toHaveMessages: expectedMessages) {
            loaderSpy.completeWith(error: anyNSError())
        }
    }

    func test_loadExpenses_executeCallbacksCorrectlyInOrderOnHappyPath() {
        let (sut, loaderSpy) = makeSUT()

        let expectedMessages: [Messages] = [
            .onIsLoadingChange(true),
            .onExpensesLoad([]),
            .onIsLoadingChange(false)
        ]

        assertMessages(sut, toHaveMessages: expectedMessages) {
            loaderSpy.completeWith(items: [])
        }
    }

    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ExpensesViewModel, loaderSpy: LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let sut = ExpensesViewModel(loader: loaderSpy)

        testMemoryLeak(loaderSpy, file: file, line: line)
        testMemoryLeak(sut, file: file, line: line)

        return (sut, loaderSpy)
    }

    func assertMessages(_ sut: ExpensesViewModel, toHaveMessages expectedMessages: [Messages], when: () -> Void) {
        var capturedMessages = [Messages]()

        sut.onIsLoadingChange = { isLoading in
            capturedMessages.append(.onIsLoadingChange(isLoading))
        }

        sut.onExpensesLoad = { expenses in
            capturedMessages.append(.onExpensesLoad(expenses))
        }

        sut.loadExpenses()

        when()

        XCTAssertEqual(capturedMessages, expectedMessages)
    }

    enum Messages: Equatable {
        case onIsLoadingChange(_ isLoading: Bool)
        case onExpensesLoad(_ expenses: [ExpenseItem])
    }
}
