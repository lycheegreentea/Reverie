//
//  SwiftUIView.swift
//  Reverie
//
//  Created by Lauren Chen on 5/22/25.
//

import SwiftUI
let words = loadWords()

var currentWords: [Word] {
    let calendar = Calendar.current
    let todayStart = calendar.startOfDay(for: Date())
    return words.filter { $0.date == todayStart}
}

let calendar = Calendar.current
let todayStart = calendar.startOfDay(for: Date())


struct WordView: View {
    @State private var isStarFilled = false
    var body: some View {
        NavigationView {
            List(currentWords) { word in
                VStack(alignment: .leading) {
                    HStack{
                        Text(word.word)
                            .font(.headline)
                        Spacer()
                        Button {
                            isStarFilled.toggle()
                            print("Apple Button Tapped")
                        } label: {
                            Label("", systemImage: isStarFilled ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
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
            .navigationTitle("The Daily Word")
        }
    }
}

#Preview {
    WordView()
}
