//
//  ContentView.swift
//  Reverie
//
//  Created by Lauren Chen on 5/22/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Word", systemImage: "tray.and.arrow.down.fill") {
                    WordView()
                }
            Tab("Past Words", systemImage: "tray.and.arrow.down.fill") {
                    PastWords()
                }
            Tab("Origins", systemImage: "tray.and.arrow.down.fill") {
                    PastWords()
                }
            Tab("Settings", systemImage: "tray.and.arrow.down.fill") {
                    PastWords()
                }
        }
    }
}

#Preview {
    ContentView()
}
