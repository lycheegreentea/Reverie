//
//  ContentView.swift
//  Reverie
//
//  Created by Lauren Chen on 5/22/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Word", systemImage: "tray.and.arrow.down.fill") {
                WordView()
                    .environmentObject(FavoriteManager())
                }
            Tab("Past Words", systemImage: "tray.and.arrow.down.fill") {
                PastWords()
                    .environmentObject(FavoriteManager())
                }
            Tab("Settings", systemImage: "tray.and.arrow.down.fill") {
                PastWords()
                    .environmentObject(FavoriteManager())
                }
        }
    }
}

#Preview {
    ContentView()
}
