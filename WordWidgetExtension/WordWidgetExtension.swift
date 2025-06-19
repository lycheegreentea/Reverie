//
//  WordWidgetExtension.swift
//  WordWidgetExtension
//
//  Created by Lauren Chen on 6/5/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let data = DataService()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), streak: data.todaysWord)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), streak: data.todaysWord)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, streak: data.todaysWord)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let streak: [Word]
}

struct WordWidgetExtensionEntryView : View {
    let data = DataService()
    
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading) {
                if let firstWord = data.todaysWord.first {
                    Text(firstWord.word)
                    Text(data.todaysWord[0].partOfSpeech)
                        .font(.subheadline)
                    Text(data.todaysWord[0].pronunciation)
                        .font(.subheadline)
                    Text(data.todaysWord[0].definition)
                        .font(.body)
                    Text(data.todaysWord[0].example)
                        .font(.caption)
                        .italic()
                    Text(data.todaysWord[0].date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                } else {
                    Text("No word available")
                }
                
                
                
            }
        }
    }
}
    
    struct WordWidgetExtension: Widget {
        let kind: String = "WordWidgetExtension"
        
        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                if #available(iOS 17.0, *) {
                    WordWidgetExtensionEntryView(entry: entry)
                        .containerBackground(.fill.tertiary, for: .widget)
                } else {
                    WordWidgetExtensionEntryView(entry: entry)
                        .padding()
                        .background()
                }
            }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
        }
    }


#Preview(as: .systemMedium) {
    WordWidgetExtension()
} timeline: {
    let data = DataService()

    SimpleEntry(date: .now, streak: data.todaysWord)
    SimpleEntry(date: .now, streak: data.todaysWord)
}
