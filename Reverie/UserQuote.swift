//
//  UserQuote.swift
//  Reverie
//
//  Created by Lauren Chen on 6/26/25.
//

import SwiftUI
struct UserQuoteModel: Codable, Identifiable {
    let quote: String
    let author: String
    let date: Date
    let id: UUID
}
class QuoteManager: ObservableObject {
    @Published var savedQuotes: [UserQuoteModel] = []
    private let suiteName = "group.com.lauren.reverie"
    private var userDefaults: UserDefaults? {
        UserDefaults(suiteName: suiteName)
    }

    private let saveKey = "userQuotes"

    init() {
        loadQuotes()
    }

    func addQuote(_ quote: UserQuoteModel) {
        savedQuotes.append(quote)
        saveQuotes()
    }

    private func saveQuotes() {
        if let data = try? JSONEncoder().encode(savedQuotes) {
            userDefaults?.set(data, forKey: saveKey)
        }
    }

    private func loadQuotes() {
        if let data = userDefaults?.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([UserQuoteModel].self, from: data) {
            savedQuotes = decoded
        }
    }
    func updateQuote(_ updated: UserQuoteModel) {
        if let index = savedQuotes.firstIndex(where: { $0.id == updated.id }) {
            savedQuotes[index] = updated
            saveQuotes()
        }
    }
    func deleteQuotes(at offsets: IndexSet) {
        savedQuotes.remove(atOffsets: offsets)
        saveQuotes()
    }
}

struct DetailView: View {
    @State private var quote: String = ""
    @State private var author: String = ""
    @State private var date: Date = Date()
    @State private var id: UUID = UUID()

    var existingQuote: UserQuoteModel? = nil

    
    @EnvironmentObject var manager: QuoteManager
    @Environment(\.dismiss) var dismiss


    var body: some View {
        Form {
            TextField(
                    "Enter quote",
                    text: $quote
                )
            TextField(
                    "Enter Author",
                    text: $author
                )
            DatePicker(selection: $date, displayedComponents: .date,  label: { Text("Date") }, )
                .datePickerStyle(.automatic)
            Button("Save") {
                let updatedQuote = UserQuoteModel(quote: quote, author: author, date: date, id: id)

                if existingQuote == nil {
                    manager.addQuote(updatedQuote)
                                } else {
                                    manager.updateQuote(updatedQuote)
                                }
                dismiss()
            }
                

        }
        .navigationTitle(existingQuote == nil ? "Add a quote" : "Edit quote")
                .onAppear {
                    if let existing = existingQuote {
                        quote = existing.quote
                        author = existing.author
                        date = existing.date
                        id = existing.id
                    }
                }
        
        Spacer()
        
    }
}

struct UserQuote: View {
    @EnvironmentObject var manager: QuoteManager
    @State private var searchTerm = ""
    var searchQuotes: [UserQuoteModel] {
        guard !searchTerm.isEmpty else {
            return manager.savedQuotes
        }
        return manager.savedQuotes.filter { quote in  quote.quote.localizedCaseInsensitiveContains(searchTerm) ||
            quote.author.localizedCaseInsensitiveContains(searchTerm)
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack{
                NavigationLink(destination: DetailView().environmentObject(manager)) {
                    Label("Add a quote", systemImage: "plus")
                }
                
                
                List {
                    
                    ForEach(searchQuotes) { quote in
                        NavigationLink(
                            destination: DetailView(existingQuote: quote).environmentObject(manager)
                        ) {
                            
                            VStack(alignment: .leading) {
                                Text(quote.quote).font(.headline)
                                Text("- \(quote.author)").font(.subheadline)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        manager.deleteQuotes(at: indexSet)
                    }
                }
                
                        
                .navigationBarTitle("Your Quotes")
                .searchable(text: $searchTerm, prompt: "Search for a word")
            }
            
        }
    }
}


#Preview {
    UserQuote()
        .environmentObject(QuoteManager())

}
