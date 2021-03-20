//
//  ExpenseItem.swift
//  MyFinances
//
//  Created by Paulo Sergio da Silva Rodrigues on 17/03/21.
//

import Foundation

public struct ExpenseItem: Equatable {
    public let id: UUID
    public let title: String
    public let amount: Float
    public let createdAt: Date

    public init (id: UUID, title: String, amount: Float, createdAt: Date) {
        self.id = id
        self.title = title
        self.amount = amount
        self.createdAt = createdAt
    }

}
