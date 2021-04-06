//
//  ExpensesViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 06/04/21.
//

import UIKit
import MyFinances

public class ExpensesViewController: UITableViewController {
    private var loader: ExpensesLoader?

    public convenience init(loader: ExpensesLoader) {
        self.init()
        self.loader = loader

    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        refresh()
    }

    @objc func refresh() {
        refreshControl?.beginRefreshing()

        loader?.load { [weak self] result in
            switch (result) {
            case .failure:
                self?.tableView.backgroundView = UIView()
            case .success:
                break
            }
            self?.refreshControl?.endRefreshing()

        }
    }
}
