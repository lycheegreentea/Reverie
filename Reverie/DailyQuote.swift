//
//  DailyQuote.swift
//  Reverie
//
//  Created by Lauren Chen on 6/11/25.
//

import SwiftUI

struct Quote: Codable, Identifiable {
    let quote: String
    let author: String
    var id: String { quote }

}

class QuoteLoader {
    static func loadQuotes() -> [Quote] {
        print("🔍 Attempting to load Quotes.json...")
        guard let url = Bundle.main.url(forResource: "Quotes", withExtension: "json") else {
            print("quotes.json not found.")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let quotes = try JSONDecoder().decode([Quote].self, from: data)
            print("Loaded \(quotes.count) quotes.")
            return quotes
        } catch {
            print("Failed to decode quotes: \(error)")
            return []
        }
    }
}
class QuoteView: ObservableObject {
    @Published var quotes: [Quote] = QuoteLoader.loadQuotes()
}

struct DailyQuote: View {
    @StateObject private var quoteViewer = QuoteView()
    init() {
        print("📦 DailyQuote view initialized")
    }
    var body: some View {
        NavigationView {
            List(quoteViewer.quotes) { quote in
                VStack(alignment: .leading) {
                    HStack{
                        Text(quote.quote)
                            .font(.headline)
                        
                    }
                    
                }
            }
            .navigationTitle("The Daily Word")

        }
    }
}

#Preview {
    DailyQuote()
}
