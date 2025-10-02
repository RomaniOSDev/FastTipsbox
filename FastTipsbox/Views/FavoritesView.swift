//
//  FavoritesView.swift
//  FastTipsbox
//
//  Created by Feather Jason on 12.09.2025.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var dataManager: SimpleDataManager
    @State private var searchText: String = ""

    
    var allFavoriteTips: [TipItem] {
        dataManager.tips.filter { $0.favoriteCount > 0 }.sorted { $0.favoriteCount > $1.favoriteCount }
    }
    
    var filteredFavoriteTips: [TipItem] {
        if searchText.isEmpty {
            return allFavoriteTips
        } else {
            return allFavoriteTips.filter { tip in
                tip.title.localizedCaseInsensitiveContains(searchText) ||
                tip.content.localizedCaseInsensitiveContains(searchText) ||
                tip.tags.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var hasFavorites: Bool {
        !allFavoriteTips.isEmpty
    }
    
    var hasSearchResults: Bool {
        !filteredFavoriteTips.isEmpty
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Text("Favorites")
                        .foregroundColor(Theme.accent)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button("Done") {
                        // Dismiss keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .foregroundColor(Theme.accent)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 8)
                .background(Theme.background)
                
                VStack {
                    if !hasFavorites {
                        emptyStateView
                    } else {
                        favoritesList
                    }
                }
            }
        }
        .onAppear {
            print("❤️ FavoritesView: onAppear called")
            print("❤️ FavoritesView: All favorites count: \(allFavoriteTips.count)")
            print("❤️ FavoritesView: Filtered favorites count: \(filteredFavoriteTips.count)")
        }
        .onTapGesture {
            // Dismiss keyboard
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.slash")
                .font(.system(size: 80))
                .foregroundColor(Theme.accent)
            
            VStack(spacing: 12) {
                Text("No Favorites Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryText)
                
                Text("Mark tips as favorites to see them here")
                    .font(.body)
                    .foregroundColor(Theme.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }
    
    private var favoritesList: some View {
        VStack(spacing: 0) {
            // Search field - always visible when there are favorites
            searchField
            
            // Content based on search results
            if hasSearchResults {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredFavoriteTips) { tip in
                            FavoriteTipRow(tip: tip)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            } else if !searchText.isEmpty {
                noSearchResultsView
            } else {
                // This shouldn't happen since we check hasFavorites above
                emptyStateView
            }
        }
    }
    
    private var searchField: some View {
        HStack {
            CustomTextField(placeholder: "Search favorites...", text: $searchText)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Theme.secondaryText)
                }
                .padding(.leading, 8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private var noSearchResultsView: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(Theme.secondaryText)
            
            VStack(spacing: 12) {
                Text("No Results Found")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryText)
                
                Text("Try searching with different keywords")
                    .font(.body)
                    .foregroundColor(Theme.secondaryText)
                    .multilineTextAlignment(.center)
                
                Button("Clear Search") {
                    searchText = ""
                }
                .foregroundColor(Theme.accent)
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }
}

struct FavoriteTipRow: View {
    let tip: TipItem
    @EnvironmentObject private var dataManager: SimpleDataManager
    
    var category: CategoryItem? {
        dataManager.categories.first { $0.id == tip.categoryId }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text(tip.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.primaryText)
                    .lineLimit(2)
                
                Text(tip.content)
                    .font(.body)
                    .foregroundColor(Theme.secondaryText)
                    .lineLimit(3)
                
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
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(Theme.accent)
                
                Text("\(tip.favoriteCount)")
                    .font(.caption)
                    .foregroundColor(Theme.secondaryText)
            }
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.secondary.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    FavoritesView()
        .environmentObject(SimpleDataManager())
}
