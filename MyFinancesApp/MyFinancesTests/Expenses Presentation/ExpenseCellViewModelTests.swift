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
    private lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()

    init(model: ExpenseItem) {
        self.model = model
    }

    var title: String {
        return model.title
    }

    var amount: String {
        return "R$ " + numberFormatter.string(from: model.amount as NSNumber)!
    }
}

class ExpenseCellViewModelTests: XCTestCase {
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

    func makeExpense(title: String = "Any title", amount: Double = 9.99) -> ExpenseItem {
        return ExpenseItem(id: UUID(), title: title, amount: amount, createdAt: Date())
    }
}
