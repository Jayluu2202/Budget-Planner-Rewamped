//
//  ExpandableTransactionCard.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct ExpandableTransactionCard: View {
    let transaction: Transaction
    let isExpanded: Bool
    let categoryName: String
    let categoryIcon: String
    let categoryColor: String
    let accountName: String
    let currencySymbol: String
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var showDeleteConfirm = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerRow
                .contentShape(Rectangle())
                .onTapGesture(perform: onTap)
            
            if isExpanded {
                expandedContent
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isExpanded ? Color.cardBG.opacity(0.3) : .clear)
        )
        .alert("Delete Transaction", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive, action: onDelete)
        } message: {
            Text("Are you sure you want to delete \"\(transaction.title)\"?")
        }
    }
    
    private var headerRow: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill((Color(hex: categoryColor) ?? .gray).opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: categoryIcon)
                    .font(.system(size: 16))
                    .foregroundStyle(Color(hex: categoryColor) ?? .gray)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(Poppins.medium.font(size: 14))
                    .lineLimit(1)
                Text(categoryName)
                    .font(Poppins.regular.font(size: 12))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 2) {
                Image(systemName: transaction.type == .expense ? "arrow.up.right" : "arrow.down.left")
                    .font(.system(size: 9, weight: .bold))
                Text("\(transaction.type == .expense ? "-" : "+")\(currencySymbol)\(transaction.amount, specifier: "%.2f")")
                    .font(Poppins.bold.font(size: 16))
            }
            .foregroundStyle(transaction.type == .expense ? Color.expenseRed : Color.incomeGreen)
            
            Image(systemName: "chevron.down")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.tertiary)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
    
    private var expandedContent: some View {
        VStack(spacing: 0) {
            Divider().padding(.horizontal, 10)
            
            VStack(spacing: 10) {
                expandedRow(icon: "calendar", label: "Date", value: transaction.date.formatted(date: .abbreviated, time: .shortened))
                expandedRow(icon: "building.columns", label: "Account", value: accountName)
                expandedRow(icon: transaction.type == .expense ? "arrow.up.right.circle" : "arrow.down.left.circle", label: "Type", value: transaction.type.rawValue.capitalized)
                if !transaction.note.isEmpty {
                    expandedRow(icon: "note.text", label: "Note", value: transaction.note)
                }
                
                Button {
                    showDeleteConfirm = true
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "trash").font(.caption)
                        Text("Delete").font(.caption.weight(.medium))
                    }
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.red.opacity(0.08)))
                }
                .buttonStyle(.plain)
            }
            .padding(12)
        }
    }
    
    private func expandedRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .frame(width: 18)
            Text(label)
                .font(Poppins.medium.font(size: 12))
                .foregroundStyle(.secondary)
                .frame(width: 55, alignment: .leading)
            Text(value)
                .font(Poppins.medium.font(size: 12))
            Spacer()
        }
    }
}
