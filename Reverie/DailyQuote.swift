//
//  DailyQuote.swift
//  Reverie
//
//  Created by Lauren Chen on 6/11/25.
//

import SwiftUI

struct DailyQuote: View {
    @AppStorage("TEST", store: UserDefaults(suiteName: "group.com.laurencechen.Reverie")!) var widgetWord = 0
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DailyQuote()
}
