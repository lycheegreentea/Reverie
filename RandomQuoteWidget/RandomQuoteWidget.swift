//
//  RandomQuoteWidget.swift
//  RandomQuoteWidget
//
//  Created by Lauren Chen on 6/26/25.
//

import WidgetKit
import SwiftUI

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quoteText: String
    let quoteAuthor: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(date: Date(), quoteText: "Loading...", quoteAuthor: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> ()) {
        let entry = loadQuoteEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> ()) {
        let entry = loadQuoteEntry()
        // Refresh daily
        let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func loadQuoteEntry() -> QuoteEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.reverie")
        let quote = sharedDefaults?.string(forKey: "quoteText") ?? "No quote available"
        let author = sharedDefaults?.string(forKey: "quoteAuthor") ?? ""
        return QuoteEntry(date: Date(), quoteText: quote, quoteAuthor: author)
    }
}


struct RandomQuoteWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.quoteText)
                .font(.headline)
                .padding(.bottom, 2)
            Text("- " + entry.quoteAuthor)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}


    


#Preview(as: .systemMedium) {
    RandomQuoteWidget()
} timeline: {
    QuoteEntry(date: Date(), quoteText: "Be yourself; everyone else is already taken.", quoteAuthor: "Oscar Wilde")
    QuoteEntry(date: Date().addingTimeInterval(3600), quoteText: "The only thing we have to fear is fear itself.", quoteAuthor: "Franklin D. Roosevelt")
}
