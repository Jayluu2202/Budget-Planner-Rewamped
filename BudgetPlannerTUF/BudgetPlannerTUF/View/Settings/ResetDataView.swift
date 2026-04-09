//
//  ResetDataView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct ResetDataView: View {
    @EnvironmentObject var viewModel: BudgetViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showConfirm = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundStyle(LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .bottom))
            Text("Reset All Data").font(.title2.weight(.bold))
            Text("This will permanently delete all your transactions, bank accounts, and categories.")
                .font(.subheadline).foregroundStyle(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal, 30)
            Spacer()
            Button { showConfirm = true } label: {
                Text("Reset All Data").font(.headline).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 15)
                    .background(RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(colors: [.red, .orange.opacity(0.8)],
                                             startPoint: .leading, endPoint: .trailing)))
            }
            .padding(.horizontal, 20).padding(.bottom, 30)
        }
        .navigationTitle("Reset Data").navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient(colors: [Color.BG_1, Color.BG_2],
                                   startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
        .onAppear { viewModel.isTabBarHidden = true }
        .onDisappear { viewModel.isTabBarHidden = false }
        .alert("Are you sure?", isPresented: $showConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete Everything", role: .destructive) {
                viewModel.transactions.forEach { viewModel.deleteTransaction($0) }
                viewModel.bankAccounts.forEach { viewModel.deleteBankAccount($0) }
                viewModel.categories.forEach { viewModel.deleteCategory($0) }
                dismiss()
            }
        } message: { Text("All data will be permanently deleted.") }
    }
}

#Preview {
    ResetDataView()
        .environmentObject(BudgetViewModel())
}
