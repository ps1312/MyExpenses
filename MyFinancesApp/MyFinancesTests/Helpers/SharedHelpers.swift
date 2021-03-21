//
//  SharedHelpers.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 21/03/21.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> Error {
    return NSError(domain: "domain", code: 1)
}
