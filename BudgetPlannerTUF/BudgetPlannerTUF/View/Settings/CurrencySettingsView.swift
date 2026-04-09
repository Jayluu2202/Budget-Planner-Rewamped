//
//  CurrencySettingsView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct CurrencySettingsView: View {
    @EnvironmentObject var viewModel: BudgetViewModel
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "INR"
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 2) {
                ForEach(CurrencyOption.allCurrencies) { c in
                    let sel = c.code == selectedCurrency
                    Button { withAnimation { selectedCurrency = c.code } } label: {
                        HStack(spacing: 12) {
                            Text(c.symbol).font(.title2.weight(.semibold)).frame(width: 40)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(c.code).font(.subheadline.weight(.semibold))
                                Text(c.name).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            if sel { Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.accent1).font(.title3) }
                        }.padding(14)
                    }.tint(.primary)
                    if c.code != CurrencyOption.allCurrencies.last?.code { Divider().padding(.leading, 64) }
                }
            }
            .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
            .padding(20)
        }
        .navigationTitle("Currency").navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient(colors: [Color.BG_1, Color.BG_2],
                                   startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
        .onAppear { viewModel.isTabBarHidden = true }
        .onDisappear { viewModel.isTabBarHidden = false }
    }
}

#Preview{
    CurrencySettingsView()
        .environmentObject(BudgetViewModel())
}
