//
//  ExpenseView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

enum TransactionFilter: String, CaseIterable {
    case all = "All"
    case income = "Income"
    case expense = "Expense"
}

struct ExpenseView: View {
    @EnvironmentObject var viewModel: BudgetViewModel
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "INR"
    
    @State private var selectedFilter: TransactionFilter = .all
    @State private var expandedID: UUID?
    @State private var searchText: String = ""
    
    private var currencySymbol: String {
        CurrencyOption.allCurrencies.first { $0.code == selectedCurrency }?.symbol ?? "₹"
    }
    
    private var filteredTransactions: [Transaction] {
        var result = viewModel.transactions
        switch selectedFilter {
        case .income: result = result.filter { $0.type == .income }
        case .expense: result = result.filter { $0.type == .expense }
        case .all: break
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                viewModel.categoryName(for: $0.categoryId).localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }
    
    private var groupedTransactions: [(date: String, transactions: [Transaction])] {
        let grouped = Dictionary(grouping: filteredTransactions) { txn -> String in
            let fmt = DateFormatter()
            fmt.dateFormat = "MMMM d, yyyy"
            return fmt.string(from: txn.date)
        }
        return grouped.map { (date: $0.key, transactions: $0.value) }
            .sorted { f, s in
                guard let d1 = f.transactions.first?.date, let d2 = s.transactions.first?.date else { return false }
                return d1 > d2
            }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Activity")
                            .font(Boska.bold.font(size: 28))
                        Text("\(filteredTransactions.count) transaction\(filteredTransactions.count == 1 ? "" : "s")")
                            .font(Poppins.medium.font(size: 12))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    TextField("Search transactions...", text: $searchText)
                        .font(.subheadline)
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.08), lineWidth: 0.5))
                )
                
                filterTabs
                
                if filteredTransactions.isEmpty {
                    emptyState
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(groupedTransactions, id: \.date) { group in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(group.date)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .padding(.leading, 4)
                                
                                VStack(spacing: 1) {
                                    ForEach(Array(group.transactions.enumerated()), id: \.element.id) { index, txn in
                                        ExpandableTransactionCard(
                                            transaction: txn,
                                            isExpanded: expandedID == txn.id,
                                            categoryName: viewModel.categoryName(for: txn.categoryId),
                                            categoryIcon: viewModel.categoryIcon(for: txn.categoryId),
                                            categoryColor: viewModel.categoryColor(for: txn.categoryId),
                                            accountName: viewModel.accountName(for: txn.accountId),
                                            currencySymbol: currencySymbol,
                                            onTap: {
                                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                                    expandedID = expandedID == txn.id ? nil : txn.id
                                                }
                                            },
                                            onDelete: {
                                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                                    viewModel.deleteTransaction(txn)
                                                    expandedID = nil
                                                }
                                            }
                                        )
                                        if index < group.transactions.count - 1 && expandedID != txn.id {
                                            Divider().padding(.leading, 56)
                                        }
                                    }
                                }
                                .padding(4)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.ultraThinMaterial)
                                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.08), lineWidth: 0.5))
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 20)
        }
    }
    
    private var filterTabs: some View {
        HStack(spacing: 6) {
            ForEach(TransactionFilter.allCases, id: \.self) { filter in
                let isSelected = selectedFilter == filter
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) { selectedFilter = filter }
                } label: {
                    HStack(spacing: 5) {
                        if filter != .all {
                            Circle()
                                .fill(filter == .income ? Color.incomeGreen : Color.expenseRed)
                                .frame(width: 7, height: 7)
                        }
                        Text(filter.rawValue)
                            .font(.subheadline.weight(isSelected ? .bold : .medium))
                    }
                    .foregroundStyle(isSelected ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .background(
                        Capsule()
                            .fill(isSelected ?
                                  AnyShapeStyle(LinearGradient(colors: [Color.accent1, Color.accent2], startPoint: .leading, endPoint: .trailing)) :
                                    AnyShapeStyle(.ultraThinMaterial)
                            )
                    )
                }
            }
            Spacer()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "tray")
                .font(.system(size: 36))
                .foregroundStyle(.secondary.opacity(0.4))
            Text("No transactions found")
                .font(Poppins.medium.font(size: 16))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
        .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
    }
}



#Preview {
    MainTabView()
        .environmentObject(BudgetViewModel())
}
