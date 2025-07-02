//
//
//  SwiftUIView.swift
//  Reverie
//
//  Created by Lauren Chen on 5/22/25.
//

import SwiftUI

let calendar = Calendar.current
let todayStart = calendar.startOfDay(for: Date())

struct WordView: View {
    @EnvironmentObject var wordStore: WordStore

    var body: some View {
        NavigationStack{
        VStack {
            Text(wordStore.todaysWord[0].word)
                .font(.largeTitle)
                .fontWeight(.medium)
            
            Text(wordStore.todaysWord[0].partOfSpeech)
                .font(.caption)
            
            Divider()
                .frame(height: 1.5)
                .background(Color.primary)
            
            Text(wordStore.todaysWord[0].definition)
                .font(.body)
            
            Text(wordStore.todaysWord[0].example)
                .font(.caption)
                .italic()
            
            Text(wordStore.todaysWord[0].date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption2)
        }
        .fontDesign(.serif)
        .padding(.horizontal)
        .navigationTitle("Today's word")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                NavigationLink(destination: Settings()) {
                            Image(systemName: "gearshape")
                                .imageScale(.large)
                        }
                .foregroundColor(.primary)
    }
                

                    
            }

                
            }
        }

        

    }

#Preview {
    WordView()
        .environmentObject(WordStore())

}

