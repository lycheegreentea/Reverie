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
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func loadQuotes() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([UserQuoteModel].self, from: data) {
            savedQuotes = decoded
        }
    }
}

struct DetailView: View {
    @State private var quote: String = ""
    @State private var author: String = ""
    @State private var date: Date = Date()
    @State private var id: UUID = UUID()


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
                let newQuote = UserQuoteModel(quote: quote, author: author, date: date, id:id)
                manager.addQuote(newQuote)
                dismiss()
            }
                

        }
        .navigationBarTitle("Add a quote")
        
        Spacer()
        
    }
}

struct UserQuote: View {
    @EnvironmentObject var manager: QuoteManager

    var body: some View {
        
        NavigationView {
            VStack{
                NavigationLink(destination: DetailView()) { Image(systemName: "plus") }
                    .environmentObject(manager)
                
                List {
                    ForEach(manager.savedQuotes) { quote in
                        VStack(alignment: .leading) {
                            Text(quote.quote).font(.headline)
                            Text("- \(quote.author)").font(.subheadline)
                            Text(quote.date, style: .date)
                        }
                    }
                }
                
                .navigationBarTitle("User Quotes")
                
            }
        }
        
        }
    }


#Preview {
    UserQuote()
        .environmentObject(QuoteManager())

}
