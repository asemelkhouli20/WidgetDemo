//
//  HelpBase.swift
//  WidgetDemo
//
//  Created by Asem on 25/06/2023.
//

import SwiftUI

class Help{
    static func makeRequest(limit:Int=1)->URLRequest {
        var request = URLRequest(url: URL(string: "https://api.quotable.io/quotes/random?limit=\(limit)")!)
        request.httpMethod = "GET"
        return request
    }
    static func makeDecode(d:Data)->[QautoRandom]{
        if let data:[QautoRandom] = try? JSONDecoder().decode([QautoRandom].self, from: d) {return data}
        return []
    }
    
    
}

struct QautoRandom:Codable {var content,author:String}

extension Color {
    static public var randomColor:Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
    
    
}

extension String {
    static func randomEmoji() -> String {
        let ranges: [ClosedRange<Int>] = [
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
               0x1F300...0x1F3F0
           ]
        let range = ranges[Int(arc4random_uniform(UInt32(ranges.count)))]
        let index = Int(arc4random_uniform(UInt32(range.count)))
        let ord = range.lowerBound + index
        guard let scalar = UnicodeScalar(ord) else { return "❓" }
        return String(scalar)
    }
}
