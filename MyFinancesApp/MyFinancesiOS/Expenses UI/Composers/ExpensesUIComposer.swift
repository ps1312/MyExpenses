//
//  ExpensesUIComposer.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 09/04/21.
//

import Foundation
import MyFinances
import UIKit

public final class ExpensesUIComposer {
    private init() {}

    public static func compose(loader: ExpensesLoader) -> ExpensesViewController {
        let expensesViewModel = ExpensesViewModel(loader: loader)

        let bundle = Bundle(for: ExpensesViewController.self)
        let storyboard = UIStoryboard(name: "Expenses", bundle: bundle)
        let expensesController = storyboard.instantiateInitialViewController() as! ExpensesViewController

        let refreshController = expensesController.refreshController
        refreshController?.viewModel = expensesViewModel

        expensesViewModel.onExpensesLoad = adaptExpensesModelsToCellControllers(expensesController: expensesController)

        return expensesController
    }

    private static func adaptExpensesModelsToCellControllers(expensesController: ExpensesViewController) -> (([ExpenseItem]) -> Void) {
        return { [weak expensesController] items in
            expensesController?.cellControllers = items.map { model in
                let viewModel = ExpenseCellViewModel(model: model)
                return ExpenseCellViewController(viewModel: viewModel)
            }
        }
    }
}
