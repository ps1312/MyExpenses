//
//  ExpenseCellViewModel.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 10/04/21.
//

import Foundation
import MyFinances

class ExpenseCellViewModel {
    private let model: ExpenseItem

    init(model: ExpenseItem) {
        self.model = model
    }

    var title: String {
        return model.title
    }

    var createdAt: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: model.createdAt).replacingOccurrences(of: " ", with: " às ")
    }

    var amount: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2

        return "R$ " + numberFormatter.string(from: model.amount as NSNumber)!
    }
}
