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
enum Person: String, CaseIterable, Identifiable {
    case ERoosevelt, Aristotle, Epictetus
    var id: String { self.rawValue }
}

struct Settings: View {
    @AppStorage("chosenPerson") private var selectedPersonRaw: String = Person.Aristotle.rawValue


    @AppStorage("appearance") public var selectedAppearance: Appearance = .system

    

    
    



    private var selectedPerson: Binding<Person> {
        Binding(
            get: { Person(rawValue: selectedPersonRaw) ?? .Aristotle },
            set: { selectedPersonRaw = $0.rawValue }
        )
    }
    var body: some View {
        
        NavigationStack {
            
            
                VStack {
                Text("Quote Person")
                    .font(.title)
                Picker("Select a person", selection: selectedPerson) {
                    ForEach(Person.allCases) { person in
                        Text(person.rawValue).tag(person)
                    }
                }
                
            }
            .padding()
            .pickerStyle(.segmented)
            .fontDesign(.serif)
            
            
            
            VStack {
                Text("Appearance")
                    .font(.title)
                Picker("Appearance", selection: $selectedAppearance) {
                    ForEach(Appearance.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                HStack{
                    Image("Walrus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    Image("Dwane")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                    
                }
            }
            .fontDesign(.serif)
            .navigationBarTitle("Settings")

            
            
            Spacer()
        }
        
    }
    }
#Preview {
    Settings()
}
