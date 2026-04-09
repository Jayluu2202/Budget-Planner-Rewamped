//
//  AuroraGradient.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct AuroraGradient: View {
    var colors: [Color] = [
        Color(hex: "#6C5CE7") ?? .purple,
        Color(hex: "#A29BFE") ?? .indigo,
        Color(hex: "#FD79A8") ?? .pink,
        Color(hex: "#00CEC9") ?? .teal,
        Color(hex: "#0984E3") ?? .blue
    ]
    var animated: Bool = true
    @State private var phase: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
            
            Circle()
                .fill(colors[0].opacity(0.6))
                .frame(width: 180, height: 180)
                .blur(radius: 50)
                .offset(x: phase ? -40 : -50, y: phase ? -30 : -20)
            
            Circle()
                .fill(colors[1].opacity(0.5))
                .frame(width: 140, height: 140)
                .blur(radius: 45)
                .offset(x: phase ? 50 : 40, y: phase ? -20 : -30)
            
            Circle()
                .fill(colors[2].opacity(0.4))
                .frame(width: 160, height: 160)
                .blur(radius: 50)
                .offset(x: phase ? -20 : -10, y: phase ? 40 : 30)
            
            Circle()
                .fill(colors[3].opacity(0.35))
                .frame(width: 120, height: 120)
                .blur(radius: 40)
                .offset(x: phase ? 60 : 70, y: phase ? 30 : 40)
            
            if colors.count > 4 {
                Circle()
                    .fill(colors[4].opacity(0.3))
                    .frame(width: 100, height: 100)
                    .blur(radius: 35)
                    .offset(x: phase ? 10 : 0, y: phase ? -50 : -40)
            }
        }
        .onAppear {
            guard animated else { return }
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                phase = true
            }
        }
    }
}

struct AuroraCardStyle: ViewModifier {
    var colors: [Color]
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                    
                    AuroraGradient(colors: colors)
                        .opacity(0.7)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.25), .white.opacity(0.05), .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .shadow(color: colors[0].opacity(0.2), radius: 20, y: 8)
            )
    }
}

extension View {
    func auroraCard(
        colors: [Color] = [
            Color(hex: "#6C5CE7") ?? .purple,
            Color(hex: "#A29BFE") ?? .indigo,
            Color(hex: "#FD79A8") ?? .pink,
            Color(hex: "#00CEC9") ?? .teal,
            Color(hex: "#0984E3") ?? .blue
        ],
        cornerRadius: CGFloat = 24
    ) -> some View {
        self.modifier(AuroraCardStyle(colors: colors, cornerRadius: cornerRadius))
    }
}
