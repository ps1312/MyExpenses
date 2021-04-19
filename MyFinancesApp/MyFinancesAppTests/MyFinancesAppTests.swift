//
//  MyFinancesAppTests.swift
//  MyFinancesAppTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 15/04/21.
//

import XCTest
@testable import MyFinancesApp

class MyFinancesAppTests: XCTestCase {

    func test_sceneWillConnectToSession_configuresRootViewController() {
        let window = UIWindow()
        let sut = SceneDelegate()
        sut.window = window

        sut.configureView()

        XCTAssertTrue(sut.window?.rootViewController is UINavigationController)
    }

}
