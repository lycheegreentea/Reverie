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
    @AppStorage("appearance") private var selectedAppearance: Appearance = .system
    let persistenceController = PersistenceController.shared


    var body: some Scene {
        
        WindowGroup {
                
                
                ContentView()
                   
                
                
            
            .preferredColorScheme(colorScheme(for: selectedAppearance))
            .environmentObject(favoriteManager)
            .environmentObject(wordStore)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
        
    }
    private func colorScheme(for appearance: Appearance) -> ColorScheme? {
        switch appearance {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
        
}

