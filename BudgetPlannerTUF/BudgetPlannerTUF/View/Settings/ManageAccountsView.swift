//
//  ManageAccountsView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct ManageAccountsView: View {
    @EnvironmentObject var viewModel: BudgetViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                if viewModel.bankAccounts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "building.columns").font(.system(size: 36)).foregroundStyle(.secondary.opacity(0.4))
                        Text("No bank accounts yet").font(.subheadline).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 40)
                    .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
                } else {
                    ForEach(viewModel.bankAccounts) { acc in
                        HStack(spacing: 12) {
                            Circle().fill(Color(hex: acc.colorHex) ?? .gray).frame(width: 42, height: 42)
                                .overlay { Image(systemName: "building.columns.fill").font(.system(size: 15)).foregroundStyle(.white) }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(acc.name).font(.subheadline.weight(.semibold))
                                Text(acc.bankName).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("₹\(acc.balance, specifier: "%.0f")").font(.subheadline.weight(.bold))
                            Button { withAnimation { viewModel.deleteBankAccount(acc) } } label: {
                                Image(systemName: "trash.circle.fill").font(.title3).foregroundStyle(.red.opacity(0.6))
                            }
                        }
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderLight, lineWidth: 0.5)))
                    }
                }
                NavigationLink { AddBankAccountView().environmentObject(viewModel) } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "plus.circle.fill").font(.subheadline)
                        Text("Add Bank Account").font(.subheadline.weight(.semibold))
                    }
                    .foregroundStyle(Color.accent1).frame(maxWidth: .infinity).padding(.vertical, 13)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.accent1.opacity(0.35),
                                style: StrokeStyle(lineWidth: 1.5, dash: [7, 4])))
                }
            }.padding(20)
        }
        .navigationTitle("Bank Accounts").navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient(colors: [Color.BG_1, Color.BG_2],
                                   startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
        .onAppear { viewModel.isTabBarHidden = true }
        .onDisappear { viewModel.isTabBarHidden = false }
    }
}

#Preview {
    ManageAccountsView()
        .environmentObject(BudgetViewModel())
}
