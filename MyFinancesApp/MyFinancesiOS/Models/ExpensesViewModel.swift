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

    enum State {
        case pending
        case loading
        case loaded(_ items: [ExpenseItem])
    }

    var state: State = State.pending {
        didSet { onChange?(state) }
    }

    var onChange: ((State) -> Void)?

    func loadExpenses() {
        state = .loading

        loader.load { [weak self] result in
            if let items = try? result.get() {
                self?.state = .loaded(items)
            }

            self?.state = .pending
        }
    }
}
