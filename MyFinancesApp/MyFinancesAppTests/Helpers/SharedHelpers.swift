//
//  File.swift
//  MyFinancesAppTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 19/04/21.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> Error {
    return NSError(domain: "domain", code: 1)
}
