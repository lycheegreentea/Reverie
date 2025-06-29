//
//
//  SwiftUIView.swift
//  Reverie
//
//  Created by Lauren Chen on 5/22/25.
//

import SwiftUI

let calendar = Calendar.current
let todayStart = calendar.startOfDay(for: Date())

struct WordView: View {
    @EnvironmentObject var wordStore: WordStore

    var body: some View {
        NavigationView {
            List(wordStore.todaysWord) { word in
                VStack(alignment: .leading) {
                    HStack{
                        Text(word.word)
                            .font(.headline)
            
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
                }
                .navigationTitle("The Daily Word")

            }

        }

    }

#Preview {
    WordView()
        .environmentObject(WordStore())

}

