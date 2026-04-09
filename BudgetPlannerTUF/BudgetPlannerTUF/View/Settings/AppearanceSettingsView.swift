//
//  AppearanceSettingsView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct AppearanceSettingsView: View {
    @EnvironmentObject var viewModel: BudgetViewModel
    @AppStorage("selectedTheme") private var selectedTheme: String = AppTheme.device.rawValue
    private var currentTheme: AppTheme { AppTheme(rawValue: selectedTheme) ?? .device }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                Text("Choose a theme")
                    .font(.subheadline).foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 12) { ForEach(AppTheme.allCases, id: \.self) { themeCard($0) } }
            }.padding(20)
        }
        .navigationTitle("Appearance").navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient(colors: [Color.BG_1, Color.BG_2],
                                   startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
        .onAppear { viewModel.isTabBarHidden = true }
        .onDisappear { viewModel.isTabBarHidden = false }
    }

    @ViewBuilder
    private func themeCard(_ theme: AppTheme) -> some View {
        let sel = currentTheme == theme
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 14).fill(theme.cardBackground).frame(height: 120)
                .overlay {
                    VStack(alignment: .leading, spacing: 7) {
                        Circle().fill(sel ? Color.accent1 : .gray.opacity(0.3)).frame(width: 22, height: 22)
                            .overlay { if sel { Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)).foregroundStyle(.white) } }
                        VStack(alignment: .leading, spacing: 4) {
                            Capsule().fill(theme.fakeLineColor).frame(width: 42, height: 3)
                            Capsule().fill(theme.fakeLineColor).frame(width: 52, height: 3)
                            Capsule().fill(theme.fakeLineColor).frame(width: 32, height: 3)
                        }
                    }.padding(12).frame(maxWidth: .infinity, alignment: .leading)
                }
                .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(sel ? Color.accent1 : Color.borderLight,
                            lineWidth: sel ? 2 : 0.5))
                .shadow(color: sel ? Color.accent1.opacity(0.25) : .clear, radius: 6, y: 3)
            Text(theme.rawValue)
                .font(.caption.weight(sel ? .bold : .medium))
                .foregroundStyle(sel ? .primary : .secondary)
        }
        .frame(maxWidth: .infinity).contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selectedTheme = theme.rawValue
            }
        }
        .scaleEffect(sel ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentTheme)
    }
}

#Preview {
    AppearanceSettingsView()
        .environmentObject(BudgetViewModel())
}
