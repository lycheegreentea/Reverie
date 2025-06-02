//
//  ReverieApp.swift
//  Reverie
//
//  Created by Lauren Chen on 5/22/25.
//

import SwiftUI

@main
struct ReverieApp: App {
    @EnvironmentObject var favoriteManager: FavoriteManager
    @EnvironmentObject var wordStore: WordStore

        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(favoriteManager)
                    .environmentObject(wordStore)
            }
        }
}
