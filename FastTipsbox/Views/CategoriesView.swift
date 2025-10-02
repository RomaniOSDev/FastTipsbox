//
//  CategoriesView.swift
//  FastTipsbox
//
//  Created by Feather Jason on 12.09.2025.
//

import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject private var dataManager: SimpleDataManager
    @State private var showingAddCategory = false
    @State private var selectedCategory: CategoryItem?
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Text("Categories")
                        .foregroundColor(Theme.accent)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        showingAddCategory = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Theme.accent)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 8)
                .background(Theme.background)
                
                VStack {
                    if dataManager.categories.isEmpty {
                        emptyStateView
                    } else {
                        categoryList
                    }
                }
            }
        }
        .onAppear {
            print("📁 CategoriesView: onAppear called")
            print("📁 CategoriesView: Categories count: \(dataManager.categories.count)")
            print("📁 CategoriesView: Tips count: \(dataManager.tips.count)")
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView()
        }
        .sheet(item: $selectedCategory) { category in
            EditCategoryView(category: category)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 80))
                .foregroundColor(Theme.accent)
            
            VStack(spacing: 12) {
                Text("No Categories Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryText)
                
                Text("Create your first category to organize your tips")
                    .font(.body)
                    .foregroundColor(Theme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            CustomButton("Create Category", icon: "plus.circle.fill", style: .primary) {
                showingAddCategory = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }
    
    private var categoryList: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(dataManager.categories) { category in
                    CategoryCard(category: category) {
                        print("📁 CategoriesView: Tapping on category '\(category.name)'")
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
}

struct CategoryCard: View {
    let category: CategoryItem
    let onTap: () -> Void
    @EnvironmentObject private var dataManager: SimpleDataManager
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(Color(hex: category.color))
                
                VStack(spacing: 4) {
                    Text(category.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.primaryText)
                    
                    Text("\(dataManager.tips.filter { $0.categoryId == category.id }.count) tips")
                        .font(.caption)
                        .foregroundColor(Theme.secondaryText)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Theme.secondary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CategoriesView()
        .environmentObject(SimpleDataManager())
}
