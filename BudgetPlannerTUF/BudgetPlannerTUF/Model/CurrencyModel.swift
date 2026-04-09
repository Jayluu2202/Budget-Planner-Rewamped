//
//  CurrencyModel.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 07/04/26.
//

import Foundation

struct CurrencyOption: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let symbol: String
    let name: String
    
    static let allCurrencies: [CurrencyOption] = [
        .init(code: "INR", symbol: "₹", name: "Indian Rupee"),
        .init(code: "USD", symbol: "$", name: "US Dollar"),
        .init(code: "EUR", symbol: "€", name: "Euro"),
        .init(code: "GBP", symbol: "£", name: "British Pound"),
        .init(code: "JPY", symbol: "¥", name: "Japanese Yen"),
        .init(code: "AED", symbol: "د.إ", name: "UAE Dirham"),
        .init(code: "CAD", symbol: "C$", name: "Canadian Dollar"),
        .init(code: "AUD", symbol: "A$", name: "Australian Dollar"),
        .init(code: "SGD", symbol: "S$", name: "Singapore Dollar"),
        .init(code: "CHF", symbol: "Fr", name: "Swiss Franc"),
    ]
}
