//
//  XCTestCase+TestMemoryLeak.swift
//  MyFinancesAppTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 19/04/21.
//

import XCTest

extension XCTestCase {
    func testMemoryLeak(_ instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Expect sut to be deallocated. Possible memory leak.", file: file, line: line)
        }
    }
}
