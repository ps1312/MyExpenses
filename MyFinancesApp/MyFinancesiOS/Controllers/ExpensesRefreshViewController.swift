//
//  ExpensesRefreshViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 08/04/21.
//

import UIKit
import MyFinances

class ExpensesRefreshViewController: NSObject {
    private let viewModel: ExpensesViewModel
    private(set) lazy var view = bind(UIRefreshControl())

    init(viewModel: ExpensesViewModel) {
        self.viewModel = viewModel
    }

    var onRefresh: (([ExpenseItem]) -> Void)?

    @objc func refresh() {
        viewModel.loadExpenses()
    }

    func bind(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onChange = { [weak self] state in
            switch state {
            case .pending:
                view.endRefreshing()

            case .loading:
                view.beginRefreshing()

            case .loaded(let items):
                self?.onRefresh?(items)
            }
        }

        view.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return view
    }
}
