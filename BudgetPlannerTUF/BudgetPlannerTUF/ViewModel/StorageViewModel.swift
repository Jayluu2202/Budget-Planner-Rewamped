//
//  StorageViewModel.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 07/04/26.
//

import Foundation

class StorageManager {
    
    private let transactionsKey = "saved_transactions"
    private let accountsKey = "saved_accounts"
    private let categoriesKey = "saved_categories"
    
    func saveTransactions(_ items: [Transaction]) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: transactionsKey)
        }
    }
    
    func saveAccounts(_ items: [BankAccount]) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: accountsKey)
        }
    }
    
    func saveCategories(_ items: [Category]) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: categoriesKey)
        }
    }
    
    func loadTransactions() -> [Transaction] {
        guard let data = UserDefaults.standard.data(forKey: transactionsKey),
              let items = try? JSONDecoder().decode([Transaction].self, from: data)
        else { return [] }
        return items
    }
    
    func loadAccounts() -> [BankAccount] {
        guard let data = UserDefaults.standard.data(forKey: accountsKey),
              let items = try? JSONDecoder().decode([BankAccount].self, from: data)
        else { return [] }
        return items
    }
    
    func loadCategories() -> [Category] {
        guard let data = UserDefaults.standard.data(forKey: categoriesKey),
              let items = try? JSONDecoder().decode([Category].self, from: data)
        else { return [] }
        return items
    }
}
