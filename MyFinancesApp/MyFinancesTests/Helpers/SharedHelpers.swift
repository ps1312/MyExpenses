//
//  SharedHelpers.swift
//  MyFinancesTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 21/03/21.
//

import Foundation
import MyFinances

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> Error {
    return NSError(domain: "domain", code: 1)
}

public class LoaderSpy: ExpensesLoader {
    var completions = [((LoadExpensesResult) -> Void)]()
    var callsCount: Int {
        return completions.count
    }

    public func load(completion: @escaping (LoadExpensesResult) -> Void) {
        completions.append(completion)
    }

    func completeWith(error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }

    func completeWith(items: [ExpenseItem], at index: Int = 0) {
        completions[index](.success(items))
    }
}
