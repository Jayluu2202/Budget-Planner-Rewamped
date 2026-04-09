//
//  BudgetViewModel.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 07/04/26.
//

import SwiftUI
import Foundation
import Combine

class BudgetViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var categories: [Category] = []
    @Published var bankAccounts: [BankAccount] = []
    @Published var isTabBarHidden: Bool = false
    
    private let storage = StorageManager()
    
    init() {
        loadAllData()
    }
    
    private func loadAllData() {
        transactions = storage.loadTransactions()
        categories = storage.loadCategories()
        bankAccounts = storage.loadAccounts()
    }
    
    func addTransaction(title: String, amount: Double, type: TransactionType, categoryId: UUID, accountId: UUID, date: Date, note: String) {
        let transaction = Transaction(
            title: title, amount: amount, type: type,
            categoryId: categoryId, accountId: accountId,
            date: date, note: note
        )
        transactions.insert(transaction, at: 0)
        updateBalance(accountId: accountId, amount: amount, type: type)
        storage.saveTransactions(transactions)
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        let reverseType: TransactionType = transaction.type == .expense ? .income : .expense
        updateBalance(accountId: transaction.accountId, amount: transaction.amount, type: reverseType)
        transactions.removeAll { $0.id == transaction.id }
        storage.saveTransactions(transactions)
    }
    
    private func updateBalance(accountId: UUID, amount: Double, type: TransactionType) {
        guard let index = bankAccounts.firstIndex(where: { $0.id == accountId }) else { return }
        if type == .expense {
            bankAccounts[index].balance -= amount
        } else {
            bankAccounts[index].balance += amount
        }
        storage.saveAccounts(bankAccounts)
    }
    
    var totalBalance: Double {
        bankAccounts.reduce(0) { $0 + $1.balance }
    }
    
    var totalIncome: Double {
        let c = Calendar.current.dateComponents([.month, .year], from: Date())
        return monthlyIncome(month: c.month ?? 1, year: c.year ?? 2026)
    }
    
    var totalExpense: Double {
        let c = Calendar.current.dateComponents([.month, .year], from: Date())
        return monthlyExpense(month: c.month ?? 1, year: c.year ?? 2026)
    }
    
    var recentTransactions: [Transaction] {
        Array(transactions.prefix(5))
    }
    
    var recentExpenses: [Transaction] {
        Array(transactions.filter { $0.type == .expense }.prefix(5))
    }
    
    func categoryName(for id: UUID) -> String {
        categories.first(where: { $0.id == id })?.name ?? "Unknown"
    }
    
    func categoryIcon(for id: UUID) -> String {
        categories.first(where: { $0.id == id })?.icon ?? "questionmark"
    }
    
    func categoryColor(for id: UUID) -> String {
        categories.first(where: { $0.id == id })?.colorHex ?? "#888888"
    }
    
    func accountName(for id: UUID) -> String {
        bankAccounts.first(where: { $0.id == id })?.name ?? "Unknown"
    }
    
    private func transactionsForMonth(_ month: Int, year: Int) -> [Transaction] {
        transactions.filter { txn in
            let c = Calendar.current.dateComponents([.month, .year], from: txn.date)
            return c.month == month && c.year == year
        }
    }
    
    func monthlyIncome(month: Int, year: Int) -> Double {
        transactionsForMonth(month, year: year).filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    func monthlyExpense(month: Int, year: Int) -> Double {
        transactionsForMonth(month, year: year).filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    
    func spendingByCategory(month: Int, year: Int) -> [(categoryName: String, colorHex: String, amount: Double)] {
        let expenses = transactionsForMonth(month, year: year).filter { $0.type == .expense }
        let grouped = Dictionary(grouping: expenses) { $0.categoryId }
        return grouped.map { (id, txns) in
            (categoryName: categoryName(for: id), colorHex: categoryColor(for: id), amount: txns.reduce(0) { $0 + $1.amount })
        }.sorted { $0.amount > $1.amount }
    }
    
    func incomeByCategory(month: Int, year: Int) -> [(categoryName: String, colorHex: String, amount: Double)] {
        let incomes = transactionsForMonth(month, year: year).filter { $0.type == .income }
        let grouped = Dictionary(grouping: incomes) { $0.categoryId }
        return grouped.map { (id, txns) in
            (categoryName: categoryName(for: id), colorHex: categoryColor(for: id), amount: txns.reduce(0) { $0 + $1.amount })
        }.sorted { $0.amount > $1.amount }
    }
    
    func addBankAccount(name: String, bankName: String, balance: Double, colorHex: String, accountNumber: String, ifscCode: String, upiId: String) {
        let account = BankAccount(
            name: name, bankName: bankName, balance: balance,
            colorHex: colorHex, accountNumber: accountNumber,
            ifscCode: ifscCode, upiId: upiId
        )
        bankAccounts.append(account)
        storage.saveAccounts(bankAccounts)
    }
    
    func deleteBankAccount(_ account: BankAccount) {
        bankAccounts.removeAll { $0.id == account.id }
        storage.saveAccounts(bankAccounts)
    }
    
    func addCategory(name: String, icon: String, colorHex: String, type: TransactionType) {
        let category = Category(name: name, icon: icon, colorHex: colorHex, type: type)
        categories.append(category)
        storage.saveCategories(categories)
    }
    
    func deleteCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
        storage.saveCategories(categories)
    }
}
