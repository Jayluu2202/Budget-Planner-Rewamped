//
//  BankAccountModel.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 07/04/26.
//

import Foundation

struct BankAccount: Identifiable, Codable {
    var id = UUID()
    var name: String
    var bankName: String
    var balance: Double
    var colorHex: String
    var accountNumber: String = ""
    var ifscCode: String = ""
    var upiId: String = ""
}
