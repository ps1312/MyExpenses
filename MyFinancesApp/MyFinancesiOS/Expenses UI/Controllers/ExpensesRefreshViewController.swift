//
//  ExpensesRefreshViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 08/04/21.
//

import UIKit

class ExpensesRefreshViewController: NSObject {
    private let viewModel: ExpensesViewModel
    private(set) lazy var view = bind(UIRefreshControl())

    init(viewModel: ExpensesViewModel) {
        self.viewModel = viewModel
    }

    @objc func refresh() {
        viewModel.loadExpenses()
    }

    func bind(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onIsLoadingChange = { isLoading in
            isLoading ? view.beginRefreshing() : view.endRefreshing()
        }

        view.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return view
    }
}
