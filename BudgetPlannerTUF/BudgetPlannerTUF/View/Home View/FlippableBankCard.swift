//
//  FlippableBankCard.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//
import SwiftUI

struct FlippableBankCard: View {
    let account: BankAccount
    let currencySymbol: String
    @State private var isFlipped = false
    
    private var cardColor: Color { Color(hex: account.colorHex) ?? .blue }
    
    var body: some View {
        ZStack {
            cardBack.opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
            cardFront.opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.75)) { isFlipped.toggle() }
            let enabled = UserDefaults.standard.bool(forKey: "hapticEnabled")
            if enabled { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
        }
    }
    
    private var cardFront: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(account.bankName.uppercased())
                        .font(Poppins.bold.font(size: 9))
                        .foregroundStyle(.white.opacity(0.5)).tracking(1.5)
                    Text(account.name)
                        .font(Poppins.bold.font(size: 15))
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "building.columns.fill").font(.title3).foregroundStyle(.white.opacity(0.3))
            }
            Spacer()
            RoundedRectangle(cornerRadius: 3)
                .fill(LinearGradient(colors: [.white.opacity(0.35), .white.opacity(0.12)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 34, height: 24)
            Spacer()
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 1) {
                    Text("BALANCE")
                        .font(Poppins.medium.font(size: 8))
                        .foregroundStyle(.white.opacity(0.45))
                    Text("\(currencySymbol)\(account.balance, specifier: "%.2f")")
                        .font(Poppins.bold.font(size: 18))
                        .foregroundStyle(.white)
                }
                Spacer()
                HStack(spacing: 3) { Text("Tap for details").font(Poppins.regular.font(size: 9)); Image(systemName: "hand.tap").font(.system(size: 9)) }.foregroundStyle(.white.opacity(0.35))
            }
        }
        .padding(16).frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(LinearGradient(colors: [cardColor, cardColor.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                Circle().fill(RadialGradient(colors: [.white.opacity(0.15), .clear], center: .center, startRadius: 0, endRadius: 80)).frame(width: 140, height: 140).offset(x: 80, y: -50)
                Circle().fill(RadialGradient(colors: [cardColor.opacity(0.5), .clear], center: .center, startRadius: 0, endRadius: 60)).frame(width: 100, height: 100).blur(radius: 20).offset(x: -60, y: 40)
                RoundedRectangle(cornerRadius: 18).stroke(LinearGradient(colors: [.white.opacity(0.3), .white.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 0.5)
            }.clipShape(RoundedRectangle(cornerRadius: 18)).shadow(color: cardColor.opacity(0.4), radius: 14, y: 6)
        )
    }
    
    private var cardBack: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(account.name)
                    .font(Poppins.bold.font(size: 15))
                    .foregroundStyle(.white)
                Spacer()
                Text("Tap to flip").font(.system(size: 9)).foregroundStyle(.white.opacity(0.35))
            }
            Rectangle().fill(.white.opacity(0.15)).frame(height: 0.5)
            row("Bank", account.bankName)
            if !account.accountNumber.isEmpty { row("A/C No.", masked(account.accountNumber)) }
            if !account.ifscCode.isEmpty { row("IFSC", account.ifscCode) }
            if !account.upiId.isEmpty {
                HStack(spacing: 6) { row("UPI", account.upiId); Image(systemName: "checkmark.seal.fill").font(.system(size: 10)).foregroundStyle(.green) }
            } else { row("UPI", "Not linked") }
            Spacer()
        }
        .padding(16).frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 18).fill(LinearGradient(colors: [cardColor.opacity(0.85), cardColor.opacity(0.5)], startPoint: .topTrailing, endPoint: .bottomLeading))
                RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.15), lineWidth: 0.5)
            }.clipShape(RoundedRectangle(cornerRadius: 18)).shadow(color: cardColor.opacity(0.3), radius: 10, y: 5)
        )
    }
    
    private func row(_ l: String, _ v: String) -> some View {
        HStack {
            Text(l).font(.system(size: 10, weight: .medium, design: .monospaced)).foregroundStyle(.white.opacity(0.45)).frame(width: 52, alignment: .leading)
            Text(v).font(.system(size: 12, weight: .semibold)).foregroundStyle(v == "Not linked" ? .white.opacity(0.3) : .white)
        }
    }
    private func masked(_ n: String) -> String { n.count > 4 ? String(repeating: "•", count: n.count - 4) + String(n.suffix(4)) : n }
}
