//
//  AddExpenseView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct AddExpenseView: View {
    @EnvironmentObject var viewModel: BudgetViewModel
    @Environment(\.dismiss) private var dismiss
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "INR"
    
    @State private var title = ""
    @State private var amount = ""
    @State private var type: TransactionType = .expense
    @State private var selectedCategoryId: UUID?
    @State private var selectedAccountId: UUID?
    @State private var selectedDate: Date = Date()
    @State private var note = ""
    @State private var showDatePicker = false
    @State private var animateIn = false
    
    private var currencySymbol: String { CurrencyOption.allCurrencies.first { $0.code == selectedCurrency }?.symbol ?? "₹" }
    private var filteredCategories: [Category] { viewModel.categories.filter { $0.type == type } }
    private var canSave: Bool { !title.isEmpty && Double(amount) != nil && Double(amount)! > 0 && selectedCategoryId != nil && selectedAccountId != nil }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.BG_1, Color.BG_2], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            VStack(spacing: 0) {
                topBar
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        auroraAmountCard
                        typePicker
                        fieldCard(title: "Title", icon: "pencil.line") { TextField("e.g. Groceries, Salary bonus", text: $title).font(.subheadline) }
                        fieldCard(title: "Amount", icon: "indianrupeesign") { TextField("\(currencySymbol)0.00", text: $amount).keyboardType(.decimalPad).font(.subheadline) }
                        dateSection
                        categorySection
                        accountSection
                        fieldCard(title: "Note (optional)", icon: "note.text") { TextField("Add a note...", text: $note).font(.subheadline) }
                        saveButton
                    }
                    .padding(.horizontal, 20).padding(.top, 16).padding(.bottom, 40)
                }
            }
        }
        .onAppear { withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) { animateIn = true } }
    }
    
    private var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                ZStack {
                    Circle().fill(.ultraThinMaterial).frame(width: 40, height: 40)
                        .overlay(Circle().stroke(Color.borderLight, lineWidth: 0.5))
                    Image(systemName: "xmark").font(.system(size: 14, weight: .semibold)).foregroundStyle(.primary)
                }
            }
            Spacer()
            VStack(spacing: 2) {
                Text("New Transaction")
                    .font(Boska.medium.font(size: 17))
            }
            Spacer()
            Circle().fill(.clear).frame(width: 40, height: 40)
        }.padding(.horizontal, 20).padding(.vertical, 12)
    }
    
    private var auroraAmountCard: some View {
        let isExpense = type == .expense
        let auroraColors: [Color] = isExpense
            ? [Color(hex: "#E17055") ?? .red, Color(hex: "#D63031") ?? .red, Color(hex: "#FD79A8") ?? .pink, Color(hex: "#6C5CE7") ?? .purple]
            : [Color(hex: "#00B894") ?? .green, Color(hex: "#00CEC9") ?? .teal, Color(hex: "#0984E3") ?? .blue, Color(hex: "#6C5CE7") ?? .purple]
        
        return VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.15))
                    .frame(width: 50, height: 50)
                Image(systemName: isExpense ? "arrow.up.right" : "arrow.down.left")
                    .font(.system(size: 20, weight: .bold)).foregroundStyle(.white)
            }
            
            Text(amount.isEmpty ? "\(currencySymbol)0.00" : "\(currencySymbol)\(amount)")
                .font(Boska.bold.font(size: 30))
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.spring(response: 0.3), value: amount)
                .shadow(color: .white.opacity(0.1), radius: 6, y: 0)
            
            Text(isExpense ? "Expense" : "Income")
                .font(.caption).foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .auroraCard(colors: auroraColors, cornerRadius: 22)
        .scaleEffect(animateIn ? 1 : 0.9)
        .opacity(animateIn ? 1 : 0)
    }
    
    private var typePicker: some View {
        HStack(spacing: 0) {
            typeBtn(.expense, "Expense", "arrow.up.right.circle.fill")
            typeBtn(.income, "Income", "arrow.down.left.circle.fill")
        }
        .padding(3)
        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
    }
    
    private func typeBtn(_ t: TransactionType, _ label: String, _ icon: String) -> some View {
        let sel = type == t
        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) { type = t; selectedCategoryId = nil }
            triggerHaptic()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 14))
                Text(label).font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(sel ? .white : .primary)
            .frame(maxWidth: .infinity).padding(.vertical, 11)
            .background(
                Group {
                    if sel && t == .expense {
                        RoundedRectangle(cornerRadius: 10).fill(LinearGradient(colors: [Color.expenseRed, Color.expenseRed.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                    } else if sel && t == .income {
                        RoundedRectangle(cornerRadius: 10).fill(LinearGradient(colors: [Color.incomeGreen, Color.incomeGreen.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                    } else {
                        RoundedRectangle(cornerRadius: 10).fill(.clear)
                    }
                }
            )
        }
    }
    
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            sectionLabel("Date", icon: "calendar")
            VStack(spacing: 0) {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { showDatePicker.toggle() }
                    triggerHaptic()
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(selectedDate, format: .dateTime.weekday(.wide)).font(.caption).foregroundStyle(.secondary)
                            Text(selectedDate, format: .dateTime.day().month(.wide).year()).font(.subheadline.weight(.semibold))
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            Text(selectedDate, format: .dateTime.hour().minute()).font(.caption.weight(.medium)).foregroundStyle(Color.accent1)
                            Image(systemName: "chevron.down").font(.system(size: 9, weight: .bold)).foregroundStyle(.secondary).rotationEffect(.degrees(showDatePicker ? 180 : 0))
                        }
                    }.tint(.primary)
                }
                if showDatePicker {
                    Divider().padding(.vertical, 8)
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical).tint(Color.accent1)
                        .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
                }
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial).overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderLight, lineWidth: 0.5)))
        }
    }

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 6) {
            sectionLabel("Category", icon: "tag")
            if filteredCategories.isEmpty {
                HStack { Image(systemName: "exclamationmark.triangle").foregroundStyle(.orange); Text("No \(type.rawValue) categories. Add in Settings.").font(.caption).foregroundStyle(.secondary) }
                    .padding(14).frame(maxWidth: .infinity, alignment: .leading).background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                    ForEach(filteredCategories) { cat in
                        let sel = selectedCategoryId == cat.id
                        VStack(spacing: 5) {
                            ZStack {
                                Circle().fill(sel ? (Color(hex: cat.colorHex) ?? .gray) : (Color(hex: cat.colorHex) ?? .gray).opacity(0.15)).frame(width: 42, height: 42)
                                Image(systemName: cat.icon).font(.system(size: 16)).foregroundStyle(sel ? .white : Color(hex: cat.colorHex) ?? .gray)
                            }
                            .overlay(Circle().stroke(sel ? (Color(hex: cat.colorHex) ?? .gray) : .clear, lineWidth: 2).frame(width: 48, height: 48))
                            Text(cat.name).font(.system(size: 9, weight: sel ? .bold : .medium)).lineLimit(1)
                        }
                        .scaleEffect(sel ? 1.05 : 1.0).animation(.spring(response: 0.3, dampingFraction: 0.7), value: sel)
                        .onTapGesture { withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedCategoryId = cat.id }; triggerHaptic() }
                    }
                }
                .padding(12).background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial).overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderLight, lineWidth: 0.5)))
            }
        }
    }
    
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            sectionLabel("Account", icon: "building.columns")
            if viewModel.bankAccounts.isEmpty {
                HStack { Image(systemName: "exclamationmark.triangle").foregroundStyle(.orange); Text("No accounts. Add in Settings.").font(.caption).foregroundStyle(.secondary) }
                    .padding(14).frame(maxWidth: .infinity, alignment: .leading).background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
            } else {
                VStack(spacing: 6) {
                    ForEach(viewModel.bankAccounts) { acc in
                        let sel = selectedAccountId == acc.id
                        HStack(spacing: 10) {
                            ZStack {
                                Circle().fill((Color(hex: acc.colorHex) ?? .gray).opacity(sel ? 1 : 0.2)).frame(width: 38, height: 38)
                                Image(systemName: "building.columns.fill").font(.system(size: 13)).foregroundStyle(sel ? .white : Color(hex: acc.colorHex) ?? .gray)
                            }
                            VStack(alignment: .leading, spacing: 1) { Text(acc.name).font(.subheadline.weight(.medium)); Text(acc.bankName).font(.caption).foregroundStyle(.secondary) }
                            Spacer()
                            Text("\(currencySymbol)\(acc.balance, specifier: "%.0f")").font(.subheadline.weight(.semibold))
                            Image(systemName: sel ? "checkmark.circle.fill" : "circle").foregroundStyle(sel ? Color.accent1 : .secondary).font(.title3)
                        }
                        .padding(10)
                        .background {
                            if sel {
                                RoundedRectangle(cornerRadius: 12).fill(Color.accent1.opacity(0.08))
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.accent1.opacity(0.4), lineWidth: 1.5))
                            } else {
                                RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderLight, lineWidth: 0.5))
                            }
                        }
                        .onTapGesture { withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedAccountId = acc.id }; triggerHaptic() }
                    }
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button { saveTransaction() } label: {
            HStack(spacing: 6) {
                Image(systemName: type == .expense ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill")
                Text("Save Transaction").font(.headline)
            }
            .foregroundStyle(.white).frame(maxWidth: .infinity).padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(canSave ? LinearGradient(colors: [Color.accent1, Color.accent2], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.2)], startPoint: .leading, endPoint: .trailing))
                    .shadow(color: canSave ? Color.accent1.opacity(0.35) : .clear, radius: 10, y: 4)
            )
        }.disabled(!canSave)
    }
    
    private func fieldCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            sectionLabel(title, icon: icon)
            content().padding(14).background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial).overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderLight, lineWidth: 0.5)))
        }
    }
    
    private func sectionLabel(_ title: String, icon: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 11)).foregroundStyle(Color.accent1)
            Text(title).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
        }
    }
    
    private func saveTransaction() {
        guard let amt = Double(amount), let catId = selectedCategoryId, let accId = selectedAccountId else { return }
        viewModel.addTransaction(title: title, amount: amt, type: type, categoryId: catId, accountId: accId, date: selectedDate, note: note)
        dismiss()
    }
    
    private func triggerHaptic() {
        let enabled = UserDefaults.standard.bool(forKey: "hapticEnabled")
        guard enabled else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

#Preview { AddExpenseView().environmentObject(BudgetViewModel()) }
