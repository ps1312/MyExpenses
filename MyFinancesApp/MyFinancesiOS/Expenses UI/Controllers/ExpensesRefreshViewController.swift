//
//  ExpensesRefreshViewController.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 08/04/21.
//

import UIKit

class ExpensesRefreshViewController: NSObject {
    var viewModel: ExpensesViewModel? {
        didSet {
            viewModel?.onIsLoadingChange = { [weak self] isLoading in
                isLoading ? self?.view?.beginRefreshing() : self?.view?.endRefreshing()
            }
        }
    }

    @IBOutlet var view: UIRefreshControl?

    @IBAction func refresh() {
        viewModel?.loadExpenses()
    }
}
