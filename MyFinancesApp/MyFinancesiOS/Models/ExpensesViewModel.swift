//
//  ExpensesViewModel.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 10/04/21.
//

import Foundation
import MyFinances

class ExpensesViewModel {
    private let loader: ExpensesLoader

    init(loader: ExpensesLoader) {
        self.loader = loader
    }

    var isLoading: ((Bool) -> Void)?
    var onExpensesLoad: (([ExpenseItem]) -> Void)?

    func loadExpenses() {
        isLoading?(true)

        loader.load { [weak self] result in
            if let items = try? result.get() {
                self?.onExpensesLoad?(items)
            }

            self?.isLoading?(false)
        }
    }
}
