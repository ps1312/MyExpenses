//
//  MyFinancesAppUITests.swift
//  MyFinancesAppUITests
//
//  Created by Paulo Sergio da Silva Rodrigues on 15/04/21.
//

import XCTest

class MyFinancesAppUITests: XCTestCase {

    func test_onLauch_displaysExpensesWhenUserHasConnectivity() {
        let app = XCUIApplication()

        app.launch()

        XCTAssertEqual(app.cells.count, 2)
    }

}
