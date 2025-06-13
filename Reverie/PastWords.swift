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
    
    var filteredWords: [Word] {
        guard !searchTerm.isEmpty else {
            return wordStore.pastWords
        }
        return wordStore.pastWords.filter { $0.word.localizedCaseInsensitiveContains(searchTerm)}
    }
    

    var body: some View {

        let favoritesOnly = wordStore.words.filter(favoriteManager.isFavorite)
        var chooseList: [Word] {
            if(favoritesToggled){
                return favoritesOnly
            }
            else{
                return filteredWords
            }
        }
        NavigationStack {
            Toggle("Favorites", systemImage: "star.fill", isOn: $favoritesToggled)
                .tint(Color.green)
                .toggleStyle(.button)
                //.labelStyle(.iconOnly)
                .contentTransition(.opacity)
            List(filteredWords) { word in
                VStack(alignment: .leading) {
                    HStack{
                        Text(word.word)
                            .font(.headline)
                        
                        Spacer()
                        Button(action: {
                            favoriteManager.toggleFavorite(for: word)
                                    }) {
                                        Image(systemName: favoriteManager.isFavorite(word) ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                    }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    
                    Text(word.partOfSpeech)
                        .font(.subheadline)
                    Text(word.pronunciation)
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
            }
            .navigationTitle("Past Words")
            
            .searchable(text: $searchTerm, prompt: "Search for a word")
            
        }
    }

}


#Preview {
    PastWords()
        .environmentObject(FavoriteManager())
        .environmentObject(WordStore())
}
