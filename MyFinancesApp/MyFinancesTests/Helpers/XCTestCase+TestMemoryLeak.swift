//
//  XCTestCase+TestMemoryLeak.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 21/03/21.
//

import XCTest

extension XCTestCase {
    func testMemoryLeak(_ instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Expect sut to be deallocated. Possible memory leak.", file: file, line: line)
        }
    }
}
