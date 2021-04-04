//
//  ExpensesViewControllerTests.swift
//  MyFinancesiOSTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 03/04/21.
//

import XCTest
import MyFinances

class ExpensesViewController: UITableViewController {
    private var loader: ExpensesLoader?

    convenience init(loader: ExpensesLoader) {
        self.init()
        self.loader = loader

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        refresh()
    }

    @objc func refresh() {
        refreshControl?.beginRefreshing()

        loader?.load { [weak self] result in
            self?.refreshControl?.endRefreshing()
        }
    }
}

class ExpensesViewControllerTests: XCTestCase {
    func test_init_doesNotLoadExpenses() {
        let (_, loaderSpy) = makeSUT()

        XCTAssertEqual(loaderSpy.callsCount, 0)
    }

    func test_viewDidLoad_loadExpenses() {
        let (sut, loaderSpy) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(loaderSpy.callsCount, 1)
    }

    func test_userInitiatedExpensesReload_loadExpenses() {
        let (sut, loaderSpy) = makeSUT()

        sut.loadViewIfNeeded()

        sut.simulateUserInitiatedExpensesReload()
        XCTAssertEqual(loaderSpy.callsCount, 2)

        sut.simulateUserInitiatedExpensesReload()
        XCTAssertEqual(loaderSpy.callsCount, 3)
    }

    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }

    func test_viewDidLoad_hidesLoadingIndicatorOnLoadingComplete() {
        let (sut, loaderSpy) = makeSUT()

        sut.loadViewIfNeeded()

        loaderSpy.completeWith(error: anyNSError())

        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }

    func test_userInitiatedExpensesReload_showsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.simulateUserInitiatedExpensesReload()

        XCTAssertTrue(sut.isShowingLoadingIndicator)
    }

    func test_pullToRefresh_hidesLoadingIndicatorOnLoadingComplete() {
        let (sut, loaderSpy) = makeSUT()

        sut.simulateUserInitiatedExpensesReload()
        loaderSpy.completeWith(error: anyNSError())

        XCTAssertFalse(sut.isShowingLoadingIndicator)
    }

    func makeSUT(file: StaticString = #file, line: UInt = #line) -> (ExpensesViewController, LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let sut = ExpensesViewController(loader: loaderSpy)
        testMemoryLeak(loaderSpy, file: file, line: line)
        testMemoryLeak(sut, file: file, line: line)
        return (sut,  loaderSpy)
    }

    class LoaderSpy: ExpensesLoader {
        var completions = [((LoadExpensesResult) -> Void)]()
        var callsCount: Int = 0

        func load(completion: @escaping (LoadExpensesResult) -> Void) {
            callsCount += 1
            completions.append(completion)
        }

        func completeWith(error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
    }

}


private extension ExpensesViewController {
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
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
