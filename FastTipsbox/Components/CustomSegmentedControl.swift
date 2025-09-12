import SwiftUI

struct CustomSegmentedControl<T: CaseIterable & Hashable>: View where T.AllCases.Index == Int {
    let options: [T]
    @Binding var selection: T
    let titleProvider: (T) -> String
    let iconProvider: ((T) -> String)?
    
    init(_ options: [T], selection: Binding<T>, titleProvider: @escaping (T) -> String, iconProvider: ((T) -> String)? = nil) {
        self.options = options
        self._selection = selection
        self.titleProvider = titleProvider
        self.iconProvider = iconProvider
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                Button(action: {
                    selection = option
                }) {
                    HStack(spacing: 6) {
                        if let iconProvider = iconProvider {
                            Image(systemName: iconProvider(option))
                                .font(.system(size: 14, weight: .medium))
                        }
                        Text(titleProvider(option))
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(selection == option ? Theme.accent : Theme.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        selection == option ? Theme.accent.opacity(0.2) : Color.clear
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(Theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Theme.secondary.opacity(0.3), lineWidth: 1)
        )
    }
}
