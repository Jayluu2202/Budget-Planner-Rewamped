//
//  AddBankAccountView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct AddBankAccountView: View {
    @EnvironmentObject var viewModel: BudgetViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var bankName = ""
    @State private var balance = ""
    @State private var accountNumber = ""
    @State private var ifscCode = ""
    @State private var upiId = ""
    @State private var selectedColor = "#4ECDC4"
    
    private let colorOptions = [
        "#4ECDC4", "#FF6B6B", "#45B7D1", "#96CEB4",
        "#6C5CE7", "#FDA085", "#E17055", "#00B894"
    ]
    
    private var canSave: Bool {
        !name.isEmpty && !bankName.isEmpty && Double(balance) != nil
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                VStack(spacing: 8) {
                    Image(systemName: "building.columns.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                    Text(name.isEmpty ? "Account Name" : name)
                        .font(Boska.medium.font(size: 17))
                        .foregroundStyle(.white)
                    Text(bankName.isEmpty ? "Bank Name" : bankName)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                    Text("₹\(Double(balance) ?? 0, specifier: "%.2f")")
                        .font(Boska.bold.font(size: 22))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 22)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: selectedColor) ?? .blue, (Color(hex: selectedColor) ?? .blue).opacity(0.65)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(.white.opacity(0.2), lineWidth: 0.5)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: (Color(hex: selectedColor) ?? .blue).opacity(0.4), radius: 14, y: 6)
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("REQUIRED")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.accent1)
                        .tracking(0.5)
                    
                    VStack(spacing: 0) {
                        inputRow("Account Name", text: $name, placeholder: "e.g. Savings, Salary")
                        Divider().padding(.leading, 14)
                        inputRow("Bank Name", text: $bankName, placeholder: "e.g. HDFC, SBI")
                        Divider().padding(.leading, 14)
                        inputRow("Balance", text: $balance, placeholder: "₹0.00", keyboard: .decimalPad)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.ultraThinMaterial)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderLight, lineWidth: 0.5))
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("OPTIONAL — shown on card back")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                        .tracking(0.5)
                    
                    VStack(spacing: 0) {
                        inputRow("Account No.", text: $accountNumber, placeholder: "Account number")
                        Divider().padding(.leading, 14)
                        inputRow("IFSC Code", text: $ifscCode, placeholder: "e.g. HDFC0001234")
                        Divider().padding(.leading, 14)
                        inputRow("UPI ID", text: $upiId, placeholder: "e.g. name@upi")
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.ultraThinMaterial)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderLight, lineWidth: 0.5))
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("CARD COLOR")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                        .tracking(0.5)
                    
                    HStack(spacing: 10) {
                        ForEach(colorOptions, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex) ?? .gray)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(.white, lineWidth: selectedColor == hex ? 3 : 0)
                                )
                                .scaleEffect(selectedColor == hex ? 1.1 : 1.0)
                                .animation(.spring(response: 0.3), value: selectedColor)
                                .onTapGesture { selectedColor = hex }
                        }
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.ultraThinMaterial)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderLight, lineWidth: 0.5))
                    )
                }
                
                Button {
                    guard let bal = Double(balance) else { return }
                    viewModel.addBankAccount(
                        name: name, bankName: bankName, balance: bal,
                        colorHex: selectedColor, accountNumber: accountNumber,
                        ifscCode: ifscCode, upiId: upiId
                    )
                    dismiss()
                } label: {
                    Text("Save Account")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(canSave ?
                                      LinearGradient(colors: [Color.accent1, Color.accent2], startPoint: .leading, endPoint: .trailing) :
                                        LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.2)], startPoint: .leading, endPoint: .trailing)
                                )
                                .shadow(color: canSave ? Color.accent1.opacity(0.35) : .clear, radius: 10, y: 4)
                        )
                }
                .disabled(!canSave)
            }
            .padding(20)
        }
        .navigationTitle("Add Account")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            LinearGradient(colors: [Color.BG_1, Color.BG_2], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .onAppear { viewModel.isTabBarHidden = true }
        .onDisappear { viewModel.isTabBarHidden = false }
    }
    
    private func inputRow(_ title: String, text: Binding<String>, placeholder: String, keyboard: UIKeyboardType = .default) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .frame(width: 95, alignment: .leading)
            
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .font(.subheadline)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

#Preview {
    NavigationStack {
        AddBankAccountView()
            .environmentObject(BudgetViewModel())
    }
}
