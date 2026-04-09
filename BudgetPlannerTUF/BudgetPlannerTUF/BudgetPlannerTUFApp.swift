//
//  BudgetPlannerTUFApp.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 06/04/26.
//

import SwiftUI

@main
struct BudgetPlannerTUFApp: App {
    @AppStorage("selectedTheme") private var selectedTheme: String = AppTheme.device.rawValue
    @StateObject private var viewModel = BudgetViewModel()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(
                    AppTheme(rawValue: selectedTheme)?.colorScheme
                )
                .environmentObject(viewModel)
                .onAppear {
                    for family in UIFont.familyNames.sorted() {
                        print("━━ \(family)")
                        for name in UIFont.fontNames(forFamilyName: family).sorted() {
                            print("   → \(name)")
                        }
                    }
                }
        }
    }
}
