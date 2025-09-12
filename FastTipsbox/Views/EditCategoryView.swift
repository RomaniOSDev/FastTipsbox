import SwiftUI

struct EditCategoryView: View {
    @EnvironmentObject private var dataManager: SimpleDataManager
    @Environment(\.dismiss) private var dismiss
    
    let category: CategoryItem
    
    @State private var categoryName: String
    @State private var selectedIcon: String
    @State private var selectedColor: String

    
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
    
    init(category: CategoryItem) {
        self.category = category
        self._categoryName = State(initialValue: category.name)
        self._selectedIcon = State(initialValue: category.icon)
        self._selectedColor = State(initialValue: category.color)
    }
    
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
                        actionButtons
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Edit Category")
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
            Image(systemName: "folder.badge.gearshape")
                .font(.system(size: 60))
                .foregroundColor(Theme.accent)
            
            Text("Edit category")
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
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            CustomButton("Save Changes", icon: "checkmark.circle.fill", style: .primary) {
                saveChanges()
            }
            .disabled(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            CustomButton("Delete Category", icon: "trash.circle.fill", style: .danger) {
                deleteCategory()
            }
        }
        .padding(.bottom, 32)
    }
    
    private func saveChanges() {
        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        var updatedCategory = category
        updatedCategory.name = trimmedName
        updatedCategory.icon = selectedIcon
        updatedCategory.color = selectedColor
        
        dataManager.updateCategory(updatedCategory)
        print("📁 EditCategoryView: Updated category '\(trimmedName)' with ID \(category.id)")
        dismiss()
    }
    
    private func deleteCategory() {
        dataManager.deleteCategory(category)
        print("📁 EditCategoryView: Deleted category '\(category.name)' with ID \(category.id)")
        dismiss()
    }
}

#Preview {
    EditCategoryView(category: CategoryItem(name: "Test Category", icon: "folder", color: "#F4C430"))
        .environmentObject(SimpleDataManager())
}