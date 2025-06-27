//
//  RandomQuoteWidgetBundle.swift
//  RandomQuoteWidget
//
//  Created by Lauren Chen on 6/26/25.
//

import WidgetKit
import SwiftUI

@main
struct RandomQuoteWidget: Widget {
    let kind: String = "RandomQuoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RandomQuoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Quote")
        .description("Shows your daily selected quote.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

