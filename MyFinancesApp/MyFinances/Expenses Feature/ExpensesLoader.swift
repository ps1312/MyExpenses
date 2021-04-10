//
//  ExpensesLoader.swift
//  MyFinances
//
//  Created by Paulo Sergio da Silva Rodrigues on 17/03/21.
//

import Foundation

public protocol ExpensesLoader {
    typealias LoadExpensesResult = Result<[ExpenseItem], Error>

    func load(completion: @escaping (LoadExpensesResult) -> Void)
}
