//
//  ExpensesRefreshViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 08/04/21.
//

import UIKit

class ExpensesRefreshViewController: NSObject, ExpensesLoadView {
    private let presenter: ExpensesPresenter
    private(set) lazy var view = makeView()

    init(presenter: ExpensesPresenter) {
        self.presenter = presenter
    }

    @objc func refresh() {
        presenter.loadExpenses()
    }

    func display(isLoading: Bool) {
        if isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }

    func makeView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
