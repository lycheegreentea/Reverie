//
//  WordWidgetExtension.swift
//  WordWidgetExtension
//
//  Created by Lauren Chen on 6/5/25.
//

import WidgetKit
import SwiftUI
import WidgetKit
import SwiftUI

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quoteText: String
    let quoteAuthor: String
}

struct QuoteProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(date: Date(), quoteText: "Loading...", quoteAuthor: "")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> ()) {
        let entry = loadQuoteEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> ()) {
        let entry = loadQuoteEntry()
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func loadQuoteEntry() -> QuoteEntry {

        let sharedDefaults = UserDefaults(suiteName: "group.com.lauren.reverie")
        let quote = sharedDefaults?.string(forKey: "quoteText") ?? "No quote available"
        let author = sharedDefaults?.string(forKey: "quoteAuthor") ?? ""
        print("Loaded quote from UserDefaults: \(quote) - \(author)")
        return QuoteEntry(date: Date(), quoteText: quote, quoteAuthor: author)
    }
}

struct RandomQuoteWidgetEntryView: View {
    var entry: QuoteProvider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.quoteText)
                .font(.headline)
                .padding(.bottom, 2)
            Text("- \(entry.quoteAuthor)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct RandomQuoteWidget: Widget {
    let kind = "RandomQuoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteProvider()) { entry in
            RandomQuoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Random Quote")
        .description("Shows a random quote.")
        .supportedFamilies([.systemMedium])
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let streak: [Word]
}

struct WordProvider: TimelineProvider {
    let data = DataService()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), streak: data.todaysWord)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date(), streak: data.todaysWord))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let currentDate = Date()
        let entries = (0..<5).map { offset in
            SimpleEntry(
                date: Calendar.current.date(byAdding: .hour, value: offset, to: currentDate)!,
                streak: data.todaysWord
            )
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct WordWidgetExtensionEntryView: View {
    var entry: WordProvider.Entry
    let word: Word? = DataService().todaysWord.first

    var body: some View {
        VStack(alignment: .leading) {
            if let word = word {
                Text(word.word)
                    .font(.title2)
                Text(word.partOfSpeech)
                    .font(.subheadline)
                Text(word.pronunciation)
                    .font(.subheadline)
                Text(word.definition)
                    .font(.body)
                Text(word.example)
                    .font(.caption)
                    .italic()
                Text(word.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundColor(.gray)
            } else {
                Text("No word available")
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct WordWidgetExtension: Widget {
    let kind = "WordWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WordProvider()) { entry in
            WordWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Word")
        .description("Displays the SAT word of the day.")
        .supportedFamilies([.systemMedium])
    }
}
//random user quote
struct UserQuote: Codable, TimelineEntry {
    let quote: String
    let author: String
    let date: Date
    let id: UUID
}

struct UserQuoteProvider: TimelineProvider {
    let data = DataService()

    func placeholder(in context: Context) -> UserQuote {
        UserQuote(quote: "The best way to predict the future is to create it", author: "Abraham Lincoln" , date: Date() , id: UUID())
    }

    func getSnapshot(in context: Context, completion: @escaping (UserQuote) -> Void) {
        completion(loadRandomQuote())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<UserQuote>) -> ()) {
        let entry = loadRandomQuote()
                let nextUpdate = Calendar.current.date(byAdding: .hour, value: 6, to: Date())!
                    let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}
private func loadRandomQuote() -> UserQuote {
    let defaults = UserDefaults(suiteName: "group.com.lauren.reverie")
    if let data = defaults?.data(forKey: "userQuotes"),
       let quotes = try? JSONDecoder().decode([UserQuote].self, from: data),
       let random = quotes.randomElement() {
        return UserQuote(quote: random.quote, author: random.author, date: random.date, id: UUID())
    } else {
        return UserQuote(quote:"No saved quotes" , author: "", date: Date(), id: UUID())
    }
}
    struct UserQuoteWidgetEntryView: View {
        var entry: UserQuoteProvider.Entry

        var body: some View {
            VStack(alignment: .leading) {
                Text(entry.quote)
                    .font(.headline)
                    .padding(.bottom, 2)
                Text("- \(entry.author)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .containerBackground(.fill.tertiary, for: .widget)
        }
    }
    

    struct UserQuoteWidget: Widget {
        let kind: String = "UserQuoteWidget"

        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: UserQuoteProvider()) { entry in
                UserQuoteWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("Your Saved Quotes")
            .description("Shows a random saved quote.")
            .supportedFamilies([.systemMedium])
        }
    }
#Preview(as: .systemMedium) {
    RandomQuoteWidget()
} timeline: {
    QuoteEntry(date: .now, quoteText: "Courage is grace under pressure.", quoteAuthor: "Ernest Hemingway")
}

#Preview(as: .systemMedium) {
    WordWidgetExtension()
} timeline: {
    let data = DataService()
    SimpleEntry(date: .now, streak: data.todaysWord)
}
