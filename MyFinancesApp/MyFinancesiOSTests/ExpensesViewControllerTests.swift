//
//  ExpensesViewControllerTests.swift
//  MyFinancesiOSTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 03/04/21.
//

import XCTest
import MyFinances
import MyFinancesiOS

class ExpensesViewControllerTests: XCTestCase {
    func test_loadExpensesActions_requestsForExpenseItems() {
        let (sut, loaderSpy) = makeSUT()
        XCTAssertEqual(loaderSpy.callsCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loaderSpy.callsCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedExpensesReload()
        XCTAssertEqual(loaderSpy.callsCount, 2, "Expected another loading request once user initiates a reload")

        sut.simulateUserInitiatedExpensesReload()
        XCTAssertEqual(loaderSpy.callsCount, 3, "Expected another loading request once user initiates a reload")
    }

    func test_userInitiatesExpensesLoad_showsLoadingIndicatorCorrecty() {
        let (sut, loaderSpy) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected a loading indicator once view is loaded")

        loaderSpy.completeWith(error: anyNSError())
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes")

        sut.simulateUserInitiatedExpensesReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected a loading indicator once user initiates a reload")

        loaderSpy.completeWith(error: anyNSError(), at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once reload completes")
    }

    func test_loadExpensesFailure_showsErrorViewOnLoadFailure() {
        let (sut, loaderSpy) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.isShowingErrorView)

        loaderSpy.completeWith(error: anyNSError())

        XCTAssertTrue(sut.isShowingErrorView)
    }

    func test_loadExpensesSuccess_displaysExpenseItems() {
        let (sut, loaderSpy) = makeSUT()
        let expectedItems = [makeExpense(), makeExpense()]

        sut.loadViewIfNeeded()
        loaderSpy.completeWith(items: expectedItems)

        let items = sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(items, 2)

        expectedItems.enumerated().forEach { index, expense in
            let ds = sut.tableView.dataSource
            let index = IndexPath(row: index, section: 0)
            let cell = ds?.tableView(sut.tableView, cellForRowAt: index) as! ExpenseViewCell
            XCTAssertEqual(cell.titleLabel.text, expense.title)
            XCTAssertEqual(cell.amountLabel.text, "R$ 9,99")
            XCTAssertEqual(cell.createdAtLabel.text, "Amanhã às 21:25")
        }
    }

    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (ExpensesViewController, LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let sut = ExpensesViewController(loader: loaderSpy)
        testMemoryLeak(loaderSpy, file: file, line: line)
        testMemoryLeak(sut, file: file, line: line)
        return (sut,  loaderSpy)
    }

    func makeExpense(title: String = "Any title", amount: Float = 9.99) -> ExpenseItem {
        return ExpenseItem(id: UUID(), title: title, amount: amount, createdAt: Date(timeIntervalSince1970: 1617841530))
    }

    class LoaderSpy: ExpensesLoader {
        var completions = [((LoadExpensesResult) -> Void)]()
        var callsCount: Int {
            return completions.count
        }

        func load(completion: @escaping (LoadExpensesResult) -> Void) {
            completions.append(completion)
        }

        func completeWith(error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }

        func completeWith(items: [ExpenseItem], at index: Int = 0) {
            completions[index](.success(items))
        }
    }
}

private extension ExpensesViewController {
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }

    var isShowingErrorView: Bool {
        return self.tableView.backgroundView !== nil
    }

    func simulateUserInitiatedExpensesReload() {
        refreshControl?.simulatePullToRefresh()
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        self.allTargets.forEach { target in
            self.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { (target as NSObject).perform(Selector($0)) }
        }
    }
}
