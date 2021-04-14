//
//  ExpenseCellViewModelTests.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 14/04/21.
//

import XCTest
import MyFinances

class ExpenseCellViewModel {
    private let model: ExpenseItem

    init(model: ExpenseItem) {
        self.model = model
    }

    var title: String {
        return model.title
    }
}

class ExpenseCellViewModelTests: XCTestCase {
    func test_title_displaysModelTitle() {
        let model = makeExpense()
        let sut = ExpenseCellViewModel(model: model)

        XCTAssertEqual(sut.title, model.title)
    }

    func makeExpense(title: String = "Any title") -> ExpenseItem {
        return ExpenseItem(id: UUID(), title: title, amount: 9.99, createdAt: Date())
    }
}
