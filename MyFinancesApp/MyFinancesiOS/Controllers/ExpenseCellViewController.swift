//
//  ExpenseCellViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 08/04/21.
//

import UIKit
import MyFinances

class ExpenseCellViewController {
    private let model: ExpenseItem

    init(model: ExpenseItem) {
        self.model = model
    }

    private(set) lazy var view: UITableViewCell = {
        let cell = ExpenseViewCell()
        let expense = model
        cell.titleLabel.text = expense.title

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        cell.createdAtLabel.text = dateFormatter.string(from: expense.createdAt).replacingOccurrences(of: " ", with: " às ")

        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2

        cell.amountLabel.text = "R$ " + numberFormatter.string(from: expense.amount as NSNumber)!
        return cell
    }()
}
