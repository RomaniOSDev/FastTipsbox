//
//  OnboardingModel.swift
//  FastTipsbox
//
//  Created by Feather Jason on 12.09.2025.
//

import SwiftUI

struct OnboardingPage {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let color: Color
}

class OnboardingData {
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to FastTipBox",
            description: "Your personal collection of useful tips and tricks for everyday life",
            imageName: "lightbulb.fill",
            color: .yellow
        ),
        OnboardingPage(
            title: "Organize by Categories",
            description: "Create categories like Cooking, Health, Money, and more to keep your tips organized",
            imageName: "folder.fill",
            color: .blue
        ),
        OnboardingPage(
            title: "Add Your Tips",
            description: "Easily add new tips with titles, descriptions, and tags for quick searching",
            imageName: "plus.circle.fill",
            color: .green
        ),
        OnboardingPage(
            title: "Mark Favorites",
            description: "Heart your favorite tips to quickly access them later",
            imageName: "heart.fill",
            color: .red
        ),
        OnboardingPage(
            title: "Search & Discover",
            description: "Find tips instantly with our powerful search and filtering system",
            imageName: "magnifyingglass.circle.fill",
            color: .purple
        )
    ]
}
