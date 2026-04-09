//
//  TransactionModel.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 07/04/26.
//

import Foundation

struct Transaction: Identifiable, Codable {
    var id = UUID()
    var title: String
    var amount: Double
    var type: TransactionType
    var categoryId: UUID
    var accountId: UUID
    var date: Date
    var note: String
}

enum TransactionType: String, Codable, CaseIterable {
    case income, expense
}
