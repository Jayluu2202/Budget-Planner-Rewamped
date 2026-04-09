//
//  BudgetPlannerTUFApp.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 06/04/26.
//

import SwiftUI

struct MainTabView: View {
    @AppStorage("startTab") private var startTab: Int = Tab.home.rawValue
    @State private var selectedTab: Tab = .home
    @State private var previousTab: Tab = .home
    @State private var showAddTransaction: Bool = false

    @EnvironmentObject var viewModel: BudgetViewModel

    var body: some View {
        ZStack {
            MeshGradientBackground().ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack {
                    tabContent
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

                if !viewModel.isTabBarHidden {
                    CustomTabBar(
                        selectedTab: $selectedTab,
                        previousTab: $previousTab,
                        isSheetOpen: $showAddTransaction
                    ) {
                        showAddTransaction = true
                        triggerHaptic()
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.isTabBarHidden)
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            let tab = Tab(rawValue: startTab) ?? .home
            selectedTab = tab
            previousTab = tab
        }
        .fullScreenCover(isPresented: $showAddTransaction) {
            AddExpenseView().environmentObject(viewModel)
        }
        .onReceive(NotificationCenter.default.publisher(for: .init("switchToExpenseTab"))) { _ in
            previousTab = selectedTab
            withAnimation(.spring(response: 0.55, dampingFraction: 0.78)) {
                selectedTab = .expense
            }
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        let direction = previousTab.rawValue < selectedTab.rawValue ? 1 : -1

        Group {
            switch selectedTab {
            case .home:     HomeView()    .transition(slide(direction: direction))
            case .expense:  ExpenseView() .transition(slide(direction: direction))
            case .report:   ReportView()  .transition(slide(direction: direction))
            case .settings: SettingsView().transition(slide(direction: direction))
            }
        }
        .id(selectedTab)
    }

    private func slide(direction: Int) -> AnyTransition {
        let x: CGFloat = direction > 0 ? 50 : -50
        return .asymmetric(
            insertion: .opacity
                .combined(with: .offset(x: x))
                .combined(with: .scale(scale: 0.96, anchor: direction > 0 ? .leading : .trailing)),
            removal: .opacity
                .combined(with: .offset(x: -x))
                .combined(with: .scale(scale: 0.96, anchor: direction > 0 ? .trailing : .leading))
        )
    }

    private func triggerHaptic() {
        guard UserDefaults.standard.bool(forKey: "hapticEnabled") else { return }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

struct MeshGradientBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color.BG_1, Color.BG_2],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct CustomTabBar: View {
    @State private var plusBounce: CGFloat = 0
    @Binding var selectedTab: Tab
    @Binding var previousTab: Tab
    @Binding var isSheetOpen: Bool
    var onPlusTapped: () -> Void

    @State private var plusRotation: Double = 0
    @State private var plusScale: CGFloat = 1.0

    @State private var flipAngles: [Tab: Double] = [
        .home: 0, .expense: 0, .report: 0, .settings: 0
    ]

    private let tabs: [(tab: Tab, icon: String, iconFilled: String)] = [
        (.home,     "house",                  "house.fill"),
        (.expense,  "arrow.left.arrow.right", "arrow.left.arrow.right"),
        (.report,   "chart.pie",              "chart.pie.fill"),
        (.settings, "gearshape",              "gearshape.fill")
    ]

    private let barHeight: CGFloat   = 70
    private let plusSize: CGFloat    = 58
    private let plusLift: CGFloat    = 20

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 32)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.borderLight.opacity(0.5), Color.borderLight.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.8
                        )
                )
                .frame(height: barHeight)
                .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 8)
                .padding(.horizontal, 16)

            HStack(spacing: 0) {
                ForEach(Array(tabs.enumerated()), id: \.element.tab) { index, item in
                    if index == 2 {
                        Spacer().frame(width: plusSize + 24)
                    }
                    tabButton(item: item)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 6)
            .frame(height: barHeight)
            
            plusButton
                .offset(y: -(plusLift))
        }
        .frame(height: barHeight + plusLift)
        .padding(.bottom, 8)
        .onChange(of: isSheetOpen) { open in
            if !open {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
                    let current = plusRotation.truncatingRemainder(dividingBy: 360)
                    plusRotation -= current
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    plusRotation = 0
                }
            }
        }
    }

    private func tabButton(item: (tab: Tab, icon: String, iconFilled: String)) -> some View {
        let isSelected = selectedTab == item.tab

        return Button {
            guard selectedTab != item.tab else { return }
            previousTab = selectedTab
            withAnimation(.spring(response: 0.55, dampingFraction: 0.78)) {
                selectedTab = item.tab
            }
            withAnimation(.spring(response: 0.85, dampingFraction: 0.72)) {
                flipAngles[item.tab, default: 0] += 360
            }
            triggerHaptic()
        } label: {
            VStack(spacing: 5) {
                Image(systemName: isSelected ? item.iconFilled : item.icon)
                    .font(.system(size: 19, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(
                        isSelected
                            ? LinearGradient(colors: [Color.accent1, Color.accent2],
                                             startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [Color.secondary.opacity(0.55), Color.secondary.opacity(0.55)],
                                             startPoint: .leading, endPoint: .trailing)
                    )
                    .rotation3DEffect(
                        .degrees(flipAngles[item.tab] ?? 0),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.4
                    )
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.35, dampingFraction: 0.65), value: isSelected)

                Circle()
                    .fill(
                        LinearGradient(colors: [Color.accent1, Color.accent2],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: 4, height: 4)
                    .scaleEffect(isSelected ? 1.0 : 0.01)
                    .opacity(isSelected ? 1.0 : 0.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }

    private var plusButton: some View {
        Button {
            withAnimation(.spring(response: 0.18, dampingFraction: 0.45)) { plusScale = 0.82 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.spring(response: 0.42, dampingFraction: 0.52)) { plusScale = 1.0 }
            }
            withAnimation(.spring(response: 0.42, dampingFraction: 0.62)) {
                plusRotation += 135
            }
            onPlusTapped()
        } label: {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.accent1, Color.accent2],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: plusSize, height: plusSize)
                .shadow(color: Color.accent1.opacity(0.38), radius: 8, x: 0, y: 4)
                .overlay(
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(plusRotation))
                )
        }
        .scaleEffect(plusScale)
        .offset(y: plusBounce)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true)
            ) {
                plusBounce = -4
            }
        }
        .animation(.spring(response: 0.32, dampingFraction: 0.6), value: plusScale)
    }

    private func triggerHaptic() {
        guard UserDefaults.standard.bool(forKey: "hapticEnabled") else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

enum Tab: Int, CaseIterable {
    case home, expense, report, settings

    var label: String {
        switch self {
        case .home:     return "Home"
        case .expense:  return "Activity"
        case .report:   return "Reports"
        case .settings: return "Settings"
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(BudgetViewModel())
}
