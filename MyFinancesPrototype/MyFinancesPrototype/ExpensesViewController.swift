//
//  ExpensesViewController.swift
//  MyFinancesPrototype
//
//  Created by Paulo Sergio da Silva Rodrigues on 22/03/21.
//

import UIKit

struct ExpenseItemViewModel {
    let title: String
    let amount: Float
    let createdAt: Date
}

class ExpensesViewController: UITableViewController {
    var retryButton: UIView? {
        let container = UIView()

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Could not load expenses"

        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("Retry loading", for: .normal)
        button.addTarget(self, action: #selector(refresh), for: .touchUpInside)

        let stackView = UIStackView(frame: CGRect(x: view.bounds.width / 2 - 100, y: view.bounds.height / 2, width: 200, height: 60))
        stackView.axis = .vertical
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)

        container.addSubview(stackView)
        return container
    }

    var items = [ExpenseItemViewModel]()
    var error: Bool = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.tableFooterView = UIView()

        refresh()
    }

    @IBAction @objc func refresh() {
        tableView.backgroundView = nil
        refreshControl?.beginRefreshing()
        tableView.reloadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            if self!.error {
                self?.error = false
                self?.tableView.backgroundView = self?.retryButton
            } else {
                self?.items = ExpenseItemViewModel.prototypeExpenses
                self?.tableView.reloadData()
            }

            self?.refreshControl?.endRefreshing()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseItemCell", for: indexPath) as! ExpenseItemViewCell
        cell.title?.text = items[indexPath.row].title

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        cell.createdAt?.text = dateFormatter.string(from: items[indexPath.row].createdAt).replacingOccurrences(of: " ", with: " às ")

        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2

        cell.amount?.text = "R$ " + numberFormatter.string(from: items[indexPath.row].amount as NSNumber)!
        return cell
    }
}
