//
//  ReverieApp.swift
//  Reverie
//
//  Created by Lauren Chen on 5/22/25.
//
import SwiftUI
@main
struct ReverieApp: App {
    @StateObject private var favoriteManager = FavoriteManager()
    @StateObject private var wordStore = WordStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoriteManager)
                .environmentObject(wordStore)
        }
        
    }
}

