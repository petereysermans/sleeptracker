//
//  SleepTrackerWidget.swift
//  SleepTrackerWidget
//
//  Created by Peter Eysermans on 18/07/2020.
//

import WidgetKit
import SwiftUI
import Intents

struct SleepTimeline: TimelineProvider {
    public func snapshot(with context: Context, completion: @escaping (SleepEntry) -> ()) {
        let entry = SleepEntry(date: Date(), value: "")
        completion(entry)
    }

    public func timeline( with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        
        SleepRetrieval().retrieveSleepWithAuth { result in
            
            let entry = SleepEntry(date: currentDate, value: result)
            
            let timeline = Timeline(entries: [ entry ], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

struct SleepEntry: TimelineEntry {
    public let date: Date
    public let value: String
}

struct PlaceholderView : View {
    var body: some View {
        
        VStack(alignment: .center, spacing: 4) {
            Text("No sleep data")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .top, endPoint: .bottom))
    }
}

struct SleepTrackerWidgetEntryView : View {
    var entry: SleepTimeline.Entry

    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text("You slept:")
            Text(entry.value)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .top, endPoint: .bottom))
    }
}

@main
struct SleepTrackerWidget: Widget {
    private let kind: String = "SleepTrackerWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SleepTimeline(), placeholder: PlaceholderView()) { entry in
            SleepTrackerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Time slept")
        .description("This widget shows the time you slept last night.")
    }
}

struct SleepTrackerWidget_Previews: PreviewProvider {
    static var previews: some View {
        SleepTrackerWidgetEntryView(entry: SleepEntry(date: Date(), value: ""))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
