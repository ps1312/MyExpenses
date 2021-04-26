//
//  MyFinancesAppTests.swift
//  MyFinancesAppTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 15/04/21.
//

import XCTest
import MyFinances
import MyFinancesiOS
@testable import MyFinancesApp

class MyFinancesAppTests: XCTestCase {

    func test_sceneWillConnectToSession_configuresRootViewController() {
        let window = UIWindow()
        let sut = SceneDelegate()
        sut.window = window

        sut.configureView()

        let root = sut.window?.rootViewController
        let navigationController = root as? UINavigationController
        let topViewController = navigationController?.topViewController

        XCTAssertNotNil(navigationController, "Expected a navigation controller root, got \(String(describing: root))")
        XCTAssertTrue(topViewController is ExpensesViewController, "Expected top view controller to be of type ExpensesViewController, got \(String(describing: topViewController))")
    }

    func test_onLaunch_displaysListWithRemoteExpensesWhenUserHasConnection() {
        let httpClient = HTTPClientStub()
        let sut = SceneDelegate(httpClient: httpClient)
        sut.window = UIWindow()

        sut.configureView()
        let nav = sut.window?.rootViewController as? UINavigationController
        let expensesController = nav?.topViewController as! ExpensesViewController

        XCTAssertEqual(expensesController.numberOfRenderedExpenseItemViews, 2)
    }

    func test_onLaunch_displaysEmptyListWhenUserHasNoConnection() {
        let httpClient = HTTPClientOfflineStub()
        let sut = SceneDelegate(httpClient: httpClient)
        sut.window = UIWindow()

        sut.configureView()
        let nav = sut.window?.rootViewController as? UINavigationController
        let expensesController = nav?.topViewController as! ExpensesViewController

        XCTAssertEqual(expensesController.numberOfRenderedExpenseItemViews, 0)
    }

    class HTTPClientOfflineStub: HTTPClient {

        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            completion(.failure(anyNSError()))
        }

    }

    class HTTPClientStub: HTTPClient {
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {

            let (_, item1JSON) = makeExpenseItem(
                id: UUID(),
                title: "a title",
                amount: 35.99,
                createdAt: (date: Date(timeIntervalSince1970: 1616266800), iso8601String: "2021-03-20T19:00:00+00:00")
            )

            let (_, item2JSON) = makeExpenseItem(
                id: UUID(),
                title: "second title",
                amount: 0.99,
                createdAt: (date: Date(timeIntervalSince1970: 1616112660), iso8601String: "2021-03-19T00:11:00+00:00")
            )

            let json = """
            {
                \(item1JSON),
                \(item2JSON)
            }
            """.data(using: .utf8)!

            let response = (json, HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!)

            completion(.success(response))
        }

        func makeExpenseItem(id: UUID, title: String, amount: Double, createdAt: (date: Date, iso8601String: String)) -> (ExpenseItem, String) {
            let model = ExpenseItem(id: id, title: title, amount: amount, createdAt: createdAt.date)

            let json = """
                "\(model.id.uuidString)": {
                    "title": "\(title)",
                    "amount": \(amount),
                    "created_at": "\(createdAt.iso8601String)",
                }
            """

            return (model, json)
        }
    }
}
