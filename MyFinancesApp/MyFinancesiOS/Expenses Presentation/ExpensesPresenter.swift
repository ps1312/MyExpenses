//
//  ExpensesPresenter.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 10/04/21.
//

import Foundation
import MyFinances

protocol ExpensesLoadView {
    func display(isLoading: Bool)
}

protocol ExpensesView {
    func display(expenses: [ExpenseItem])
}

class ExpensesPresenter {
    private let loader: ExpensesLoader

    init(loader: ExpensesLoader) {
        self.loader = loader
    }

    var loadView: ExpensesLoadView?
    var expensesView: ExpensesView?

    func loadExpenses() {
        loadView?.display(isLoading: true)

        loader.load { [weak self] result in
            if let items = try? result.get() {
                self?.expensesView?.display(expenses: items)
            }

            self?.loadView?.display(isLoading: false)
        }
    }
}
