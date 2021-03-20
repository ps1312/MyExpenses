//
//  ExpensesLoader.swift
//  MyFinances
//
//  Created by Paulo Sergio da Silva Rodrigues on 17/03/21.
//

import Foundation

enum LoadExpensesResult {
    case success([ExpenseItem])
    case failure(Error)
}

protocol ExpensesLoader {
    func load(completion: @escaping (LoadExpensesResult) -> Void)
}
