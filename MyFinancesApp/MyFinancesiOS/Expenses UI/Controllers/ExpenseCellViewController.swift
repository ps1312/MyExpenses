//
//  ExpenseCellViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 08/04/21.
//

import UIKit

class ExpenseCellViewController {
    private let viewModel: ExpenseCellViewModel

    init(viewModel: ExpenseCellViewModel) {
        self.viewModel = viewModel
    }

    func view(in tableView: UITableView) -> ExpenseViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseItemCell") as! ExpenseViewCell

        cell.titleLabel.text = viewModel.title
        cell.createdAtLabel.text = viewModel.createdAt
        cell.amountLabel.text = viewModel.amount

        return cell
    }
}
