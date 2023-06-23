//
//  Monthly.swift
//  Monthly
//
//  Created by Asem on 23/06/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> DayEntery {
        DayEntery(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (DayEntery) -> ()) {
        let entry = DayEntery(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntery] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startDay = Calendar.current.startOfDay(for: entryDate)
            
            let entry = DayEntery(date: startDay, configuration: configuration)
            
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DayEntery: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct MonthlyEntryView : View {
    var entry: DayEntery
    var body: some View {
        ZStack{
            LinearGradient(
                gradient:Gradient(colors:[.random(),.random()]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            
            VStack(){
                HStack(spacing: 0){
                    Text(String.randomEmoji())
                        .font(.system(size: 30))
                    Text(entry.date.weekDayFormate)
                        .font(.title3)
                        .minimumScaleFactor(0.6)
                }
                Text(entry.date.formatted(.dateTime.day()))
                    .font(.system(size: 50,weight: .heavy))
            }
            .bold()
            .foregroundColor(.white)
        }
    }
}

struct Monthly: Widget {
    let kind: String = "Monthly"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MonthlyEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Monthly_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyEntryView(entry: DayEntery(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


extension Date{
    var weekDayFormate:String {self.formatted(.dateTime.weekday(.wide))}
}

extension String {
    static public func randomEmoji() -> String {
        let ranges: [ClosedRange<Int>] = [
            0x1F300...0x1F3F0,
            0x1f600...0x1f64f,
            0x1f680...0x1f6c5,
            0x1f6cb...0x1f6d2,
            0x1f6e0...0x1f6e5,
            0x1f6f3...0x1f6fa,
            0x1f7e0...0x1f7eb,
            0x1f90d...0x1f93a,
            0x1f93c...0x1f945,
            0x1f947...0x1f971,
            0x1f973...0x1f976,
            0x1f97a...0x1f9a2,
            0x1f9a5...0x1f9aa,
            0x1f9ae...0x1f9ca,
            0x1f9cd...0x1f9ff,
            0x1fa70...0x1fa73,
            0x1fa78...0x1fa7a,
            0x1fa80...0x1fa82,
            0x1fa90...0x1fa95,
        ]
        let range = ranges[Int(arc4random_uniform(UInt32(ranges.count)))]
        let index = Int(arc4random_uniform(UInt32(range.count)))
        let ord = range.lowerBound + index
        guard let scalar = UnicodeScalar(ord) else { return "❓" }
        return String(scalar)
    }
}

extension Color {
    static public func random() -> Color {
         Color(uiColor:UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        ))
    }
}
