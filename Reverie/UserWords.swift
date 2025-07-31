//
//  UserWords.swift
//  Reverie
//
//  Created by Lauren Chen on 7/1/25.
//

import SwiftUI
struct userWordModel: Codable, Identifiable {
    let word: String
    let definition: String
    let date: Date
    let id: UUID
    
    static let sample = userWordModel(
        word: "elysian",
        definition: "relating to or characteristic of heaven or paradise",
        date: Date(),
        id: UUID()
    )
}


struct UserWordView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Binding var refreshTrigger: Bool

    @State private var word = ""
    @State private var definition = ""
    @State private var date = Date()
    var existingWord: UserWord? = nil
    
    var body: some View {
        Form {
            TextField("Word", text: $word)
            TextField("Definition", text: $definition)
            DatePicker("Date", selection: $date, displayedComponents: .date)
            
            Button("Save") {
                if let wordEntry = existingWord {
                    wordEntry.word = word
                    wordEntry.definition = definition
                    wordEntry.date = date
                    
                } else{
                    let newWord = UserWord(context: viewContext)
                    newWord.word = word
                    newWord.definition = definition
                    newWord.date = date
                    newWord.id = UUID()
                    
                }
                do{
                    try viewContext.save()
                    refreshTrigger.toggle()
                    dismiss()
                } catch {
                    print("Error Saving Word: \(error)")
                }
            }
            .fontDesign(.serif)
            
            .onAppear {
                if let word = existingWord {
                    self.word = word.word ?? ""
                    self.definition = word.definition ?? ""
                    self.date = word.date ?? Date()
                }
            }
            .navigationTitle(existingWord == nil ? "Add Word" : "Edit Word")
        }
    }
    
}
    
    
    struct UserWords: View {
        @Environment(\.managedObjectContext) private var viewContext
        @State private var refreshTrigger = false
        
        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \UserWord.date, ascending: false)],
            animation: .default)
        private var userWords: FetchedResults<UserWord>
        
        @State private var searchTerm = ""
        
        @State private var sortByOldest = false
        @State private var sortByNewest = false
        @State private var sortAlphabetical = false
        
        var filteredWords: [UserWord] {
            _ = refreshTrigger

            var filtered = userWords.filter {
                searchTerm.isEmpty ||
                ($0.word?.localizedCaseInsensitiveContains(searchTerm) ?? false) ||
                ($0.definition?.localizedCaseInsensitiveContains(searchTerm) ?? false)
            }

            if sortByOldest {
                filtered.sort { ($0.date ?? Date.distantPast) < ($1.date ?? Date.distantPast) }
            } else if sortByNewest {
                filtered.sort { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) }
            } else if sortAlphabetical {
                filtered.sort { ($0.word ?? "") < ($1.word ?? "") }
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
                        
                        NavigationLink(destination: UserWordView(refreshTrigger: $refreshTrigger)) {
                            Label("Add Word", systemImage: "plus")
                                .foregroundColor(.accentOpposite)
                        }
                        .contentTransition(.opacity)
                        .fontDesign(.serif)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)
                    
                    List {
                        ForEach(filteredWords, id: \.id) { word in
                            NavigationLink(destination: UserWordView(refreshTrigger: $refreshTrigger, existingWord: word)) {
                                VStack(alignment: .leading) {
                                    Text(word.word ?? "")
                                        .font(.headline)
                                    Text(word.definition ?? "")
                                        .font(.subheadline)
                                    Text(word.date?.formatted(date: .abbreviated, time: .omitted) ?? "")
                                        .font(.caption)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.map { filteredWords[$0] }.forEach(viewContext.delete)
                            try? viewContext.save()
                        }
                    }
                    .searchable(text: $searchTerm)
                    .navigationTitle("Your Words")
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
    UserWords()

}

