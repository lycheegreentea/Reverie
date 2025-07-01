//
//  PastWords.swift
//  Reverie
//
//  Created by Lauren Chen on 5/22/25.
//
import SwiftUI

import SwiftUI
struct PastWords: View {
    @EnvironmentObject var favoriteManager: FavoriteManager
    @EnvironmentObject var wordStore: WordStore
    @State private var searchTerm = ""
    @State private var favoritesToggled = true
    @State var oldest: Bool = false
    @State var newest: Bool = false
    @State var alphabetical: Bool = false

    var onlyFavorites: [Word] {
        if(favoritesToggled){
            return(wordStore.words.filter(favoriteManager.isFavorite))
        }
        else{
            return(wordStore.pastWords)
        }
    }
    var searchWords: [Word] {
        guard !searchTerm.isEmpty else {
            return onlyFavorites
        }
        return onlyFavorites.filter { $0.word.localizedCaseInsensitiveContains(searchTerm)}
    }
    var currentWords: [Word] {
        if(oldest == true){
            return searchWords.sorted { $0.date < $1.date }
        }
        else if(newest == true){
            return searchWords.sorted { $0.date > $1.date }
        }
        else if(alphabetical==true){
            return searchWords.sorted { $1.word > $0.word }
        }
        else{
            return searchWords
        }
    }
    
    var body: some View {
        
        NavigationStack {
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

                    Toggle(isOn: $favoritesToggled) {
                        Label("Favorites", systemImage: "star.fill")
                            .foregroundColor(favoritesToggled ? .accentOpposite : .primary)

                    }
                        .toggleStyle(.button)

                        .contentTransition(.opacity)
                        .fontDesign(.serif)
                        .buttonStyle(.borderedProminent)
                    

                }
                    List(currentWords) { word in
                        VStack(alignment: .leading) {
                            HStack{
                                Text(word.word)
                                    .font(.headline)
                                
                                Spacer()
                                Button(action: {
                                    favoriteManager.toggleFavorite(for: word)
                                }) {
                                    Image(systemName: favoriteManager.isFavorite(word) ? "star.fill" : "star")
                                        .foregroundColor(.primary)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            
                            Text(word.partOfSpeech)
                                .font(.subheadline)
                            
                            Text(word.definition)
                                .font(.body)
                            Text(word.example)
                                .font(.caption)
                                .italic()
                            Text(word.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        
                        .padding(4)
                        .fontDesign(.serif)

                    }
                    .searchable(text: $searchTerm, prompt: "Search for a word")
                    .scrollContentBackground(.hidden)
                    .navigationTitle("The Archive")
                    .background(Color(.systemGray6))

                    
                }
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


#Preview {
    PastWords()
        .environmentObject(FavoriteManager())
        .environmentObject(WordStore())
}
