import SwiftUI

struct TipDetailView: View {
    let tip: TipItem
    @EnvironmentObject private var dataManager: SimpleDataManager
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorite = false
    
    var category: CategoryItem? {
        dataManager.categories.first { $0.id == tip.categoryId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection
                        contentSection
                        categorySection
                        tagsSection
                        favoriteSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Tip Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Theme.accent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: toggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(Theme.accent)
                    }
                }
            }
        }
        .onAppear {
            isFavorite = tip.favoriteCount > 0
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(tip.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.primaryText)
            
            Text("Created \(tip.createdAt, style: .date)")
                .font(.caption)
                .foregroundColor(Theme.secondaryText)
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            Text(tip.content)
                .font(.body)
                .foregroundColor(Theme.secondaryText)
                .lineSpacing(4)
        }
        .padding(16)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.secondary.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            if let category = category {
                HStack(spacing: 12) {
                    Image(systemName: category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: category.color))
                    
                    Text(category.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.primaryText)
                    
                    Spacer()
                }
                .padding(16)
                .background(Theme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.secondary.opacity(0.3), lineWidth: 1)
                )
            } else {
                Text("No category")
                    .font(.body)
                    .foregroundColor(Theme.secondaryText)
                    .padding(16)
                    .background(Theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.secondary.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tags")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            if !tip.tags.isEmpty {
                Text(tip.tags)
                    .font(.body)
                    .foregroundColor(Theme.accent)
                    .padding(16)
                    .background(Theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.secondary.opacity(0.3), lineWidth: 1)
                    )
            } else {
                Text("No tags")
                    .font(.body)
                    .foregroundColor(Theme.secondaryText)
                    .padding(16)
                    .background(Theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.secondary.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
    
    private var favoriteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Statistics")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.title2)
                        .foregroundColor(Theme.accent)
                    
                    Text("\(tip.favoriteCount)")
                        .font(.headline)
                        .foregroundColor(Theme.primaryText)
                    
                    Text("Favorites")
                        .font(.caption)
                        .foregroundColor(Theme.secondaryText)
                }
                
                Spacer()
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
    
    private func toggleFavorite() {
        isFavorite.toggle()
        
        var updatedTip = tip
        updatedTip.favoriteCount = isFavorite ? 1 : 0
        
        dataManager.updateTip(updatedTip)
        print("💖 TipDetailView: Toggled favorite for tip '\(tip.title)' - new count: \(updatedTip.favoriteCount)")
    }
}

#Preview {
    TipDetailView(tip: TipItem(title: "Test Tip", content: "This is a test tip content", categoryId: UUID()))
        .environmentObject(SimpleDataManager())
}
