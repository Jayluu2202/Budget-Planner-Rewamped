//
//  SettingsEnums.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 07/04/26.
//

import Foundation
import SwiftUI

enum AppTheme: String, CaseIterable {
    case device = "Device"
    case light = "Light"
    case dark = "Dark"
    
    var selectedIcon: String {
        switch self {
        case .device: return "DeviceModeSelected"
        case .light: return "LightModeSelected"
        case .dark: return "NightModeSelected"
        }
    }
    
    var unselectedIcon: String {
        switch self {
        case .device: return "DeviceModeUnselected"
        case .light: return "LightModeUnselcted"
        case .dark: return "NightModeUnselected"
        }
    }
    
    var cardBackground: Color {
        switch self {
        case .device: return .color15
        case .light:  return Color(hex: "#F5F5F5") ?? Color(.systemGray6)
        case .dark:   return Color(hex: "#1C1C1E") ?? Color(.systemGray6)
        }
    }
    
    var fakeLineColor: Color {
        switch self {
        case .light: return .black.opacity(0.15)
        default: return .white.opacity(0.5)
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .device: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
