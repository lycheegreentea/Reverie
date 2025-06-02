//
//  FavoriteManager.swift
//  Reverie
//
//  Created by Lauren Chen on 5/25/25.
//
import Foundation
import Combine

class FavoriteManager: ObservableObject {
    @Published private(set) var favoritedDates: Set<Date> = []

    private let userDefaultsKey = "favoriteWordDates"

    init() {
        loadFavorites()
    }

    func toggleFavorite(for word: Word) {
        let date = word.date

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.favoritedDates.contains(date) {
                self.favoritedDates.remove(date)
            } else {
                self.favoritedDates.insert(date)
            }
            
            self.saveFavorites()
            print("Favorites toggled: \(self.favoritedDates)")
        }
    }

    func isFavorite(_ word: Word) -> Bool {
        favoritedDates.contains(word.date)
    }

    private func saveFavorites() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Array(favoritedDates)) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    private func loadFavorites() {
        if
            let data = UserDefaults.standard.data(forKey: userDefaultsKey),
            let decodedDates = try? JSONDecoder().decode([Date].self, from: data)
        {
            DispatchQueue.main.async { [weak self] in
                self?.favoritedDates = Set(decodedDates)
            }
        }
    }
}
