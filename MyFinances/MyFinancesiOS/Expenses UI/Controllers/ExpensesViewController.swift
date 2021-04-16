//
//  ExpensesViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 06/04/21.
//

import UIKit
import MyFinances

public class ExpensesViewController: UITableViewController {
    var cellControllers = [ExpenseCellViewController]() {
        didSet { tableView.reloadData() }
    }

    var viewModel: ExpensesViewModel?

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = ExpensesViewModel.title

        viewModel?.onIsLoadingChange = { [weak self] isLoading in
            isLoading ? self?.refreshControl?.beginRefreshing() : self?.refreshControl?.endRefreshing()
        }

        refresh()
    }

    @IBAction func refresh() {
        viewModel?.loadExpenses()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellControllers[indexPath.row].view(in: tableView)
    }
}
