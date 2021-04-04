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
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refresh()
    }

    @objc func refresh() {
        loader?.load { _ in }
    }
}

class ExpensesViewControllerTests: XCTestCase {
    func test_init_doesNotLoadExpenses() {
        let loaderSpy = LoaderSpy()
        _ = ExpensesViewController(loader: loaderSpy)

        XCTAssertEqual(loaderSpy.callsCount, 0)
    }

    func test_viewDidLoad_loadExpenses() {
        let loaderSpy = LoaderSpy()
        let sut = ExpensesViewController(loader: loaderSpy)

        sut.loadViewIfNeeded()

        XCTAssertEqual(loaderSpy.callsCount, 1)
    }

    func test_pullToRefresh_loadExpenses() {
        let loaderSpy = LoaderSpy()
        let sut = ExpensesViewController(loader: loaderSpy)

        sut.loadViewIfNeeded()

        sut.refreshControl?.simulatePullToRefresh()

        XCTAssertEqual(loaderSpy.callsCount, 2)

        sut.refreshControl?.simulatePullToRefresh()

        XCTAssertEqual(loaderSpy.callsCount, 3)
    }

    class LoaderSpy: ExpensesLoader {
        var callsCount: Int = 0

        func load(completion: @escaping (LoadExpensesResult) -> Void) {
            callsCount += 1
        }
    }

}

extension UIRefreshControl {
    func simulatePullToRefresh() {
        self.allTargets.forEach { target in
            self.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { (target as NSObject).perform(Selector($0)) }
        }
    }
}
