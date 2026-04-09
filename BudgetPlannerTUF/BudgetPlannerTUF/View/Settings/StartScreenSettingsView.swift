//
//  StartScreenSettingsView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct StartScreenSettingsView: View {
    @EnvironmentObject var viewModel: BudgetViewModel
    @AppStorage("startTab") private var startTab: Int = Tab.home.rawValue
    private func ico(_ t: Tab) -> String {
        switch t {
        case .home: "house.fill"; case .expense: "arrow.left.arrow.right"
        case .report: "chart.pie.fill"; case .settings: "gearshape.fill"
        }
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 2) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    let sel = startTab == tab.rawValue
                    Button { withAnimation { startTab = tab.rawValue } } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(sel ? Color.accent1.opacity(0.15) : .gray.opacity(0.08))
                                    .frame(width: 36, height: 36)
                                Image(systemName: ico(tab)).font(.system(size: 16))
                                    .foregroundStyle(sel ? Color.accent1 : .secondary)
                            }
                            Text(tab.label).font(.subheadline.weight(.medium))
                            Spacer()
                            if sel { Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.accent1).font(.title3) }
                        }.padding(14)
                    }.tint(.primary)
                    if tab != Tab.allCases.last { Divider().padding(.leading, 60) }
                }
            }
            .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
            .padding(20)
        }
        .navigationTitle("Start Screen").navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient(colors: [Color.BG_1, Color.BG_2],
                                   startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
        .onAppear { viewModel.isTabBarHidden = true }
        .onDisappear { viewModel.isTabBarHidden = false }
    }
}

#Preview {
    StartScreenSettingsView()
        .environmentObject(BudgetViewModel())
}
