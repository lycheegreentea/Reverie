//
//  QuoteDataService.swift
//  Reverie
//
//  Created by Lauren Chen on 6/26/25.
//

import Foundation
 
 class QuoteData: ObservableObject {
 @Published var quotes: [Quote] = QuoteLoader.loadQuotes()
 @AppStorage("chosenPerson") private var selectedPersonRaw: String = Person.Aristotle.rawValue
 }
 struct QuoteDataService {
 
     let aristotleQuotes = QuoteData.filter { $0.author == "Aristotle" }
     let ERooseveltQuotes = quotes.filter { $0.author == "Eleanor Roosevelt" }
     let EpictetusQuotes = quotes.filter { $0.author == "Epictetus" }
     func randomizeQuote() -> [Quote] {
     if selectedPersonRaw == "Aristotle" {
     return(aristotleQuotes)
     }
     if selectedPersonRaw == "ERoosevelt" {
     return(ERooseveltQuotes)
     } else {
     return(EpictetusQuotes)
 }
 }
 
 var selectedQuote = randomizeQuote().randomElement()
 
 
 }


