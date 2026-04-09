//
//  HomeView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: BudgetViewModel
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "INR"
    
    @State private var animateIn = false
    
    private var currencySymbol: String {
        CurrencyOption.allCurrencies.first { $0.code == selectedCurrency }?.symbol ?? "₹"
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<21: return "Good Evening"
        default: return "Good Night"
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                headerRow.padding(.horizontal, 20)
                auroraBalanceCard.padding(.horizontal, 20)
                if !viewModel.bankAccounts.isEmpty { bankCardsCarousel }
                quickStats.padding(.horizontal, 20)
                recentSection.padding(.horizontal, 20)
            }
            .padding(.top, 8)
            .padding(.bottom, 20)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.15)) {
                animateIn = true
            }
        }
    }
    
    private var headerRow: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(Poppins.medium.font(size: 13))
                    .foregroundStyle(.secondary)
                    
                Text("Dashboard")
                    .font(Boska.bold.font(size: 28))
            }
            Spacer()
            HStack(spacing: 5) {
                Image(systemName: "calendar")
                    .font(.system(size: 11))
                Text(Date(), format: .dateTime.day().month(.abbreviated))
                    .font(Poppins.medium.font(size: 12))
            }
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(Capsule().fill(.ultraThinMaterial).overlay(Capsule().stroke(Color.borderLight, lineWidth: 0.5)))
        }
    }
    
    private var auroraBalanceCard: some View {
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("Total Balance")
                    .font(Boska.bold.font(size: 18))
                    .foregroundStyle(.white.opacity(0.7))
                
                Text("\(currencySymbol)\(viewModel.totalBalance, specifier: "%.2f")")
                    .font(Poppins.bold.font(size: 36))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                    .shadow(color: .white.opacity(0.15), radius: 8, y: 0)
            }
            
            HStack(spacing: 10) {
                incomePill
                expensePill
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .auroraCard(
            colors: [
                Color(hex: "#6C5CE7") ?? .purple,
                Color(hex: "#A29BFE") ?? .indigo,
                Color(hex: "#FD79A8") ?? .pink,
                Color(hex: "#00CEC9") ?? .teal,
                Color(hex: "#0984E3") ?? .blue
            ],
            cornerRadius: 24
        )
        .offset(y: animateIn ? 0 : 30)
        .opacity(animateIn ? 1 : 0)
    }
    
    private var incomePill: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color.incomeGreen, Color.incomeGreen.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 32, height: 32)
                Image(systemName: "arrow.down.left")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text("Income").font(.system(size: 10)).foregroundStyle(.white.opacity(0.6))
                Text("\(currencySymbol)\(viewModel.totalIncome, specifier: "%.0f")")
                    .font(.subheadline.weight(.bold)).foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.1), lineWidth: 0.5))
        )
    }
    
    private var expensePill: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color.expenseRed, Color.expenseRed.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 32, height: 32)
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text("Expense").font(.system(size: 10)).foregroundStyle(.white.opacity(0.6))
                Text("\(currencySymbol)\(viewModel.totalExpense, specifier: "%.0f")")
                    .font(.subheadline.weight(.bold)).foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.1), lineWidth: 0.5))
        )
    }
    
    private var bankCardsCarousel: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("My Accounts")
                    .font(Poppins.bold.font(size: 15))
                Spacer()
                Text("\(viewModel.bankAccounts.count)")
                    .font(Poppins.bold.font(size: 12))
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Capsule().fill(LinearGradient(colors: [Color.accent1.opacity(0.2), Color.accent2.opacity(0.15)], startPoint: .leading, endPoint: .trailing)))
                    .foregroundStyle(Color.accent1)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.bankAccounts) { account in
                        FlippableBankCard(account: account, currencySymbol: currencySymbol)
                            .frame(width: 270, height: 170)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
        }
    }
    
    private var quickStats: some View {
        HStack(spacing: 10) {
            statPill(icon: "arrow.triangle.2.circlepath", value: "\(viewModel.transactions.count)", label: "Transactions", colors: [Color.accent1, Color.accent2])
            statPill(icon: "building.columns", value: "\(viewModel.bankAccounts.count)", label: "Accounts", colors: [Color.incomeGreen, .teal])
            statPill(icon: "tag", value: "\(viewModel.categories.count)", label: "Categories", colors: [.orange, Color.expenseRed])
        }
    }
    
    private func statPill(icon: String, value: String, label: String, colors: [Color]) -> some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [colors[0].opacity(0.15), colors[1].opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            Text(value)
                .font(Boska.bold.font(size: 17))
            Text(label)
                .font(Poppins.regular.font(size: 9))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderLight, lineWidth: 0.5))
        )
    }
    
    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Recent Activity")
                    .font(Poppins.bold.font(size: 15))
                
                Spacer()
                if !viewModel.transactions.isEmpty {
                    Text("See All")
                        .font(Poppins.bold.font(size: 12))
                        .foregroundStyle(LinearGradient(colors: [Color.accent1, Color.accent2], startPoint: .leading, endPoint: .trailing))
                        .onTapGesture {
                            NotificationCenter.default.post(name: .init("switchToExpenseTab"), object: nil)
                        }
                }
            }
            
            if viewModel.recentTransactions.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "tray").font(.system(size: 32)).foregroundStyle(.secondary.opacity(0.4))
                    Text("No transactions yet")
                        .font(Poppins.regular.font(size: 12))
                    Text("Tap + to add your first one")
                        .font(Poppins.regular.font(size: 11))
                }
                .frame(maxWidth: .infinity).padding(.vertical, 30)
                .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
            } else {
                VStack(spacing: 1) {
                    ForEach(Array(viewModel.recentTransactions.enumerated()), id: \.element.id) { index, txn in
                        TransactionRow(transaction: txn, categoryName: viewModel.categoryName(for: txn.categoryId), categoryIcon: viewModel.categoryIcon(for: txn.categoryId), categoryColor: viewModel.categoryColor(for: txn.categoryId), currencySymbol: currencySymbol)
                        if index < viewModel.recentTransactions.count - 1 { Divider().padding(.leading, 56) }
                    }
                }
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.borderLight, lineWidth: 0.5))
                )
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(BudgetViewModel())
}
