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
            Tab("Word", systemImage: "textformat.characters") {
                WordView()
                }
            Tab("Archive", systemImage: "append.page") {
                PastWords()
                }
            Tab("Quote", systemImage: "quote.opening") {
                DailyQuote()
                }
            Tab("Your Quotes", systemImage: "quote.bubble.rtl") {
                UserQuote()
                }
            Tab("Settings", systemImage: "gear") {
                Settings()
                }
        }
        .environmentObject(FavoriteManager())
        .environmentObject(WordStore())
        .environmentObject(QuoteManager())

    }
}

#Preview {
    ContentView()
        .environmentObject(FavoriteManager())
        .environmentObject(WordStore())
}
