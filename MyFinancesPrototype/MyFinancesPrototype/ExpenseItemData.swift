//
//  ExpenseItemData.swift
//  MyFinancesPrototype
//
//  Created by Paulo Sergio da Silva Rodrigues on 03/04/21.
//

import Foundation

func generateRandomDate(daysBack: Int) -> Date? {
    let day = arc4random_uniform(UInt32(daysBack))+1
    let hour = arc4random_uniform(23)
    let minute = arc4random_uniform(59)

    let today = Date(timeIntervalSinceNow: 0)
    let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
    var offsetComponents = DateComponents()
    offsetComponents.day = -1 * Int(day - 1)
    offsetComponents.hour = -1 * Int(hour)
    offsetComponents.minute = -1 * Int(minute)

    let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
    return randomDate
}

extension ExpenseItemViewModel {
    static var prototypeExpenses: [ExpenseItemViewModel] = [
        ExpenseItemViewModel(title: "Expense 1", amount: 11.11, createdAt: generateRandomDate(daysBack: 1)!),
        ExpenseItemViewModel(title: "Expense 2", amount: 22.40, createdAt: generateRandomDate(daysBack: 2)!),
        ExpenseItemViewModel(title: "Expense 3", amount: 50.63, createdAt: generateRandomDate(daysBack: 3)!),
        ExpenseItemViewModel(title: "Expense 4", amount: 12.34, createdAt: generateRandomDate(daysBack: 4)!),
        ExpenseItemViewModel(title: "Expense 5", amount: 31.45, createdAt: generateRandomDate(daysBack: 5)!),
        ExpenseItemViewModel(title: "Expense 6", amount: 50.00, createdAt: generateRandomDate(daysBack: 6)!),
        ExpenseItemViewModel(title: "Expense 7", amount: 22.87, createdAt: generateRandomDate(daysBack: 7)!),
        ExpenseItemViewModel(title: "Expense 8", amount: 199.99, createdAt: generateRandomDate(daysBack: 8)!),
        ExpenseItemViewModel(title: "Expense 9", amount: 8000.00, createdAt: generateRandomDate(daysBack: 9)!),
        ExpenseItemViewModel(title: "Expense 10", amount: 54.99, createdAt: generateRandomDate(daysBack: 10)!),
        ExpenseItemViewModel(title: "Expense 11", amount: 341.23, createdAt: generateRandomDate(daysBack: 11)!),
    ].sorted { $0.createdAt > $1.createdAt }
}
