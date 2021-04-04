//
//  ExpensesViewControllerTests.swift
//  MyFinancesiOSTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 03/04/21.
//

import XCTest

class ExpensesViewController: UITableViewController {
    private var loader: ExpensesViewControllerTests.LoaderSpy?

    convenience init(loader: ExpensesViewControllerTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        loader?.load()
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

    class LoaderSpy {
        var callsCount: Int = 0

        func load() {
            callsCount += 1
        }
    }

}
