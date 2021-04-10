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
        let expensesViewModel = ExpensesViewModel(loader: loader)
        let refreshController = ExpensesRefreshViewController(viewModel: expensesViewModel)

        let expensesController = ExpensesViewController(refreshController: refreshController)

        refreshController.onRefresh = adaptExpensesModelsToCellControllers(expensesController: expensesController)

        return expensesController
    }

    private static func adaptExpensesModelsToCellControllers(expensesController: ExpensesViewController) -> (([ExpenseItem]) -> Void) {
        return { [weak expensesController] items in
            expensesController?.cellControllers = items.map { ExpenseCellViewController(model: $0) }
        }
    }
}
