//
//  AddCategoryView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct AddCategoryView: View {
    @EnvironmentObject var viewModel: BudgetViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var type: TransactionType = .expense
    @State private var selectedIcon = "cart.fill"
    @State private var selectedColor = "#FF6B6B"
    @State private var showIconPicker = false
    
    private let colorOptions = [
        "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4",
        "#FFEAA7", "#DDA0DD", "#6C5CE7", "#FDA085",
        "#E17055", "#00B894", "#0984E3", "#636E72"
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: selectedColor) ?? .gray)
                            .frame(width: 60, height: 60)
                            .shadow(color: (Color(hex: selectedColor) ?? .gray).opacity(0.4), radius: 10, y: 4)
                        Image(systemName: selectedIcon)
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    }
                    Text(name.isEmpty ? "Category Name" : name)
                        .font(Boska.medium.font(size: 17))
                    Text(type.rawValue.capitalized)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.ultraThinMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.borderLight, lineWidth: 0.5))
                )
                
                typeToggle
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("NAME")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                        .tracking(0.5)
                    
                    TextField("e.g. Groceries, Salary", text: $name)
                        .font(.subheadline)
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderLight, lineWidth: 0.5))
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("COLOR")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                        .tracking(0.5)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                        ForEach(colorOptions, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex) ?? .gray)
                                .frame(width: 38, height: 38)
                                .overlay {
                                    if selectedColor == hex {
                                        Image(systemName: "checkmark")
                                            .font(.caption.bold())
                                            .foregroundStyle(.white)
                                    }
                                }
                                .scaleEffect(selectedColor == hex ? 1.1 : 1.0)
                                .animation(.spring(response: 0.3), value: selectedColor)
                                .onTapGesture { selectedColor = hex }
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.borderLight, lineWidth: 0.5))
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("ICON")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.secondary)
                        .tracking(0.5)
                    
                    Button {
                        showIconPicker = true
                    } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill((Color(hex: selectedColor) ?? .gray).opacity(0.15))
                                    .frame(width: 44, height: 44)
                                Image(systemName: selectedIcon)
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(hex: selectedColor) ?? .gray)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Selected Icon")
                                    .font(.subheadline.weight(.medium))
                                Text(selectedIcon)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("Change")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.accent1)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.tertiary)
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(.ultraThinMaterial)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderLight, lineWidth: 0.5))
                        )
                    }
                    .tint(.primary)
                }
                
                Button {
                    viewModel.addCategory(name: name, icon: selectedIcon, colorHex: selectedColor, type: type)
                    dismiss()
                } label: {
                    Text("Save Category")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(!name.isEmpty ?
                                      LinearGradient(colors: [Color.accent1, Color.accent2], startPoint: .leading, endPoint: .trailing) :
                                        LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.2)], startPoint: .leading, endPoint: .trailing)
                                )
                                .shadow(color: !name.isEmpty ? Color.accent1.opacity(0.35) : .clear, radius: 10, y: 4)
                        )
                }
                .disabled(name.isEmpty)
            }
            .padding(20)
        }
        .navigationTitle("Add Category")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            LinearGradient(colors: [Color.BG_1, Color.BG_2], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .onAppear { viewModel.isTabBarHidden = true }
        .onDisappear { viewModel.isTabBarHidden = false }
        .sheet(isPresented: $showIconPicker) {
            IconPickerSheet(selectedIcon: $selectedIcon, selectedColor: selectedColor)
        }
    }
    
    private var typeToggle: some View {
        HStack(spacing: 0) {
            typeButton(for: .income, label: "Income")
            typeButton(for: .expense, label: "Expense")
        }
        .padding(3)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
    
    private func typeButton(for txnType: TransactionType, label: String) -> some View {
        let isSelected = type == txnType
        return Text(label)
            .font(.subheadline.weight(isSelected ? .bold : .medium))
            .foregroundStyle(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.accent1 : .clear)
            )
            .onTapGesture {
                withAnimation { type = txnType }
            }
    }
}



#Preview {
    NavigationStack {
        AddCategoryView()
            .environmentObject(BudgetViewModel())
    }
}
