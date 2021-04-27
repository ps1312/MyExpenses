//
//  ExpensesSnapshotTests.swift
//  MyFinancesiOSTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 26/04/21.
//

import XCTest
import MyFinancesiOS
import MyFinances

class ExpensesSnapshotTests: XCTestCase {

    func test_emptyExpenses() {
        let sut = makeSUT()

        sut.cellControllers = []

        record(snapshot: sut.snapshot(), named: "EMPTY_EXPENSES")
    }

    func test_withContent() {
        let sut = makeSUT()

        sut.cellControllers = [
            makeExpenseCellController(),
            makeExpenseCellController(),
        ]

        record(snapshot: sut.snapshot(), named: "EXPENSES_WITH_CONTENT")
    }

    private func makeSUT() -> ExpensesViewController {
        let bundle = Bundle(for: ExpensesViewController.self)
        let storyboard = UIStoryboard(name: "Expenses", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ExpensesViewController
        controller.loadViewIfNeeded()
        return controller
    }

    private func makeExpenseCellController() -> ExpenseCellViewController {
        let fixedDate = Date(timeIntervalSince1970: 1609498800)
        let model = ExpenseItem(id: UUID(), title: "any title", amount: 99.99, createdAt: fixedDate)
        let viewModel = ExpenseCellViewModel(model: model)
        return ExpenseCellViewController(viewModel: viewModel)
    }

    private func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to generate PNG representation", file: file, line: line)
            return
        }

        // ../MyFinancesiOSTests/ExpensesSnapshotTests.swift
        let snapshotURL = URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )

            try snapshotData.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }

}

extension UIViewController {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { action in
            view.layer.render(in: action.cgContext)
        }
    }
}
