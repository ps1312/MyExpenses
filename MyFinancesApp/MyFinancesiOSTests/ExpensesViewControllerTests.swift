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

    class LoaderSpy: ExpensesLoader {
        var callsCount: Int = 0

        func load(completion: @escaping (LoadExpensesResult) -> Void) {
            callsCount += 1
        }
    }

}
