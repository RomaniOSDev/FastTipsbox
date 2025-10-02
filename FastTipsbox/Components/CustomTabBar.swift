//
//  CustomTabBar.swift
//  FastTipsbox
//
//  Created by Feather Jason on 12.09.2025.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5) { index in
                Button(action: { selectedTab = index }) {
                    VStack(spacing: 6) {
                        Image(systemName: tabIcon(for: index))
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(selectedTab == index ? Theme.accent : Theme.secondaryText)
                        
                        Text(tabTitle(for: index))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(selectedTab == index ? Theme.accent : Theme.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Theme.secondary.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "lightbulb.fill"
        case 1: return "plus.circle.fill"
        case 2: return "folder.fill"
        case 3: return "heart.fill"
        case 4: return "gearshape.fill"
        default: return "circle"
        }
    }
    
    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Tips"
        case 1: return "Add"
        case 2: return "Categories"
        case 3: return "Favorites"
        case 4: return "Settings"
        default: return ""
        }
    }
}
