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
    var items = [ExpenseItemViewModel]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.tableFooterView = UIView()

        refresh()
    }

    @IBAction func refresh() {
        refreshControl?.beginRefreshing()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.refreshControl?.endRefreshing()
            self?.items = ExpenseItemViewModel.prototypeExpenses
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseItemCell", for: indexPath) as! ExpenseItemViewCell
        cell.title?.text = items[indexPath.row].title

        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true

        cell.createdAt?.text = dateFormatter.string(from: items[indexPath.row].createdAt)

        cell.amount?.text = String(format: "R$ %.2f", items[indexPath.row].amount)
        return cell
    }
}
