//
//  ExpenseCellViewModel.swift
//  MyFinances
//
//  Created by Paulo Sergio da Silva Rodrigues on 14/04/21.
//

import Foundation

public class ExpenseCellViewModel {
    private lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter
    }()

    private let model: ExpenseItem

    public init(model: ExpenseItem) {
        self.model = model
    }

    public var title: String {
        return model.title
    }

    public var amount: String {
        return "R$ " + numberFormatter.string(from: model.amount as NSNumber)!
    }

    public var createdAt: String {
        return dateFormatter.string(from: model.createdAt).replacingOccurrences(of: " ", with: " às ")
    }
}
