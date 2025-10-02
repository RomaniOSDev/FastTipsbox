//
//  SettingsView.swift
//  FastTipsbox
//
//  Created by Feather Jason on 12.09.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject private var dataManager: SimpleDataManager
    @State private var showingResetAlert = false
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Text("Settings")
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
                        dataSection
                        appSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
        }
        .onAppear {
            print("⚙️ SettingsView: onAppear called")
        }
        .alert("Reset All Data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetAllData()
            }
        } message: {
            Text("This will delete all your tips and categories. This action cannot be undone.")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 60))
                .foregroundColor(Theme.accent)
            
            Text("Settings")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Theme.primaryText)
        }
    }
    
    private var dataSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Data")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "trash.fill",
                    title: "Reset All Data",
                    subtitle: "Delete all tips and categories",
                    action: { showingResetAlert = true }
                )
            }
        }
    }
    
    private var appSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("App")
                .font(.headline)
                .foregroundColor(Theme.primaryText)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "questionmark.circle.fill",
                    title: "Show Onboarding",
                    subtitle: "View the app introduction again",
                    action: { showOnboarding() }
                )
                
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate App",
                    subtitle: "Rate FastTipBox on the App Store",
                    action: { rateApp() }
                )
                
                SettingsRow(
                    icon: "doc.text.fill",
                    title: "Privacy Policy",
                    subtitle: "View our privacy policy",
                    action: { openPrivacyPolicy() }
                )
            }
        }
    }
    
    private func resetAllData() {
        dataManager.resetData()
        print("⚙️ SettingsView: All data reset with 100 default tips")
    }
    
    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/b6db381a-7db1-4780-a8ac-ed9789c5a79a") {
            UIApplication.shared.open(url)
        }
    }
    
    private func showOnboarding() {
        UserDefaults.standard.set(false, forKey: "hasSeenOnboarding")
        print("⚙️ SettingsView: Onboarding reset - will show on next app launch")
    }
    

}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Theme.accent)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.primaryText)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.secondary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
        .environmentObject(SimpleDataManager())
}
