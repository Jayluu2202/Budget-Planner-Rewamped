//
//  CategoryModel.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 07/04/26.
//

import Foundation

struct Category: Identifiable, Codable {
    var id = UUID()
    var name: String
    var icon: String
    var colorHex: String
    var type: TransactionType
}
