//
//  IconPickerSheet.swift
//  BudgetPlannerTUF
//
//  Created by Admin on 08/04/26.
//

import SwiftUI

struct IconPickerSheet: View {
    @Binding var selectedIcon: String
    let selectedColor: String
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    private let iconSections: [(section: String, icons: [String])] = [
        ("Food & Drink", ["fork.knife", "cup.and.saucer.fill", "mug.fill", "wineglass.fill", "takeoutbag.and.cup.and.straw.fill", "birthday.cake.fill", "carrot.fill", "fish.fill"]),
        ("Transport", ["car.fill", "bus.fill", "tram.fill", "airplane", "fuelpump.fill", "bicycle", "scooter", "ferry.fill"]),
        ("Shopping", ["cart.fill", "bag.fill", "tshirt.fill", "shoe.fill", "gift.fill", "tag.fill", "handbag.fill", "eyeglasses"]),
        ("Home & Bills", ["house.fill", "bolt.fill", "wifi", "drop.fill", "flame.fill", "tv.fill", "washer.fill", "lamp.desk.fill"]),
        ("Health", ["heart.fill", "cross.case.fill", "pills.fill", "figure.walk", "figure.run", "dumbbell.fill", "stethoscope", "bandage.fill"]),
        ("Entertainment", ["gamecontroller.fill", "headphones", "film.fill", "music.note", "theatermasks.fill", "book.fill", "paintbrush.fill", "camera.fill"]),
        ("Finance", ["indianrupeesign.circle.fill", "banknote.fill", "creditcard.fill", "chart.line.uptrend.xyaxis", "building.columns.fill", "wallet.bifold.fill", "percent", "arrow.triangle.2.circlepath"]),
        ("Work", ["graduationcap.fill", "book.closed.fill", "pencil.and.ruler.fill", "laptopcomputer", "briefcase.fill", "printer.fill", "paperclip", "folder.fill"]),
        ("Other", ["star.fill", "bell.fill", "phone.fill", "envelope.fill", "map.fill", "globe.americas.fill", "pawprint.fill", "leaf.fill"])
    ]
    
    private var filteredIcons: [(section: String, icons: [String])] {
        if searchText.isEmpty { return iconSections }
        return iconSections.compactMap { section in
            let filtered = section.icons.filter { $0.localizedCaseInsensitiveContains(searchText) }
            return filtered.isEmpty ? nil : (section: section.section, icons: filtered)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search icons...", text: $searchText)
                        .font(.subheadline)
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 16, pinnedViews: .sectionHeaders) {
                        ForEach(filteredIcons, id: \.section) { section in
                            Section {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 8) {
                                    ForEach(section.icons, id: \.self) { icon in
                                        iconCell(icon: icon)
                                    }
                                }
                            } header: {
                                Text(section.section)
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 4)
                                    .background(Color.BG_1.opacity(0.95))
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .background(
                LinearGradient(colors: [Color.BG_1, Color.BG_2], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
            .navigationTitle("Choose Icon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.accent1)
                }
            }
        }
    }
    
    @ViewBuilder
    private func iconCell(icon: String) -> some View {
        let isSelected = selectedIcon == icon
        let color = Color(hex: selectedColor) ?? .gray
        
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedIcon = icon
            }
        } label: {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color)
                        .frame(height: 46)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                        .frame(height: 46)
                }
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(isSelected ? .white : .primary)
            }
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    IconPickerSheet(selectedIcon: .constant("cart.fill"), selectedColor: "#FF6B6B")
}
