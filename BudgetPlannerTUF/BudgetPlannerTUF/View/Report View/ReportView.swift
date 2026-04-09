//
//  ReportView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI
import Charts

enum ChartType: String, CaseIterable {
    case bar = "Bar"
    case pie = "Pie"
    case line = "Line"
    var icon: String {
        switch self {
        case .bar: "chart.bar.fill"
        case .pie: "chart.pie.fill"
        case .line: "chart.xyaxis.line"
        }
    }
}

struct ReportView: View {
    @EnvironmentObject var viewModel: BudgetViewModel
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "INR"
    
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedChartType: ChartType = .bar
    @State private var showingExpenses = true
    
    private let monthNames = Calendar.current.monthSymbols
    private var currencySymbol: String {
        CurrencyOption.allCurrencies.first { $0.code == selectedCurrency }?.symbol ?? "₹"
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                    .padding(.bottom, 16)
                monthPicker
                    .padding(.bottom, 50)
                auroraSummary
                    .padding(.bottom, 64)
                chartTypeSelector
                    .padding(.bottom, 14)
                chartSection
                    .padding(.bottom, 24)
                categoryBreakdown
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 20)
        }
    }
    
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Reports")
                    .font(Boska.bold.font(size: 28))
                Text(monthNames[selectedMonth - 1] + " \(selectedYear)")
                    .font(Poppins.medium.font(size: 12))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Menu {
                ForEach((2024...2030), id: \.self) { y in
                    Button(String(y)) { selectedYear = y }
                }
            } label: {
                HStack(spacing: 3) {
                    Text(String(selectedYear))
                        .font(Poppins.medium.font(size: 14))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 7, weight: .bold))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(.ultraThinMaterial))
            }
            .tint(.primary)
        }
    }
    
    private var monthPicker: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(1...12, id: \.self) { month in
                        let sel = month == selectedMonth
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                selectedMonth = month
                            }
                        } label: {
                            VStack(spacing: 3) {
                                Text(monthNames[month - 1].prefix(3).uppercased())
                                    .font(Poppins.bold.font(size: 12))
                                if sel {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 4, height: 4)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .foregroundStyle(sel ? .white : .secondary)
                            .frame(width: 44, height: 44)
                            .background(
                                Group {
                                    if sel {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(LinearGradient(colors: [Color.accent1, Color.accent2],
                                                                 startPoint: .topLeading,
                                                                 endPoint: .bottomTrailing))
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.ultraThinMaterial)
                                    }
                                }
                            )
                        }
                        .id(month)
                    }
                }
            }
            .onAppear { proxy.scrollTo(selectedMonth, anchor: .center) }
        }
    }
    
    private var auroraSummary: some View {
        let income = viewModel.monthlyIncome(month: selectedMonth, year: selectedYear)
        let expense = viewModel.monthlyExpense(month: selectedMonth, year: selectedYear)
        let net = income - expense
        
        return VStack(spacing: 12) {
            HStack(spacing: 0) {
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.left")
                            .font(.system(size: 10, weight: .bold))
                        Text("Income")
                            .font(Poppins.bold.font(size: 12))
                    }
                    .foregroundStyle(.white.opacity(0.65))
                    
                    Text("\(currencySymbol)\(income, specifier: "%.0f")")
                        .font(Poppins.bold.font(size: 20))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                
                Rectangle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 1, height: 36)
                
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 10, weight: .bold))
                        Text("Expense")
                            .font(Poppins.bold.font(size: 12))
                    }
                    .foregroundStyle(.white.opacity(0.65))
                    
                    Text("\(currencySymbol)\(expense, specifier: "%.0f")")
                        .font(Poppins.bold.font(size: 20))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
            }
            
            HStack {
                Text("Net")
                    .font(Poppins.medium.font(size: 16))
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Text("\(net >= 0 ? "+" : "")\(currencySymbol)\(net, specifier: "%.0f")")
                    .font(Poppins.bold.font(size: 16))
                    .foregroundStyle(net >= 0 ? Color.incomeGreen : Color.expenseRed)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.1)))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .auroraCard(
            colors: [
                Color(hex: "#0984E3") ?? .blue,
                Color(hex: "#6C5CE7") ?? .purple,
                Color(hex: "#00CEC9") ?? .teal,
                Color(hex: "#A29BFE") ?? .indigo
            ],
            cornerRadius: 22
        )
    }
    
    private var chartTypeSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Chart Type")
                .font(Poppins.bold.font(size: 15))
            
            HStack(spacing: 6) {
                ForEach(ChartType.allCases, id: \.self) { ct in
                    let sel = selectedChartType == ct
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selectedChartType = ct
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: ct.icon)
                                .font(Poppins.bold.font(size: 12))
                            Text(ct.rawValue)
                                .font(Poppins.bold.font(size: 12))
                        }
                        .foregroundStyle(sel ? .white : .primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Group {
                                if sel {
                                    Capsule().fill(
                                        LinearGradient(colors: [Color.accent1, Color.accent2],
                                                       startPoint: .leading,
                                                       endPoint: .trailing)
                                    )
                                } else {
                                    Capsule().fill(.ultraThinMaterial)
                                }
                            }
                        )
                    }
                }
                Spacer()
            }
        }
    }
    
    private var chartSection: some View {
        let income = viewModel.monthlyIncome(month: selectedMonth, year: selectedYear)
        let expense = viewModel.monthlyExpense(month: selectedMonth, year: selectedYear)
        
        return Group {
            if income > 0 || expense > 0 {
                VStack(spacing: 10) {
                    switch selectedChartType {
                    case .bar:  barChart(income: income, expense: expense)
                    case .pie:  pieChart
                    case .line: lineChart
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(.white.opacity(0.08), lineWidth: 0.5)
                        )
                )
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.system(size: 36))
                        .foregroundStyle(.secondary.opacity(0.4))
                    Text("No data for this month")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(.white.opacity(0.08), lineWidth: 0.5)
                        )
                )
            }
        }
    }
    
    private func barChart(income: Double, expense: Double) -> some View {
        Chart {
            BarMark(x: .value("Type", "Income"), y: .value("Amount", income))
                .foregroundStyle(
                    LinearGradient(colors: [Color.incomeGreen, Color.incomeGreen.opacity(0.6)],
                                   startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(6)
            BarMark(x: .value("Type", "Expense"), y: .value("Amount", expense))
                .foregroundStyle(
                    LinearGradient(colors: [Color.expenseRed, Color.expenseRed.opacity(0.6)],
                                   startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(6)
        }
        .frame(height: 200)
    }
    
    private var pieChart: some View {
        let data = showingExpenses
            ? viewModel.spendingByCategory(month: selectedMonth, year: selectedYear)
            : viewModel.incomeByCategory(month: selectedMonth, year: selectedYear)
        
        return VStack(spacing: 12) {
            HStack(spacing: 0) {
                ForEach(["Expenses", "Income"], id: \.self) { label in
                    let sel = (label == "Expenses") == showingExpenses
                    Button {
                        withAnimation { showingExpenses = (label == "Expenses") }
                    } label: {
                        Text(label)
                            .font(.caption.weight(sel ? .bold : .regular))
                            .foregroundStyle(sel ? .white : .secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .background(Capsule().fill(sel ? Color.accent1 : .clear))
                    }
                }
            }
            .padding(3)
            .background(Capsule().fill(.ultraThinMaterial))
            
            if data.isEmpty {
                Text("No data")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                Chart(data, id: \.categoryName) {
                    SectorMark(
                        angle: .value("Amount", $0.amount),
                        innerRadius: .ratio(0.55),
                        angularInset: 2
                    )
                    .foregroundStyle(Color(hex: $0.colorHex) ?? .gray)
                    .cornerRadius(4)
                }
                .frame(height: 200)
            }
        }
    }
    
    private var lineChart: some View {
        let daily = dailyData()
        return VStack(alignment: .leading, spacing: 6) {
            Text("Daily Spending")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            
            if daily.isEmpty {
                Text("No data")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                Chart(daily, id: \.day) {
                    LineMark(x: .value("Day", $0.day), y: .value("Amount", $0.amount))
                        .foregroundStyle(Color.accent1)
                        .interpolationMethod(.catmullRom)
                    AreaMark(x: .value("Day", $0.day), y: .value("Amount", $0.amount))
                        .foregroundStyle(
                            LinearGradient(colors: [Color.accent1.opacity(0.3), .clear],
                                           startPoint: .top, endPoint: .bottom)
                        )
                        .interpolationMethod(.catmullRom)
                    PointMark(x: .value("Day", $0.day), y: .value("Amount", $0.amount))
                        .foregroundStyle(Color.accent1)
                        .symbolSize(18)
                }
                .frame(height: 200)
            }
        }
    }
    
    private func dailyData() -> [(day: Int, amount: Double)] {
        let txns = viewModel.transactions.filter {
            let c = Calendar.current.dateComponents([.month, .year], from: $0.date)
            return c.month == selectedMonth && c.year == selectedYear && $0.type == .expense
        }
        let g = Dictionary(grouping: txns) { Calendar.current.component(.day, from: $0.date) }
        return g.map { (day: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.day < $1.day }
    }
    
    private var categoryBreakdown: some View {
        let data = viewModel.spendingByCategory(month: selectedMonth, year: selectedYear)
        let total = viewModel.monthlyExpense(month: selectedMonth, year: selectedYear)
        
        return Group {
            if !data.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Category Breakdown")
                        .font(Poppins.bold.font(size: 14))
                    
                    VStack(spacing: 0) {
                        ForEach(Array(data.enumerated()), id: \.element.categoryName) { index, item in
                            let pct = total > 0 ? (item.amount / total) * 100 : 0
                            
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(Color(hex: item.colorHex) ?? .gray)
                                    .frame(width: 9, height: 9)
                                Text(item.categoryName)
                                    .font(Poppins.medium.font(size: 14))
                                Spacer()
                                Text("\(pct, specifier: "%.0f")%")
                                    .font(Poppins.medium.font(size: 14))
                                    .foregroundStyle(.secondary)
                                Text("\(currencySymbol)\(item.amount, specifier: "%.2f")")
                                    .font(Poppins.bold.font(size: 16))
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            
                            if index < data.count - 1 {
                                Divider()
                                    .padding(.leading, 34)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(.white.opacity(0.08), lineWidth: 0.5)
                            )
                    )
                }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(BudgetViewModel())
}
