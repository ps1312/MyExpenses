//
//  ExpensesViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 06/04/21.
//

import UIKit

public class ExpensesViewController: UITableViewController {
    @IBOutlet var refreshController: ExpensesRefreshViewController?
    var cellControllers = [ExpenseCellViewController]() {
        didSet { tableView.reloadData() }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        refreshController?.refresh()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellControllers.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellControllers[indexPath.row].view(in: tableView)
    }
}
