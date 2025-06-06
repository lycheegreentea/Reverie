//
//  Settings.swift
//  Reverie
//
//  Created by Lauren Chen on 6/4/25.
//

import SwiftUI
enum Appearance: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var id: String { self.rawValue }
}

struct Settings: View {
    @AppStorage("appearance") private var selectedAppearance: Appearance = .system
        
        var colorScheme: ColorScheme? {
            switch selectedAppearance {
            case .light:
                return .light
            case .dark:
                return .dark
            case .system:
                return nil
            }
        }
        
        var body: some View {
            
            
            VStack {
                Spacer()
                Text("Settings")
                    .font(.title)
                Picker("Appearance", selection: $selectedAppearance) {
                    ForEach(Appearance.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()
            }
            .preferredColorScheme(colorScheme)
        }

        
}

#Preview {
    Settings()
}
