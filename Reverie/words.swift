//
//  words.swift
//  Reverie
//
//  Created by Lauren Chen on 5/22/25.
//

import Foundation
import SwiftUICore


struct Word: Codable, Identifiable {
    var id: Date { date }
    let date: Date
    let word: String
    let partOfSpeech: String
    let pronunciation: String
    let definition: String
    let example: String




}

func loadWords() -> [Word] {
    guard let url = Bundle.main.url(forResource: "words", withExtension: "json") else {
        print("Failed to locate words.json")
        return []
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)

        let words = try decoder.decode([Word].self, from: data)
        return words
    } catch {
        print("Failed to decode words.json: \(error)")
        return []
    }
}


class WordStore: ObservableObject {
    @Published var words: [Word] = loadWords()



    
    var pastWords: [Word] {
        let now = Date()
        return words.filter { $0.date < now }
    }
    
    var todaysWord: [Word] {
            let today = Calendar.current.startOfDay(for: Date())
            return words.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
        }


        

        }
    

    

