//
//  ExpenseItemsMapper.swift
//  MyFinances
//
//  Created by Paulo Sergio da Silva Rodrigues on 18/03/21.
//

import Foundation

internal class ExpenseItemsMapper {
    private struct Root: Decodable {
        private struct ApiExpense: Decodable {
            let id: UUID
            let title: String
            let amount: Float
            let created_at: Date
        }

        private var items: [ApiExpense]

        var expenses: [ExpenseItem] {
            return items.map { ExpenseItem(id: $0.id, title: $0.title, amount: $0.amount, createdAt: $0.created_at) }
        }
    }

    internal static func map(_ response: HTTPURLResponse, _ data: Data) -> RemoteExpensesLoader.Result {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard response.statusCode == 200, let root = try? decoder.decode(Root.self, from: data) else {
            return .failure(.invalidData)
        }

        return .success(root.expenses)
    }
}
