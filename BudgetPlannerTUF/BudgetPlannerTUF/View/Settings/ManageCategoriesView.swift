//
//  ManageCategoriesView.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct ManageCategoriesView: View {
    @EnvironmentObject var viewModel: BudgetViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                let exp = viewModel.categories.filter { $0.type == .expense }
                let inc = viewModel.categories.filter { $0.type == .income }
                if !exp.isEmpty { catSection("Expense", exp) }
                if !inc.isEmpty { catSection("Income", inc) }
                if viewModel.categories.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tag").font(.system(size: 36)).foregroundStyle(.secondary.opacity(0.4))
                        Text("No categories yet").font(.subheadline).foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 40)
                    .background(RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial))
                }
                NavigationLink { AddCategoryView().environmentObject(viewModel) } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "plus.circle.fill").font(.subheadline)
                        Text("Add Category").font(.subheadline.weight(.semibold))
                    }
                    .foregroundStyle(Color.accent1).frame(maxWidth: .infinity).padding(.vertical, 13)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.accent1.opacity(0.35),
                                style: StrokeStyle(lineWidth: 1.5, dash: [7, 4])))
                }
            }.padding(20)
        }
        .navigationTitle("Categories").navigationBarTitleDisplayMode(.inline)
        .background(LinearGradient(colors: [Color.BG_1, Color.BG_2],
                                   startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
        .onAppear { viewModel.isTabBarHidden = true }
        .onDisappear { viewModel.isTabBarHidden = false }
    }

    private func catSection(_ title: String, _ cats: [Category]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.caption.weight(.bold)).foregroundStyle(.secondary).textCase(.uppercase)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(cats) { c in
                    VStack(spacing: 5) {
                        ZStack {
                            Circle().fill(Color(hex: c.colorHex) ?? .gray).frame(width: 44, height: 44)
                            Image(systemName: c.icon).font(.system(size: 17)).foregroundStyle(.white)
                        }
                        Text(c.name).font(.caption2.weight(.medium)).lineLimit(1)
                    }
                    .contextMenu {
                        Button(role: .destructive) { withAnimation { viewModel.deleteCategory(c) } } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.borderLight, lineWidth: 0.5)))
        }
    }
}


#Preview {
    ManageCategoriesView()
        .environmentObject(BudgetViewModel())
}
