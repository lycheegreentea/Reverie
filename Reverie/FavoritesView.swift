//
//  FavoritesView.swift
//  Reverie
//
//  Created by Lauren Chen on 6/5/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoriteManager: FavoriteManager
    @EnvironmentObject var wordStore: WordStore

    var body: some View {
        let filteredWords = wordStore.words.filter(favoriteManager.isFavorite)

        NavigationView {
            if filteredWords.isEmpty {
                VStack {
                    Spacer()
                    Text("There are no favorited words yet")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
                .navigationTitle("Favorite Words")
            } else {
                List(filteredWords) { word in
                    VStack(alignment: .leading) {
                        HStack {
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
                .navigationTitle("Favorite Words")
            }
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(WordStore())
        .environmentObject(FavoriteManager())


}

