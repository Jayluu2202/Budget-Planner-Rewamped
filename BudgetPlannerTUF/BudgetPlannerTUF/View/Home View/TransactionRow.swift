//
//  TransactionRow.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    let categoryName: String
    let categoryIcon: String
    let categoryColor: String
    let currencySymbol: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(colors: [(Color(hex: categoryColor) ?? .gray).opacity(0.2), (Color(hex: categoryColor) ?? .gray).opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 40, height: 40)
                Image(systemName: categoryIcon).font(.system(size: 16)).foregroundStyle(Color(hex: categoryColor) ?? .gray)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(Poppins.bold.font(size: 15))
                    .lineLimit(1)
                Text(categoryName)
                    .font(Poppins.regular.font(size: 12))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 2) {
                    Image(systemName: transaction.type == .expense ? "arrow.up.right" : "arrow.down.left").font(.system(size: 9, weight: .bold))
                    Text("\(transaction.type == .expense ? "-" : "+")\(currencySymbol)\(transaction.amount, specifier: "%.2f")")
                        .font(Poppins.bold.font(size: 15))
                }
                .foregroundStyle(transaction.type == .expense ? Color.expenseRed : Color.incomeGreen)
                Text(transaction.date, format: .dateTime.day().month(.abbreviated))
                    .font(Poppins.regular.font(size: 10))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 10).padding(.vertical, 8)
    }
}
