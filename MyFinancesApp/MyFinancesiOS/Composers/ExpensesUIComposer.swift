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
        let refreshController = ExpensesRefreshViewController(loader: loader)

        let expensesController = ExpensesViewController(refreshController: refreshController)

        refreshController.onRefresh = { [weak expensesController] items in
            expensesController?.cellControllers = items.map { ExpenseCellViewController(model: $0) }
        }

        return expensesController
    }
}
