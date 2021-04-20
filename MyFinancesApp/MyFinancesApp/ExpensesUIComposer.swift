//
//  ExpensesUIComposer.swift
//  MyFinancesiOS
//
//  Created by Paulo Sergio da Silva Rodrigues on 09/04/21.
//

import Foundation
import MyFinances
import MyFinancesiOS
import UIKit

public final class ExpensesUIComposer {
    private init() {}

    public static func compose(loader: ExpensesLoader) -> ExpensesViewController {
        let expensesController = makeController()

        let expensesViewModel = ExpensesViewModel(loader: MainThreadDispatchQueue(decoratee: loader))
        expensesController.viewModel = expensesViewModel
        expensesViewModel.onExpensesLoad = adaptExpensesModelsToCellControllers(expensesController: expensesController)

        return expensesController
    }

    private static func makeController() -> ExpensesViewController {
        let bundle = Bundle(for: ExpensesViewController.self)
        let storyboard = UIStoryboard(name: "Expenses", bundle: bundle)
        return storyboard.instantiateInitialViewController() as! ExpensesViewController
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

class MainThreadDispatchQueue: ExpensesLoader {
    private let decoratee: ExpensesLoader

    init (decoratee: ExpensesLoader) {
        self.decoratee = decoratee
    }

    func load(completion: @escaping (LoadExpensesResult) -> Void) {
        decoratee.load { result in
            if Thread.isMainThread {
                completion(result)
            } else {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}
