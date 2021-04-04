//
//  ExpensesViewController.swift
//  MyFinancesPrototype
//
//  Created by Paulo Sergio da Silva Rodrigues on 22/03/21.
//

import UIKit

class ExpensesViewController: UITableViewController {
    var count: Int = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.tableFooterView = UIView()

        refresh()
    }

    @IBAction func refresh() {
        refreshControl?.beginRefreshing()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.refreshControl?.endRefreshing()
            self?.count = 50
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ExpenseItemCell", for: indexPath)
    }
}
