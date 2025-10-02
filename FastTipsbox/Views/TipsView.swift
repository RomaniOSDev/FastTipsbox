//
//  TipsView.swift
//  FastTipsbox
//
//  Created by Feather Jason on 12.09.2025.
//

import SwiftUI

struct TipsView: View {
    @EnvironmentObject private var dataManager: SimpleDataManager
    @State private var searchText: String = ""
    @State private var sortOption: SortOption = .newest
    @State private var selectedTip: TipItem? = nil

    
    var filteredTips: [TipItem] {
        let filtered = searchText.isEmpty ? dataManager.tips : dataManager.tips.filter { tip in
            tip.title.localizedCaseInsensitiveContains(searchText) ||
            tip.content.localizedCaseInsensitiveContains(searchText) ||
            tip.tags.localizedCaseInsensitiveContains(searchText)
        }
        
        switch sortOption {
        case .newest:
            return filtered.sorted { $0.createdAt > $1.createdAt }
        case .mostUsed:
            return filtered.sorted { $0.favoriteCount > $1.favoriteCount }
        case .category:
            return filtered.sorted { $0.title < $1.title }
        }
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Text("Tips")
                        .foregroundColor(Theme.accent)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 8)
                .background(Theme.background)
                
                searchAndSortSection
                
                if dataManager.tips.isEmpty {
                    VStack {
                        Spacer()
                        Text("Loading tips...")
                            .foregroundColor(.white)
                            .font(.title2)
                        Spacer()
                    }
                } else if filteredTips.isEmpty {
                    emptyStateView
                } else {
                    tipsList
                }
            }
        }
        .onAppear {
            print("📱 TipsView: onAppear - Tips: \(dataManager.tips.count), Categories: \(dataManager.categories.count)")
        }
        .onTapGesture {
            // Dismiss keyboard
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .sheet(item: $selectedTip) { tip in
            TipDetailView(tip: tip)
                .environmentObject(dataManager)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "lightbulb.slash")
                .font(.system(size: 80))
                .foregroundColor(Theme.accent)
            
            VStack(spacing: 12) {
                Text("No Tips Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryText)
                
                Text("Add your first tip to get started")
                    .font(.body)
                    .foregroundColor(Theme.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }
    
    private var tipsList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(filteredTips) { tip in
                    TipRow(tip: tip, onToggleFavorite: { tip in
                        toggleFavorite(for: tip)
                    }) {
                        print("🔍 TipsView: Tapping on tip '\(tip.title)'")
                        selectedTip = tip
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            .padding(.bottom, 80)
        }
    }
    
    private var searchAndSortSection: some View {
        VStack(spacing: 12) {
            CustomTextField(placeholder: "Search tips...", text: $searchText)
            
            CustomSegmentedControl(SortOption.allCases, selection: $sortOption) { option in
                option.displayName
            } iconProvider: { option in
                option.icon
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private func toggleFavorite(for tip: TipItem) {
        var updatedTip = tip
        updatedTip.favoriteCount = tip.favoriteCount > 0 ? 0 : 1
        
        dataManager.updateTip(updatedTip)
        print("💖 TipsView: Toggled favorite for tip '\(tip.title)' - new count: \(updatedTip.favoriteCount)")
    }
}

struct TipRow: View {
    let tip: TipItem
    let onToggleFavorite: (TipItem) -> Void
    let onTap: () -> Void
    @EnvironmentObject private var dataManager: SimpleDataManager
    
    var category: CategoryItem? {
        dataManager.categories.first { $0.id == tip.categoryId }
    }
    
    var body: some View {
        Button(action: {
            print("🔍 TipRow: Main button tapped for tip '\(tip.title)'")
            onTap()
        }) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(tip.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.primaryText)
                        .lineLimit(2)
                    
                    Text(tip.content)
                        .font(.body)
                        .foregroundColor(Theme.secondaryText)
                        .lineLimit(2)
                    
                    if let category = category {
                        HStack(spacing: 6) {
                            Image(systemName: category.icon)
                                .font(.caption)
                                .foregroundColor(Color(hex: category.color))
                            Text(category.name)
                                .font(.caption)
                                .foregroundColor(Theme.secondaryText)
                        }
                    }
                    
                    if !tip.tags.isEmpty {
                        Text(tip.tags)
                            .font(.caption)
                            .foregroundColor(Theme.accent)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    print("💖 TipRow: Toggling favorite for tip '\(tip.title)'")
                    onToggleFavorite(tip)
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tip.favoriteCount > 0 ? "heart.fill" : "heart")
                            .font(.caption)
                            .foregroundColor(Theme.accent)
                        
                        Text("\(tip.favoriteCount)")
                            .font(.caption2)
                            .foregroundColor(Theme.secondaryText)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .onTapGesture {
                    // Prevent tap from propagating to parent button
                }
            }
            .padding(12)
            .background(Theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.secondary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TipsView()
        .environmentObject(SimpleDataManager())
}
