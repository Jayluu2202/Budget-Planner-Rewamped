//
//  SettingsView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: BudgetViewModel

    @AppStorage("selectedTheme")   private var selectedTheme:   String = AppTheme.device.rawValue
    @AppStorage("hapticEnabled")   private var hapticEnabled:   Bool   = true
    @AppStorage("startTab")        private var startTab:        Int    = Tab.home.rawValue
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "INR"

    @State private var appeared = false

    private var currentTheme:    AppTheme        { AppTheme(rawValue: selectedTheme) ?? .device }
    private var currentCurrency: CurrencyOption  { CurrencyOption.allCurrencies.first { $0.code == selectedCurrency } ?? CurrencyOption.allCurrencies[0] }
    private var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "v\(v) (\(b))"
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    profileHeader
                    quickActions
                    appearanceSection
                    preferencesSection
                    dataSection
                    moreSection
                    versionFooter
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 32)
            }
            .navigationBarHidden(true)
            .background(
                LinearGradient(colors: [Color.BG_1, Color.BG_2], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.8)) { appeared = true }
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color.accent1, Color.accent2],
                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 58, height: 58)
                        .shadow(color: Color.accent1.opacity(0.45), radius: 12, y: 5)
                    Text("\(currentCurrency.symbol)")
                        .font(Poppins.medium.font(size: 27))
                        .foregroundStyle(.white)
                }

                Text("Settings")
                    .font(Boska.bold.font(size: 26))
            }
            .padding(.top, 26)
            .padding(.bottom, 20)

            Rectangle()
                .fill(Color.borderLight)
                .frame(height: 0.5)

            HStack(spacing: 0) {
                statPill(icon: "arrow.left.arrow.right",
                         value: "\(viewModel.transactions.count)",
                         label: "Transactions")
                dividerLine
                statPill(icon: "building.columns",
                         value: "\(viewModel.bankAccounts.count)",
                         label: "Accounts")
                dividerLine
                statPill(icon: "tag",
                         value: "\(viewModel.categories.count)",
                         label: "Categories")
            }
            .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity)
        .auroraCard(
            colors: [
                Color(hex: "#6C5CE7") ?? .purple,
                Color(hex: "#A29BFE") ?? .indigo,
                Color(hex: "#0984E3") ?? .blue,
                Color(hex: "#00CEC9") ?? .teal
            ],
            cornerRadius: 24
        )
        .offset(y: appeared ? 0 : 18)
        .opacity(appeared ? 1 : 0)
    }

    private var dividerLine: some View {
        Rectangle()
            .fill(.white.opacity(0.15))
            .frame(width: 0.5, height: 36)
    }

    private func statPill(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(Poppins.bold.font(size: 11))
                .foregroundStyle(.white.opacity(0.7))
            Text(value)
                .font(Poppins.bold.font(size: 18))
                .foregroundStyle(.white)
            Text(label)
                .font(Poppins.bold.font(size: 9))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }

    private var quickActions: some View {
        HStack(spacing: 10) {
            quickBtn(
                icon: "plus.circle.fill",
                label: "Add Transaction",
                colors: [Color.accent1, Color.accent2],
                dest: AnyView(Text("Use the + button on the tab bar")
                    .navigationTitle("Add Transaction")
                    .background(
                        LinearGradient(
                            colors: [Color.BG_1, Color.BG_2],
                            startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                    )
                )
            )
            quickBtn(
                icon: "building.columns.fill",
                label: "Add Account",
                colors: [.teal, .cyan],
                dest: AnyView(AddBankAccountView().environmentObject(viewModel))
            )
            quickBtn(
                icon: "tag.fill",
                label: "Add Category",
                colors: [.orange, Color.expenseRed],
                dest: AnyView(AddCategoryView().environmentObject(viewModel))
            )
        }
        .offset(y: appeared ? 0 : 14)
        .opacity(appeared ? 1 : 0)
        .animation(.spring(response: 0.55, dampingFraction: 0.8).delay(0.05), value: appeared)
    }

    private func quickBtn(icon: String, label: String, colors: [Color], dest: AnyView) -> some View {
        NavigationLink { dest } label: {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 44, height: 44)
                        .shadow(color: colors[0].opacity(0.35), radius: 7, y: 3)
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                }
                Text(label)
                    .font(Poppins.medium.font(size: 10))
                    .foregroundStyle(currentTheme == .dark ? .black : .white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.borderLight, lineWidth: 0.6))
            )
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack(spacing: 6) {
            Rectangle()
                .fill(LinearGradient(colors: [Color.accent1, Color.accent2],
                                     startPoint: .leading, endPoint: .trailing))
                .frame(width: 3, height: 13)
                .clipShape(Capsule())
            
            Text(title)
                .font(Poppins.bold.font(size: 12))
                .foregroundStyle(.primary.opacity(0.55))
                .tracking(0.4)
        }
        .padding(.leading, 2)
    }

    private func card<Content: View>(delay: Double = 0, @ViewBuilder content: () -> Content) -> some View {
        content()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                    .overlay(RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(Color.borderLight, lineWidth: 0.6))
            )
            .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
            .offset(y: appeared ? 0 : 16)
            .opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.55, dampingFraction: 0.8).delay(delay), value: appeared)
    }

    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("APPEARANCE")
            card(delay: 0.08) {
                navRow(icon: "paintbrush.fill",
                       gradient: [Color(hex: "#9B59B6") ?? .purple, Color(hex: "#E91E8C") ?? .pink],
                       title: "Theme",
                       subtitle: currentTheme.rawValue) { AppearanceSettingsView() }
            }
        }
    }

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("PREFERENCES")
            card(delay: 0.12) {
                VStack(spacing: 0) {
                    navRow(
                        icon: "coloncurrencysign.circle.fill",
                        gradient: [.orange, .yellow],
                        title: "Currency",
                        subtitle: "\(currentCurrency.symbol) \(currentCurrency.code)"
                    ) { CurrencySettingsView() }
                    rowDivider
                    navRow(icon: "house.circle.fill",
                           gradient: [.blue, .cyan],
                           title: "Start Screen",
                           subtitle: (Tab(rawValue: startTab) ?? .home).label) { StartScreenSettingsView() }
                    rowDivider
                    hapticRow
                }
            }
        }
    }

    private var dataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("DATA")
            card(delay: 0.16) {
                VStack(spacing: 0) {
                    navRow(icon: "building.columns.fill",
                           gradient: [.teal, .mint],
                           title: "Bank Accounts",
                           subtitle: "\(viewModel.bankAccounts.count) accounts") {
                        ManageAccountsView().environmentObject(viewModel)
                    }
                    rowDivider
                    navRow(icon: "tag.fill",
                           gradient: [Color.accent1, Color.accent2],
                           title: "Categories",
                           subtitle: "\(viewModel.categories.count) categories") {
                        ManageCategoriesView().environmentObject(viewModel)
                    }
                }
            }
        }
    }

    private var moreSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("MORE")
            card(delay: 0.20) {
                VStack(spacing: 0) {
                    shareRow
                    rowDivider
                    staticRow(icon: "star.fill",
                              gradient: [.yellow, .orange],
                              title: "Rate App",
                              subtitle: "Love it? Leave a review")
                    rowDivider
                    navRow(icon: "arrow.counterclockwise",
                           gradient: [.red, .pink],
                           title: "Reset Data",
                           subtitle: "Clear everything") {
                        ResetDataView().environmentObject(viewModel)
                    }
                }
            }
        }
    }

    private var versionFooter: some View {
        VStack(spacing: 4) {
            Text("BudgetPlanner")
                .font(Poppins.bold.font(size: 12))
                .foregroundStyle(.secondary.opacity(0.7))
            Text(appVersion)
                .font(Poppins.medium.font(size: 10))
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 4)
    }

    private var rowDivider: some View {
        Rectangle()
            .fill(Color.borderLight)
            .frame(height: 0.5)
            .padding(.leading, 54)
    }

    private func navRow<Dest: View>(icon: String, gradient: [Color],title: String, subtitle: String,@ViewBuilder destination: () -> Dest) -> some View {
        NavigationLink { destination() } label: {
            rowContent(
                icon: icon,
                gradient: gradient,
                title: title,
                subtitle: subtitle,
                trailing: Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.tertiary)
            )
        }
        .tint(.primary)
    }

    private func staticRow(icon: String, gradient: [Color], title: String, subtitle: String) -> some View {
        rowContent(icon: icon, gradient: gradient, title: title, subtitle: subtitle,
                    trailing: Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.tertiary)
        )
    }

    private func rowContent<T: View>(icon: String, gradient: [Color],title: String, subtitle: String,trailing: T) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .fill(LinearGradient(colors: gradient,
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)

            Spacer()

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            trailing
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }

    private var hapticRow: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .fill(LinearGradient(colors: [.pink, .purple],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 32, height: 32)
                Image(systemName: "waveform")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
            }
            Text("Haptic Feedback")
                .font(.subheadline.weight(.medium))
            Spacer()
            Toggle("", isOn: $hapticEnabled)
                .labelsHidden()
                .tint(Color.accent1)
                .onChange(of: hapticEnabled) { if hapticEnabled { triggerHaptic() } }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var shareRow: some View {
        ShareLink(
            item: URL(string: "https://apps.apple.com/app/idYOUR_APP_ID")!,
            subject: Text("Check out BudgetPlanner!"),
            message: Text("This app helps me track expenses easily.")
        ) {
            rowContent(
                icon: "square.and.arrow.up",
                gradient: [.blue, .cyan],
                title: "Share App",
                subtitle: "Tell a friend",
                trailing: Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.tertiary)
            )
        }
        .tint(.primary)
    }

    private func triggerHaptic() {
        guard UserDefaults.standard.bool(forKey: "hapticEnabled") else { return }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

#Preview {
    SettingsView()
        .environmentObject(BudgetViewModel())
}
