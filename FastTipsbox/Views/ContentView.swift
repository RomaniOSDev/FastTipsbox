//
//  ContentView.swift
//  FastTipsbox
//
//  Created by Feather Jason on 12.09.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var dataManager: SimpleDataManager
    @State private var selectedTab = 0
    @State private var showingOnboarding = false
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            if showingOnboarding {
                OnboardingView {
                    completeOnboarding()
                }
            } else {
                mainContentView
            }
        }
        .background(Theme.background)
        .onAppear {
            checkOnboardingStatus()
            ensureDataLoaded()
        }
    }
    
    private var mainContentView: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    TipsView()
                        .tag(0)
                        .onAppear {
                            print("📱 ContentView: TipsView appeared")
                        }
                    
                    AddTipView(selectedTab: $selectedTab)
                        .tag(1)
                        .onAppear {
                            print("➕ ContentView: AddTipView appeared")
                        }
                    
                    CategoriesView()
                        .tag(2)
                        .onAppear {
                            print("📁 ContentView: CategoriesView appeared")
                        }
                    
                    FavoritesView()
                        .tag(3)
                        .onAppear {
                            print("❤️ ContentView: FavoritesView appeared")
                        }
                    
                    SettingsView()
                        .tag(4)
                        .onAppear {
                            print("⚙️ ContentView: SettingsView appeared")
                        }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: geometry.size.height - 80) // Reserve space for tab bar
                
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            print("📊 ContentView: Main content appeared with \(dataManager.tips.count) tips and \(dataManager.categories.count) categories")
        }
    }
    
    private func checkOnboardingStatus() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        showingOnboarding = !hasSeenOnboarding
        print("📱 ContentView: Onboarding status - hasSeen: \(hasSeenOnboarding), showing: \(showingOnboarding)")
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        withAnimation(.easeInOut(duration: 0.5)) {
            showingOnboarding = false
        }
        print("📱 ContentView: Onboarding completed")
    }
    
    private func ensureDataLoaded() {
        print("📱 ContentView: Data loaded - tips: \(dataManager.tips.count), categories: \(dataManager.categories.count)")
    }
}

#Preview {
    ContentView()
        .environmentObject(SimpleDataManager())
}
