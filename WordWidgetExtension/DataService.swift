//
//  DataService.swift
//  Reverie
//
//  Created by Lauren Chen on 6/11/25.
//

import Foundation
import SwiftUI
struct DataService {
    @AppStorage("quote", store: UserDefaults(suiteName: "group.com.laurencechen.Reverie"))
    private var streak = 0
    func log() {
        streak += 1
    }
    func progress() -> Int {
        return streak
    }
}
