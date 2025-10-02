//
//  CustomButton.swift
//  FastTipsbox
//
//  Created by Feather Jason on 12.09.2025.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let icon: String?
    let style: CustomButtonStyle
    let action: () -> Void
    
    init(_ title: String, icon: String? = nil, style: CustomButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(style.textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(style.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum CustomButtonStyle {
    case primary, secondary, glow, danger
    
    var background: AnyShapeStyle {
        switch self {
        case .primary:
            return AnyShapeStyle(Theme.gradient)
        case .secondary:
            return AnyShapeStyle(Theme.cardBackground)
        case .glow:
            return AnyShapeStyle(Theme.accent)
        case .danger:
            return AnyShapeStyle(Color.red.opacity(0.8))
        }
    }
    
    var textColor: Color {
        switch self {
        case .primary, .glow, .danger:
            return .white
        case .secondary:
            return Theme.primaryText
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary, .glow, .danger:
            return Color.clear
        case .secondary:
            return Theme.secondary.opacity(0.3)
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .primary, .glow, .danger:
            return 0
        case .secondary:
            return 1
        }
    }
}
