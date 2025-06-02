//
//  GeneralWord.swift
//  Reverie
//
//  Created by Lauren Chen on 5/24/25.
//

import SwiftUI

struct WordRow: View {
    @Binding var word: Word
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(word.word)
                    .font(.headline)
                Spacer()

            }

            Text(word.partOfSpeech)
            Text(word.pronunciation)
            Text(word.definition)
            Text(word.example).italic()
            Text(word.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(4)
    }
}
