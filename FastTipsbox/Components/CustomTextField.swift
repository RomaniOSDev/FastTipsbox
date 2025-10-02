//
//  CustomTextField.swift
//  FastTipsbox
//
//  Created by Feather Jason on 12.09.2025.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .focused($isFocused)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Theme.cardBackground)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Theme.accent : Theme.secondary.opacity(0.3), lineWidth: 1)
            )
            .onTapGesture {
                isFocused = true
            }
    }
}
