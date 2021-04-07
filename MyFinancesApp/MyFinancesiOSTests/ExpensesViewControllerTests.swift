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

    func test_errorViewRetry_requestsForExpenseItems() {
        let (sut, loaderSpy) = makeSUT()

        sut.loadViewIfNeeded()

        loaderSpy.completeWith(error: anyNSError())

        let errorView = sut.tableView.backgroundView as! ErrorView

        errorView.retryButton.allTargets.forEach { target in
            errorView.retryButton.actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach { (target as NSObject).perform(Selector($0)) }
        }

        XCTAssertEqual(loaderSpy.callsCount, 2)
    }

    func test_loadExpensesSuccess_displaysExpenseItems() {
        let (sut, loaderSpy) = makeSUT()

        let expense1 = makeExpense(
            amount: 0.99, amountText: "R$ 0,99",
            timestamp: 1617757108, createdAtText: "Hoje às 21:58"
        )

        let expense2 = makeExpense(
            amount: 0.99, amountText: "R$ 0,99",
            timestamp: 1617670708, createdAtText: "Ontem às 21:58"
        )

        let expense3 = makeExpense(
            amount: 250.53, amountText: "R$ 250,53",
            timestamp: 1617584308, createdAtText: "Anteontem às 21:58"
        )

        let expense4 = makeExpense(
            amount: 250.53, amountText: "R$ 250,53",
            timestamp: 1617497908, createdAtText: "03/04/2021 às 21:58"
        )

        let expectedItems = [expense1, expense2, expense3, expense4]
        let expectedItemsModels = [expense1.model, expense2.model, expense3.model, expense4.model]

        sut.loadViewIfNeeded()
        loaderSpy.completeWith(items: expectedItemsModels)

        let items = sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(items, 4)

        expectedItems.enumerated().forEach { index, expense in
            let ds = sut.tableView.dataSource
            let index = IndexPath(row: index, section: 0)
            let cell = ds?.tableView(sut.tableView, cellForRowAt: index) as! ExpenseViewCell
            XCTAssertEqual(cell.title, expense.model.title)
            XCTAssertEqual(cell.amount, expense.amountText)
            XCTAssertEqual(cell.createdAt, expense.createdAtText)
        }
    }

    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (ExpensesViewController, LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let sut = ExpensesViewController(loader: loaderSpy)
        testMemoryLeak(loaderSpy, file: file, line: line)
        testMemoryLeak(sut, file: file, line: line)
        return (sut,  loaderSpy)
    }

    func makeExpense(title: String = "Any title", amount: Float = 9.99, amountText: String = "R$ 9,99", timestamp: Double = 1617841530, createdAtText: String = "Amanhã às 21:25") -> (model: ExpenseItem, amountText: String, createdAtText: String) {
        let model = ExpenseItem(id: UUID(), title: title, amount: amount, createdAt: Date(timeIntervalSince1970: timestamp))
        return (model, amountText, createdAtText)
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

private extension ExpenseViewCell {
    var title: String {
        return titleLabel.text!
    }

    var amount: String {
        return amountLabel.text!
    }

    var createdAt: String {
        return createdAtLabel.text!
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
