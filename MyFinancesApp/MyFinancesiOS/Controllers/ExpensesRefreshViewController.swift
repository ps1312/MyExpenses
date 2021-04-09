//
//  ExpensesRefreshViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 08/04/21.
//

import UIKit
import MyFinances

class ExpensesRefreshViewController: NSObject {
    private let loader: ExpensesLoader

    init(loader: ExpensesLoader) {
        self.loader = loader
    }

    private(set) lazy var view: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()

    var onRefresh: (([ExpenseItem]) -> Void)?

    @objc func refresh() {
        view.beginRefreshing()

        loader.load { [weak self] result in
            switch (result) {
            case .failure:
                break
            case .success(let items):
                self?.onRefresh?(items)
            }

            self?.view.endRefreshing()
        }
    }
}
