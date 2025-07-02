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
                Tab("Archive", systemImage: "books.vertical") {
                    PastWords()
                }
                Tab("Your Words", systemImage: "bubble.and.pencil") {
                    UserWords()
                }
                Tab("Quote", systemImage: "quote.opening") {
                    DailyQuote()
                }
                Tab("Your Quotes", systemImage: "quote.bubble.rtl") {
                    UserQuote()
                }
        }
            .environmentObject(FavoriteManager())
            .environmentObject(WordStore())
            .environmentObject(QuoteManager())
            .environmentObject(userWordManager())
    }
}

#Preview {
    ContentView()
        .environmentObject(FavoriteManager())
        .environmentObject(WordStore())
}
