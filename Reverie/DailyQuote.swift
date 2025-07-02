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

struct DailyQuote: View {
    private var quoteViewer = QuoteView()
    @AppStorage("chosenPerson") private var selectedPersonRaw: String = Person.Aristotle.rawValue

    @State private var selectedQuote: Quote? = nil
    @State var oldest: Bool = false
    @State var newest: Bool = false
    @State var alphabetical: Bool = false
    var selectedAuthor: [Quote]? = nil
    
    var body: some View {
        NavigationView {
                
            if let quote = selectedQuote {
                    VStack(alignment: .leading) {
                        VStack{
                            Text(quote.quote)
                                .font(.headline)
                            Text(quote.author)
                                .font(.subheadline)
                            Image("sun")
                    }
                        .fontDesign(.serif)
                        .padding(.horizontal)
                        
                }
                    .navigationTitle("A quote for you")

            }
            
            }
        .onAppear {
            let aristotleQuotes = quoteViewer.quotes.filter { $0.author == "Aristotle" }
            let ERooseveltQuotes = quoteViewer.quotes.filter { $0.author == "Eleanor Roosevelt" }
            let EpictetusQuotes = quoteViewer.quotes.filter { $0.author == "Epictetus" }
            func randomizeQuote() -> [Quote] {
                if selectedPersonRaw == "Aristotle" {
                    return(aristotleQuotes)
                }
                if selectedPersonRaw == "ERoosevelt" {

                    return(ERooseveltQuotes)
                } else {
                    return(EpictetusQuotes)
                }
            }
            
            selectedQuote = randomizeQuote().randomElement()
            let sharedDefaults = UserDefaults(suiteName: "group.com.lauren.reverie")
            sharedDefaults?.set(selectedQuote?.quote, forKey: "quoteText")
            sharedDefaults?.set(selectedQuote?.author, forKey: "quoteAuthor")
            
            


        }
            }
}

#Preview {
    DailyQuote()
}
