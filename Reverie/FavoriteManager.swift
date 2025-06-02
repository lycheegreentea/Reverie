//
//  FavoriteManager.swift
//  Reverie
//
//  Created by Lauren Chen on 5/25/25.
//

import Foundation

class FavoriteManager:ObservableObject
{
    @Published var favoritedDate: Set<Date> = []
    
    public let key = "favoriteWordDates"
    
    init() {
        loadFavorites()
    }
    
    func toggleFavorite(for word: Word) {
        let dateKey = word.date
        if favoritedDate.contains(dateKey) {
            favoritedDate.remove(dateKey)
            
        } else {
            favoritedDate.insert(dateKey)
        }
        saveFavorites()
    }
    
    func isFavorite(_ word: Word) -> Bool {
        favoritedDate.contains(word.date)
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoritedDate), forKey: key)
    }
    
    private func loadFavorites() {
        if let savedDates = UserDefaults.standard.array(forKey: key) as? [Date] {
            favoritedDate = Set(savedDates)
        }
    }
    
}
