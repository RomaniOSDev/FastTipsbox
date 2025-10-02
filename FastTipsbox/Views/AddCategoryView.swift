//
//  AddCategoryView.swift
//  FastTipsbox
//
//  Created by Feather Jason on 12.09.2025.
//

import SwiftUI

struct AddCategoryView: View {
    @EnvironmentObject private var dataManager: SimpleDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var categoryName = ""
    @State private var selectedIcon = "folder"
    @State private var selectedColor = "#F4C430"

    
    private let availableIcons = [
        "folder", "heart", "star", "lightbulb", "bookmark",
        "tag", "flag", "bell", "gear", "house",
        "car", "airplane", "gamecontroller", "music.note", "camera",
        "fork.knife", "sparkles", "dollarsign.circle", "clock", "calendar"
    ]
    
    private let availableColors = [
        "#F4C430", "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4",
        "#FFEAA7", "#DDA0DD", "#98D8C8", "#F7DC6F", "#BB8FCE"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        nameSection
                        iconSection
                        colorSection
                        saveButton
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Theme.accent)
                }
            }
        }
        .onTapGesture {
            // Dismiss keyboard
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(Theme.accent)
            
            Text("Create a new category")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Theme.primaryText)
        }
    }
    
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category Name")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            CustomTextField(placeholder: "Enter category name", text: $categoryName)
        }
    }
    
    private var iconSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Icon")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                ForEach(availableIcons, id: \.self) { icon in
                    Button(action: {
                        selectedIcon = icon
                    }) {
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(selectedIcon == icon ? Theme.accent : Theme.secondaryText)
                            .frame(width: 50, height: 50)
                            .background(
                                selectedIcon == icon ? 
                                Theme.accent.opacity(0.2) : Theme.cardBackground
                            )
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var colorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Color")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                ForEach(availableColors, id: \.self) { color in
                    Button(action: {
                        selectedColor = color
                    }) {
                        Circle()
                            .fill(Color(hex: color))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .stroke(selectedColor == color ? Theme.accent : Color.clear, lineWidth: 3)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var saveButton: some View {
        CustomButton("Create Category", icon: "checkmark.circle.fill", style: .primary) {
            createCategory()
        }
        .disabled(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        .padding(.bottom, 32)
    }
    
    private func createCategory() {
        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let newCategory = CategoryItem(name: trimmedName, icon: selectedIcon, color: selectedColor)
        dataManager.addCategory(newCategory)
        
        print("📁 AddCategoryView: Created category '\(trimmedName)' with ID \(newCategory.id)")
        dismiss()
    }
}

#Preview {
    AddCategoryView()
        .environmentObject(SimpleDataManager())
}
