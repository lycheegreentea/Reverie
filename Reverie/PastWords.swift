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
 
   


    var body: some View {
        NavigationView {
            List(wordStore.pastWords) { word in
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
        }
    }

}


#Preview {
    PastWords()
        .environmentObject(FavoriteManager())
        .environmentObject(WordStore())
}
