//
//  ExpenseItemsMapper.swift
//  MyFinances
//
//  Created by Paulo Sergio da Silva Rodrigues on 18/03/21.
//

import Foundation

private struct Root {
    var expenses: [ExpenseItem]

    init(expenses: [ExpenseItem] = []) {
        self.expenses = expenses
    }
}

extension Root: Decodable {
    struct ExpenseKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?
        init?(intValue: Int) { return nil }

        static let title = ExpenseKey(stringValue: "title")!
        static let amount = ExpenseKey(stringValue: "amount")!
        static let created_at = ExpenseKey(stringValue: "created_at")!
    }

    public init(from decoder: Decoder) throws {
        var expenses = [ExpenseItem]()
        let container = try decoder.container(keyedBy: ExpenseKey.self)

        for key in container.allKeys {
            let productContainer = try container.nestedContainer(keyedBy: ExpenseKey.self, forKey: key)
            let title = try productContainer.decode(String.self, forKey: .title)
            let amount = try productContainer.decode(Float.self, forKey: .amount)
            let created_at = try productContainer.decode(Date.self, forKey: .created_at)
            let expense = ExpenseItem(id: UUID(uuidString: key.stringValue)!, title: title, amount: amount, createdAt: created_at)
            expenses.append(expense)
        }

        self.init(expenses: expenses)
    }
}

internal class ExpenseItemsMapper {
    internal static func map(_ response: HTTPURLResponse, _ data: Data) -> RemoteExpensesLoader.Result {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard response.statusCode == 200, let root = try? decoder.decode(Root.self, from: data) else {
            return .failure(.invalidData)
        }

        return .success(root.expenses.sorted(by: {$0.createdAt.timeIntervalSince1970 > $1.createdAt.timeIntervalSince1970}))
    }
}
