import SwiftUI

struct AddTipView: View {
    @EnvironmentObject private var dataManager: SimpleDataManager
    @State private var title = ""
    @State private var content = ""
    @State private var selectedCategory: CategoryItem?
    @State private var tags = ""

    @State private var showingSuccessAlert = false
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Text("Add Tip")
                        .foregroundColor(Theme.accent)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 8)
                .background(Theme.background)
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        titleSection
                        contentSection
                        categorySection
                        tagsSection
                        saveButton
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
        }
        .onAppear {
            if selectedCategory == nil && !dataManager.categories.isEmpty {
                selectedCategory = dataManager.categories.first
            }
        }
        .onTapGesture {
            // Dismiss keyboard
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .alert("Success!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                selectedTab = 0
            }
        } message: {
            Text("Your tip has been saved successfully!")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 60))
                .foregroundColor(Theme.accent)
            
            Text("Share your knowledge")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Theme.primaryText)
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            CustomTextField(placeholder: "Enter tip title", text: $title)
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            TextField("Enter tip description", text: $content)
                .lineLimit(5)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Theme.cardBackground)
                .foregroundColor(Theme.primaryText)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.secondary.opacity(0.3), lineWidth: 1)
                )
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            if dataManager.categories.isEmpty {
                Text("No categories available")
                    .foregroundColor(Theme.secondaryText)
                    .padding(.vertical, 12)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(dataManager.categories) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: category.icon)
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(hex: category.color))
                                    Text(category.name)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Theme.primaryText)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    selectedCategory?.id == category.id ? 
                                    Theme.accent.opacity(0.2) : Theme.cardBackground
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selectedCategory?.id == category.id ? Theme.accent : Theme.secondary.opacity(0.3), lineWidth: 1)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tags (optional)")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            CustomTextField(placeholder: "Enter tags separated by commas", text: $tags)
        }
    }
    
    private var saveButton: some View {
        CustomButton("Save Tip", icon: "checkmark.circle.fill", style: .primary) {
            saveTip()
        }
        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || 
                 content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                 selectedCategory == nil)
        .padding(.bottom, 32)
    }
    
    private func saveTip() {
        guard let category = selectedCategory else { return }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTags = tags.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let newTip = TipItem(
            title: trimmedTitle,
            content: trimmedContent,
            categoryId: category.id,
            tags: trimmedTags
        )
        
        dataManager.addTip(newTip)
        
        // Clear form
        title = ""
        content = ""
        tags = ""
        
        // Show success alert
        showingSuccessAlert = true
        
        print("📝 AddTipView: Created tip '\(trimmedTitle)' with ID \(newTip.id)")
    }
}

#Preview {
    AddTipView(selectedTab: .constant(1))
        .environmentObject(SimpleDataManager())
}
