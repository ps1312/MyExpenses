//
//  ExpensesViewModel.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 10/04/21.
//

import Foundation
import MyFinances

class ExpensesViewModel {
    typealias Observer<T> = ((T) -> Void)

    private let loader: ExpensesLoader

    init(loader: ExpensesLoader) {
        self.loader = loader
    }

    var onIsLoadingChange: Observer<Bool>?
    var onExpensesLoad: Observer<[ExpenseItem]>?

    func loadExpenses() {
        onIsLoadingChange?(true)

        loader.load { [weak self] result in
            if let items = try? result.get() {
                self?.onExpensesLoad?(items)
            }

            self?.onIsLoadingChange?(false)
        }
    }
}
