//
//  ExpensesLoader.swift
//  MyFinances
//
//  Created by Paulo Sergio da Silva Rodrigues on 17/03/21.
//

import Foundation

public enum LoadExpensesResult {
    case success([ExpenseItem])
    case failure(Error)
}

public protocol ExpensesLoader {
    func load(completion: @escaping (LoadExpensesResult) -> Void)
}
