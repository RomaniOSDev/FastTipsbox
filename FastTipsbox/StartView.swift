//
//  StartView.swift
//  FastTipsbox
//
//  Created by Роман Главацкий on 12.09.2025.
//

import SwiftUI

struct StartView: View {
    @StateObject private var dataManager = SimpleDataManager()
    var body: some View {
        ContentView()
            .environmentObject(dataManager)
            .onAppear {
                print("FastTipBoxApp: ContentView appeared")
                print("FastTipBoxApp: SimpleDataManager initialized with \(dataManager.tips.count) tips, \(dataManager.categories.count) categories")
            }
    }
}

#Preview {
    StartView()
}
