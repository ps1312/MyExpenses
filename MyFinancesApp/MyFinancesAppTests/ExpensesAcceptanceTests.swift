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

    func test_onLaunch_displaysListWithRemoteExpensesWhenUserHasConnection() {
        let expensesController = launch(httpClient: HTTPClientStub.online(response))

        XCTAssertEqual(expensesController.numberOfRenderedExpenseItemViews, 2)
    }

    func test_onLaunch_displaysEmptyListWhenUserHasNoConnection() {
        let expensesController = launch(httpClient: HTTPClientStub.offline)

        XCTAssertEqual(expensesController.numberOfRenderedExpenseItemViews, 0)
    }

    //MARK: - HELPERS

    private func launch(httpClient: HTTPClient) -> ExpensesViewController {
        let sut = SceneDelegate(httpClient: httpClient)
        sut.window = UIWindow()

        sut.configureView()
        let nav = sut.window?.rootViewController as? UINavigationController
        let expensesController = nav?.topViewController as! ExpensesViewController

        return expensesController
    }

    private func response() -> (Data, HTTPURLResponse) {
        return (makeResponseData(), HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }

    private func makeResponseData() -> Data {
        let item1JSON = makeExpenseItemJSON()
        let item2JSON = makeExpenseItemJSON()

        return "{\(item1JSON),\(item2JSON)}".data(using: .utf8)!
    }

    private class HTTPClientStub: HTTPClient {
        private let stub: HTTPClient.Result

        private init(stub: HTTPClient.Result) {
            self.stub = stub
        }

        static var offline: HTTPClient {
            HTTPClientStub(stub: .failure(anyNSError()))
        }

        static func online(_ stub: () -> (Data, HTTPURLResponse)) -> HTTPClient {
            return HTTPClientStub(stub: .success(stub()))
        }

        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            completion(stub)
        }

    }

}
