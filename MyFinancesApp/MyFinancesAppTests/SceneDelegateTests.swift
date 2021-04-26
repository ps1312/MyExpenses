//
//  SceneDelegateTests.swift
//  MyFinancesAppTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 26/04/21.
//

import XCTest
import MyFinancesiOS
@testable import MyFinancesApp

class SceneDelegateTests: XCTestCase {

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

}
