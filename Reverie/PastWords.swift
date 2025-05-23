//
//  PastWords.swift
//  Reverie
//
//  Created by Lauren Chen on 5/22/25.
//

import SwiftUI

import SwiftUI

struct PastWords: View {
    @State private var words: [Word] = loadWords()

   
    var pastWords: [Word] {
        let now = Date()
        return words.filter { $0.date < now }
    }

    var body: some View {
        NavigationView {
            List(pastWords) { word in
                VStack(alignment: .leading) {
                    Text(word.word)
                        .font(.headline)
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
}
