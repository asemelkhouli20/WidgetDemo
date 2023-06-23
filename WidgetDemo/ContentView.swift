//
//  ContentView.swift
//  WidgetDemo
//
//  Created by Asem on 23/06/2023.
//

import SwiftUI

struct ContentView: View {
    let date: Date = Date.now
    @State var flashLight  = false
    @State var qautoRandom:QautoRandom? = QautoRandom(
        content:"Never bend your head. Always hold it high. Look the world right in the eye.",
        author: "Helen Keller"
    )
    var body: some View {
        
        ZStack{
           
            LinearGradient(
                gradient:Gradient(colors:[.random(),.random()]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            
            VStack(spacing: 5){
                Spacer()
                VStack(spacing: 0){
                    Text(String.randomEmoji())
                        .font(.system(size: 100))
                        Text(date.weekDayFormate)
                            .minimumScaleFactor(0.6)
                        
                        Text(date.formatted(.dateTime.day())).font(.system(size: 150,weight: .heavy))
                        Rectangle().frame(width: 300, height: 1)
                    
                } .font(.system(size: 80))
                    
                Spacer()
                VStack{
                    if let qauto = qautoRandom {
                        VStack(){
                           
                            Rectangle().foregroundColor(.clear).frame(height: 10)
                            Text("\""+(qauto.content ?? "")+"\"")
                                .font(.system(size: 25,weight: .regular))
                            HStack{
                                Spacer()
                                Text("---")
                                Text(qauto.author ?? "")
                            }.padding(8).foregroundColor(.white.opacity(0.7)).bold()
                            Rectangle().foregroundColor(.clear).frame(height: 20)
                        }.padding()
                    }
                }.background(.ultraThinMaterial,in:RoundedRectangle(cornerRadius: 25))
                
            }
            .bold()
            .foregroundColor(.white)
        }.ignoresSafeArea()
            .animation(.spring(), value: flashLight)
            .onTapGesture {getQote()}
            .onAppear {getQote()}
    }
    func getQote(){
        let url = "https://api.quotable.io/quotes/random"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let d = data else {return}
                let dataSet:[QautoRandom]? = try? JSONDecoder().decode([QautoRandom].self, from: d)
                if let data = dataSet {
                    DispatchQueue.main.async {self.qautoRandom = data.first
                        self.flashLight.toggle()
                    }
                }
            }
            
            task.resume()
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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


extension Date{
    var weekDayFormate:String {self.formatted(.dateTime.weekday(.wide))}
}
struct QautoRandom: Codable {
    var  content, author: String?
}
