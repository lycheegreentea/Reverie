//
//  DataService.swift
//  Reverie
//
//  Created by Lauren Chen on 6/11/25.
//

import Foundation
import SwiftUI
struct DataService {
    var words: [Word] = loadWords()

    var todaysWord: [Word] {
            let today = Calendar.current.startOfDay(for: Date())
            return words.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
        }
}

