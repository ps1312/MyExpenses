//
//  ExpenseCellViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 08/04/21.
//

import UIKit

class ExpenseCellViewController {
    private let viewModel: ExpenseCellViewModel
    private(set) lazy var view: UITableViewCell = bind(ExpenseViewCell())

    init(viewModel: ExpenseCellViewModel) {
        self.viewModel = viewModel
    }

    func bind(_ cell: ExpenseViewCell) -> ExpenseViewCell {
        cell.titleLabel.text = viewModel.title
        cell.createdAtLabel.text = viewModel.createdAt
        cell.amountLabel.text = viewModel.amount

        return cell
    }
}
