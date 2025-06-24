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
        guard let url = Bundle.main.url(forResource: "Quotes", withExtension: "json") else {
            print("quotes.json not found.")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let quotes = try JSONDecoder().decode([Quote].self, from: data)
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


class QuoteFilter{
    
}

struct DailyQuote: View {
    private var quoteViewer = QuoteView()
    @State private var selectedQuote: Quote? = nil

    
    var body: some View {
        NavigationView {
            
                if let quote = selectedQuote {
                    VStack(alignment: .leading) {
                        VStack{
                            Text(quote.quote)
                                .font(.headline)
                            Text(quote.author)
                                .font(.subheadline)
                            
                        
                        
                    }
                }
                    
            }
            
            }
        .navigationTitle("The Daily Word")
        .onAppear {
            let aristotleQuotes = quoteViewer.quotes.filter { $0.author == "Aristotle" }
            selectedQuote = aristotleQuotes.randomElement()

        }
        
    }
}

#Preview {
    DailyQuote()
}
