//
//  UserQuote.swift
//  Reverie
//
//  Created by Lauren Chen on 6/26/25.
//

import SwiftUI
import CoreData
struct UserQuoteModel: Codable, Identifiable {
    let quote: String
    let author: String
    let date: Date
    let id: UUID
    
    static let sample = UserQuoteModel(
        quote: "A very spectacular quote!",
        author: "me",
        date: Date(),
        id: UUID()
    )
}

struct UserQuoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Binding var refreshTrigger: Bool

    
    @State private var quote = ""
    @State private var author = ""
    @State private var date = Date()
    
    var existingQuote: UserQuote? = nil

    
    var body: some View {
        Form {
            TextField("Quote", text: $quote)
            TextField("Author", text: $author)
            DatePicker("Date", selection: $date, displayedComponents: .date)
            
            Button("Save") {
                if let quoteEntry = existingQuote {
                    quoteEntry.quote = quote
                    quoteEntry.author = author
                    quoteEntry.date = date
                    
                } else{
                    let newQuote = UserQuote(context: viewContext)
                    newQuote.quote = quote
                    newQuote.author = author
                    newQuote.date = date
                    newQuote.id = UUID()
                    
                }
                do{
                    try viewContext.save()
                    refreshTrigger.toggle()
                    dismiss()
                } catch {
                    print("Error Saving Quote: \(error)")
                }
            }
            .fontDesign(.serif)
            
            .onAppear {
                if let quote = existingQuote {
                    self.quote = quote.quote ?? ""
                    self.author = quote.author ?? ""
                    self.date = quote.date ?? Date()
                }
            }
            .navigationTitle(existingQuote == nil ? "Add Quote" : "Edit Quote")
        }
    }
    
}
    
    
    struct UserQuotes: View {
        @Environment(\.managedObjectContext) private var viewContext
        @State private var refreshTrigger = false

        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \UserQuote.date, ascending: false)],
            animation: .default)
        private var userQuotes: FetchedResults<UserQuote>

        @State private var searchTerm = ""
        
        @State private var sortByOldest = false
        @State private var sortByNewest = false
        @State private var sortAlphabetical = false
        
        var filteredQuotes: [UserQuote] {
            _ = refreshTrigger

            var filtered = userQuotes.filter {
                searchTerm.isEmpty ||
                ($0.quote?.localizedCaseInsensitiveContains(searchTerm) ?? false) ||
                ($0.author?.localizedCaseInsensitiveContains(searchTerm) ?? false)
            }

            if sortByOldest {
                filtered.sort { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
            } else if sortByNewest {
                filtered.sort { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) }
            } else if sortAlphabetical {
                filtered.sort { ($0.quote ?? "") < ($1.quote ?? "") }
            }

            return filtered
        }
        
        var body: some View {
            NavigationStack {
                VStack {
                    HStack {
                        Menu("Sort by") {
                            Button {
                                sortByOldest = true
                                sortByNewest = false
                                sortAlphabetical = false
                            } label: {
                                Label("Oldest", systemImage: "clock.arrow.circlepath")
                            }
                            
                            Button {
                                sortByOldest = false
                                sortByNewest = true
                                sortAlphabetical = false
                            } label: {
                                Label("Newest", systemImage: "clock")
                            }
                            
                            Button {
                                sortByOldest = false
                                sortByNewest = false
                                sortAlphabetical = true
                            } label: {
                                Label("Alphabetical", systemImage: "textformat.abc")
                            }
                        }
                        .contentTransition(.opacity)
                        .fontDesign(.serif)
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.accentOpposite)
                        
                        NavigationLink(destination: UserQuoteView(refreshTrigger: $refreshTrigger)) {
                            Label("Add Quote", systemImage: "plus")
                                .foregroundColor(.accentOpposite)
                        }
                        .contentTransition(.opacity)
                        .fontDesign(.serif)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)
                    
                    List {
                        ForEach(filteredQuotes, id: \.id) { quote in
                            NavigationLink(destination: UserQuoteView(refreshTrigger: $refreshTrigger, existingQuote: quote)) {
                                VStack(alignment: .leading) {
                                    Text(quote.quote ?? "")
                                        .font(.headline)
                                    Text(quote.author ?? "")
                                        .font(.subheadline)
                                    Text(quote.date?.formatted(date: .abbreviated, time: .omitted) ?? "")
                                        .font(.caption)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.map { filteredQuotes[$0] }.forEach(viewContext.delete)
                            try? viewContext.save()
                        }
                    }
                    .searchable(text: $searchTerm)
                    .navigationTitle("Your Quotes")
                    .fontDesign(.serif)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink(destination: Settings()) {
                                Image(systemName: "gearshape")
                                    .imageScale(.large)
                            }
                        }
                    }
                }
            }
        }
    }
    


#Preview {
    UserQuotes()

}
