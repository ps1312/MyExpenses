//
//  ExpensesViewModel.swift
//  MyFinances
//
//  Created by Paulo Sergio da Silva Rodrigues on 14/04/21.
//

import Foundation

public class ExpensesViewModel {
    public typealias Observer<T> = ((T) -> Void)

    private let loader: ExpensesLoader

    public var onIsLoadingChange: Observer<Bool>?
    public var onExpensesLoad: Observer<[ExpenseItem]>?

    public init(loader: ExpensesLoader) {
        self.loader = loader
    }

    public func loadExpenses() {
        onIsLoadingChange?(true)

        loader.load { [weak self] result in
            if let items = try? result.get() {
                self?.onExpensesLoad?(items)
            }

            self?.onIsLoadingChange?(false)
        }
    }

}
