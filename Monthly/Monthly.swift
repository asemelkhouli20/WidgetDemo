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
        DayEntery(date: Date())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (DayEntery) -> ()) {
        let entry = DayEntery(date: Date())
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntery] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: dayOffset, to: currentDate)!
            let startDay = Calendar.current.startOfDay(for: entryDate)
            
            let entry = DayEntery(date: startDay)
            
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DayEntery: TimelineEntry {
    let date: Date
}

struct MonthlyEntryView : View {
    var entry: DayEntery
    @Environment(\.widgetFamily) var family
    var body: some View {
        ZStack{
            LinearGradient(
                gradient:Gradient(colors:[.randomColor(),.randomColor()]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            HStack{
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
                if family == .systemMedium  {
                    Rectangle().frame(width: 1)
                        .padding(.horizontal,5)
                    Spacer()
                    VStack(spacing: 5){
                      
                        Text("Never bend your head. Always hold it high. Look the world right in the eye.")
                        
                        HStack{
                            Spacer()
                            Text("---Helen Keller")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.7))
                               
                        } .padding(.top,5)
                    }.padding(.vertical,5)
                }
            }.padding(.horizontal)
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
        .supportedFamilies([.systemSmall,.systemMedium])
    
    }
}

struct Monthly_Previews: PreviewProvider {
    static var previews: some View {
        
        MonthlyEntryView(entry: DayEntery(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        MonthlyEntryView(entry: DayEntery(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


