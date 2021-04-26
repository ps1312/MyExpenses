//
//  File.swift
//  MyFinancesAppTests
//
//  Created by Paulo Sergio da Silva Rodrigues on 19/04/21.
//

import Foundation
import MyFinances

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> Error {
    return NSError(domain: "domain", code: 1)
}

func makeExpenseItemJSON(
    id: UUID = UUID(),
    title: String = "A title",
    amount: Double = 39.99,
    createdAt: (date: Date, iso8601String: String) = (
        date: Date(timeIntervalSince1970: 1616266800),
        iso8601String: "2021-03-20T19:00:00+00:00"
    )
) -> String {
    let model = ExpenseItem(id: id, title: title, amount: amount, createdAt: createdAt.date)

    let json = """
        "\(model.id.uuidString)": {
            "title": "\(title)",
            "amount": \(amount),
            "created_at": "\(createdAt.iso8601String)",
        }
    """

    return json
}
