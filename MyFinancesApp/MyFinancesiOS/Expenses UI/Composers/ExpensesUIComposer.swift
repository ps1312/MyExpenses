//
//  ExpensesUIComposer.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 09/04/21.
//

import Foundation
import MyFinances

public final class ExpensesUIComposer {
    private init() {}

    public static func compose(loader: ExpensesLoader) -> ExpensesViewController {
        let expensesPresenter = ExpensesPresenter(loader: loader)
        let refreshController = ExpensesRefreshViewController(presenter: expensesPresenter)

        let expensesController = ExpensesViewController(refreshController: refreshController)
        expensesPresenter.loadView = WeakRefVirtualProxy(refreshController)
        expensesPresenter.expensesView = ExpensesViewAdapter(controller: expensesController)

        return expensesController
    }
}

class WeakRefVirtualProxy<T: AnyObject>: ExpensesLoadView where T: ExpensesLoadView {
    private weak var object: T?

    init (_ object: T) {
        self.object = object
    }

    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}

class ExpensesViewAdapter: ExpensesView {
    private weak var controller: ExpensesViewController?

    init(controller: ExpensesViewController) {
        self.controller = controller
    }

    func display(expenses: [ExpenseItem]) {
        controller?.cellControllers = expenses.map { model in
            let viewModel = ExpenseCellViewModel(model: model)
            return ExpenseCellViewController(viewModel: viewModel)
        }
    }
}
