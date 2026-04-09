//
//  ColorExtension.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 06/04/26.
//

import SwiftUI

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        guard hexSanitized.count == 6,
              let hexNumber = UInt64(hexSanitized, radix: 16)
        else { return nil }
        
        let r = Double((hexNumber & 0xFF0000) >> 16) / 255
        let g = Double((hexNumber & 0x00FF00) >> 8) / 255
        let b = Double(hexNumber & 0x0000FF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
    
    private static func adaptive(light: String, dark: String) -> Color {
        Color(UIColor { traitCollection in
            let hex = traitCollection.userInterfaceStyle == .dark ? dark : light
            return UIColor(hexString: hex)
        })
    }
    static let BG_1 = adaptive(light: "#F2F3F7", dark: "#0D0D12")
    static let BG_2 = adaptive(light: "#E6E8EE", dark: "#16161F")
    static let cardBG = adaptive(light: "#FFFFFF", dark: "#1C1C28")
    static let cardDark1 = adaptive(light: "#1A1A2E", dark: "#1A1A2E")
    static let cardDark2 = adaptive(light: "#16213E", dark: "#16213E")
    static let accent1 = adaptive(light: "#6366F1", dark: "#818CF8")
    static let accent2 = adaptive(light: "#8B5CF6", dark: "#A78BFA")
    static let incomeGreen = adaptive(light: "#10B981", dark: "#34D399")
    static let expenseRed  = adaptive(light: "#EF4444", dark: "#F87171")
    static let surfacePrimary   = adaptive(light: "#FFFFFF", dark: "#1E1E2E")
    static let surfaceSecondary = adaptive(light: "#F5F5F8", dark: "#252536")
    static let surfaceTertiary  = adaptive(light: "#EDEDF2", dark: "#2A2A3C")
    static let textPrimary   = adaptive(light: "#1A1A2E", dark: "#F0F0F5")
    static let textSecondary = adaptive(light: "#6B7280", dark: "#9CA3AF")
    static let borderLight = adaptive(light: "#E0E2E8", dark: "#2A2A3C")
}

extension UIColor {
    convenience init(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var hexNumber: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&hexNumber)
        
        let r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
        let g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
        let b = CGFloat(hexNumber & 0x0000FF) / 255
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
