//
//  ExpensesViewControllerTests.swift
//  MyFinancesiOSTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 03/04/21.
//

import XCTest
import MyFinances
import MyFinancesiOS
import MyFinancesApp

class ExpensesViewControllerTests: XCTestCase {
    let todayAtFixedHour: Date = Calendar(identifier: .gregorian).date(bySettingHour: 20, minute: 00, second: 00, of: Date())!

    func test_viewTitle_displaysLocalizedTitle() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        let bundle = Bundle(for: ExpensesViewModel.self)
        let localizedKey = "EXPENSES_VIEW_TITLE"
        let localizedTitle = bundle.localizedString(forKey: localizedKey, value: nil, table: "Expenses")

        XCTAssertNotEqual(localizedKey, localizedTitle, "Missing localized string for key: \(localizedKey)")
        XCTAssertEqual(sut.title, localizedTitle)
    }

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

    func test_loadExpensesSuccess_displaysExpenseItems() {
        let (sut, loaderSpy) = makeSUT()

        let expense1 = makeExpense(
            amount: (value: 0.99, text: "R$ 0,99"),
            createdAt: (value: todayAtFixedHour, text: "Hoje às 20:00")
        )

        let expense2 = makeExpense(
            amount: (value: 15.99, text: "R$ 15,99"),
            createdAt: (value: todayAtFixedHour.adding(days: -1), text: "Ontem às 20:00")
        )

        let date = Date(timeIntervalSince1970: 1609498800)
        let expense3 = makeExpense(
            amount: (value: 0.99, text: "R$ 0,99"),
            createdAt: (value: date, text: "01/01/2021 às 08:00")
        )

        sut.loadViewIfNeeded()
        loaderSpy.completeWith(items: [])
        assertThat(sut, isRendering: [])

        loaderSpy.completeWith(items: [expense1.model])
        assertThat(sut, isRendering: [expense1])

        loaderSpy.completeWith(items: [expense1.model, expense2.model, expense3.model])
        assertThat(sut, isRendering: [expense1, expense2, expense3])
    }

    func test_loadExpenses_dispatchesFromBackgrounToMainThread() {
        let (sut, loaderSpy) = makeSUT()

        let expense = makeExpense(
            amount: (value: 0.99, text: "R$ 0,99"),
            createdAt: (value: todayAtFixedHour, text: "Hoje às 20:00")
        )

        sut.loadViewIfNeeded()

        let exp = expectation(description: "wait for background dispatch")
        DispatchQueue.global().async {
            loaderSpy.completeWith(items: [expense.model])
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func assertThat(_ sut: ExpensesViewController, isRendering items: [(model: ExpenseItem, amountText: String, createdAtText: String)]) {
        XCTAssertEqual(sut.numberOfRenderedExpenseItemViews, items.count)

        items.enumerated().forEach { index, expense in
            let cell = sut.expenseItemView(at: index) as! ExpenseViewCell
            XCTAssertEqual(cell.title, expense.model.title)
            XCTAssertEqual(cell.createdAt, expense.createdAtText)
            XCTAssertEqual(cell.amount, expense.amountText)
        }
    }

    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (ExpensesViewController, LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let sut = ExpensesUIComposer.compose(loader: loaderSpy)
        testMemoryLeak(loaderSpy, file: file, line: line)
        testMemoryLeak(sut, file: file, line: line)
        return (sut,  loaderSpy)
    }

    func makeExpense(title: String = "Any title", amount: (value: Double, text: String), createdAt: (value: Date, text: String)) -> (model: ExpenseItem, amountText: String, createdAtText: String) {
        let model = ExpenseItem(id: UUID(), title: title, amount: amount.value, createdAt: createdAt.value)

        return (model, amountText: amount.text, createdAtText: createdAt.text)
    }

    func makeExpenseCell(amountText: String, createdAtText: String) -> (amountText: String, createdAtText: String) {
        return (amountText: amountText, createdAtText: createdAtText)
    }

    class LoaderSpy: ExpensesLoader {
        var completions = [((LoadExpensesResult) -> Void)]()
        var callsCount: Int {
            return completions.count
        }

        public func load(completion: @escaping (LoadExpensesResult) -> Void) {
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

private extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }

    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
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

    var numberOfRenderedExpenseItemViews: Int {
        return (tableView.dataSource?.tableView(tableView, numberOfRowsInSection: 0))!
    }

    func simulateUserInitiatedExpensesReload() {
        refreshControl?.simulatePullToRefresh()
    }

    func expenseItemView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: 0)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        self.allTargets.forEach { target in
            self.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { (target as NSObject).perform(Selector($0)) }
        }
    }
}

private extension UIButton {
    func simulateTap() {
        self.allTargets.forEach { target in
            self.actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach { (target as NSObject).perform(Selector($0)) }
        }
    }
}
