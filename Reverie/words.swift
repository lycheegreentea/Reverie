//
//  words.swift
//  Reverie
//
//  Created by Lauren Chen on 5/22/25.
//

import Foundation

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

        // Set date decoding strategy to match JSON format
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
