//
//  ExpensesViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 06/04/21.
//

import UIKit
import MyFinances

public class ExpensesViewController: UITableViewController {
    private var refreshController: ExpensesRefreshViewController?
    private var cellControllers = [ExpenseCellViewController]() {
        didSet { tableView.reloadData() }
    }

    public convenience init(loader: ExpensesLoader) {
        self.init()
        self.refreshController = ExpensesRefreshViewController(loader: loader)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        refreshController?.onRefresh = { [weak self] items in
            self?.cellControllers = items.map { ExpenseCellViewController(model: $0) }
        }

        refreshControl = refreshController?.view
        refreshController?.refresh()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellControllers[indexPath.row].view
    }
}
