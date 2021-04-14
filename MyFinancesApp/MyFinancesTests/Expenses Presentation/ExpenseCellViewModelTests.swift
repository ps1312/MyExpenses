//
//  ExpenseCellViewModelTests.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 14/04/21.
//

import XCTest
import MyFinances

class ExpenseCellViewModelTests: XCTestCase {
    let todayAtFixedHour: Date = Calendar(identifier: .gregorian).date(bySettingHour: 20, minute: 00, second: 00, of: Date())!

    func test_title_displaysModelTitle() {
        let model = makeExpense()
        let sut = ExpenseCellViewModel(model: model)

        XCTAssertEqual(sut.title, model.title)
    }

    func test_amount_displaysModelAmountFormatted() {
        let amount = 100.00
        let model = makeExpense(amount: amount)
        let sut = ExpenseCellViewModel(model: model)

        XCTAssertEqual(sut.amount, "R$ 100,00")
    }

    func test_createdAt_displaysModelCreatedAtFormatted() {
        let createdAt = todayAtFixedHour
        let model = makeExpense(createdAt: createdAt)
        let sut = ExpenseCellViewModel(model: model)

        XCTAssertEqual(sut.createdAt, "Hoje às 20:00")
    }

    func makeExpense(title: String = "Any title", amount: Double = 9.99, createdAt: Date = Date()) -> ExpenseItem {
        return ExpenseItem(id: UUID(), title: title, amount: amount, createdAt: createdAt)
    }
}
