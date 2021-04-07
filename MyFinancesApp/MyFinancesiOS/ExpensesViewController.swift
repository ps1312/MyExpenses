//
//  ExpensesViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 06/04/21.
//

import UIKit
import MyFinances

public class ExpenseViewCell: UITableViewCell {
    public let titleLabel: UILabel = UILabel()
    public let amountLabel: UILabel = UILabel()
    public let createdAtLabel: UILabel = UILabel()
}

public class ErrorView: UIView {
    public let retryButton: UIButton = UIButton()
}

public class ExpensesViewController: UITableViewController {
    private var expenses = [ExpenseItem]()
    private var loader: ExpensesLoader?
    private var errorView: ErrorView = ErrorView()

    public convenience init(loader: ExpensesLoader) {
        self.init()
        self.loader = loader
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        errorView.retryButton.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)

        refresh()
    }

    @objc func refresh() {
        refreshControl?.beginRefreshing()

        loader?.load { [weak self] result in
            switch (result) {
            case .failure:
                self?.tableView.backgroundView = self?.errorView
            case .success(let items):
                self?.expenses = items
            }
            self?.refreshControl?.endRefreshing()

        }
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExpenseViewCell()
        let expense = expenses[indexPath.row]
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
    }
}
