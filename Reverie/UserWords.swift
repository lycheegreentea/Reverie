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
class userWordManager: ObservableObject {
    @Published var savedUserWords: [userWordModel] = []
    private let suiteName = "group.net.lauren.quotecabulary"
    private var userDefaults: UserDefaults? {
        UserDefaults(suiteName: suiteName)
    }

    private let saveKey = "userWords"
    
    init() {
        loadWords()
    }

    func addUserWord(_ word: userWordModel) {
        savedUserWords.append(word)
        saveUserWord()
    }

    private func saveUserWord() {
        if let data = try? JSONEncoder().encode(savedUserWords) {
            userDefaults?.set(data, forKey: saveKey)
        }
    }

    private func loadWords() {
        if let data = userDefaults?.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([userWordModel].self, from: data) {
            savedUserWords = decoded
        }
    }
    func updateWord(_ updated: userWordModel) {
        if let index = savedUserWords.firstIndex(where: { $0.id == updated.id }) {
            savedUserWords[index] = updated
            saveUserWord()
        }
    }
    func deleteUserWords(at offsets: IndexSet) {
        savedUserWords.remove(atOffsets: offsets)
        saveUserWord()
    }
}

struct UserWordView: View {
    @State private var word: String = ""
    @State private var definition: String = ""
    @State private var date: Date = Date()
    @State private var id: UUID = UUID()
    

    var existingWord: userWordModel? = nil

    
    @EnvironmentObject var manager: userWordManager
    @Environment(\.dismiss) var dismiss


    var body: some View {
        Form {
            TextField(
                    "Enter word",
                    text: $word
                )
            TextField(
                    "Enter definition in your own words",
                    text: $definition
                )
            
            DatePicker(selection: $date, displayedComponents: .date,  label: { Text("Date") }, )
                .datePickerStyle(.automatic)
            Button("Save") {
                let updatedWord = userWordModel(word: word, definition: definition, date: date, id: id)

                if existingWord == nil {
                    manager.addUserWord(updatedWord)
                                } else {
                                    manager.updateWord(updatedWord)
                                }
                dismiss()
            }
                

        }
        .navigationTitle(existingWord == nil ? "Add a word" : "Edit word")
                .onAppear {
                    if let existing = existingWord {
                        word = existing.word
                        definition = existing.definition
                        date = existing.date
                        id = existing.id
                    }
                }
        
        Spacer()
        
    }
}

struct UserWords: View {
    @EnvironmentObject var manager: userWordManager
    @State private var searchTerm = ""
    @State var oldest: Bool = false
    @State var newest: Bool = false
    @State var alphabetical: Bool = false
    var searchUserWords: [userWordModel] {
        guard !searchTerm.isEmpty else {
            return manager.savedUserWords
        }
        return manager.savedUserWords.filter { word in  word.word.localizedCaseInsensitiveContains(searchTerm) ||
            word.definition.localizedCaseInsensitiveContains(searchTerm)
        }
    }

    
    var currentWords: [userWordModel] {
        if(oldest == true){
            return searchUserWords.sorted { $0.date < $1.date }
        }
        else if(newest == true){
            return searchUserWords.sorted { $0.date > $1.date }
        }
        else if(alphabetical==true){
            return searchUserWords.sorted { $1.word > $0.word }
        }
        else {
            return searchUserWords
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Menu("Sort by") {
                        Button{
                                oldest = true
                                newest = false
                                alphabetical = false
                        } label: {
                            Label("oldest", systemImage: "plus")
                            
                        }
                        Button{
                                newest = true
                                oldest = false
                                alphabetical = false
                        } label: {
                            Label("newest", systemImage: "plus")
                        }
                        Button{
                                alphabetical = true
                                newest = false
                                oldest = false
                        } label: {
                            Label("alphabetical", systemImage: "plus")
                        }
                    }
                    .contentTransition(.opacity)
                    .fontDesign(.serif)
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.accentOpposite)

                    NavigationLink(destination: UserWordView().environmentObject(manager)) {
                        Label("Add a word", systemImage: "plus")
                            .foregroundColor(.accentOpposite)

                    }
                    .contentTransition(.opacity)
                    
                    .fontDesign(.serif)
                    .buttonStyle(.borderedProminent)
                }
                
                
                List {
                    
                    ForEach(currentWords) { word in
                        NavigationLink(
                            destination: UserWordView(existingWord: word).environmentObject(manager)
                        ) {
                            
                            VStack(alignment: .leading) {
                                Text(word.word).font(.headline)
                                Text(word.definition).font(.subheadline)
                                
                                Text(word.date.formatted(date: .abbreviated, time: .omitted))
                                
                            }
                        }
                    }
                    .onDelete { indexSet in
                        manager.deleteUserWords(at: indexSet)
                    }
                }
                .fontDesign(.serif)

                .searchable(text: $searchTerm, prompt: "Search for a word")
                .navigationTitle("Your Words")

                .toolbar {
                    ToolbarItem(placement: .topBarTrailing){
                        NavigationLink(destination: Settings()) {
                                    Image(systemName: "gearshape")
                                        .imageScale(.large)
                                }
                        .foregroundColor(.primary)

                    }
            }


            }
            
        }
    }
}


#Preview {
    UserWords()
        .environmentObject(userWordManager())

}

