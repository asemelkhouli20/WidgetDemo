//
//  ContentView.swift
//  WidgetDemo
//
//  Created by Asem on 23/06/2023.
//

import SwiftUI
struct ContentView: View {
    @State var flashLight = false
    @StateObject var orientationInfo = OrientationInfo()

    var body: some View {
        
        ZStack{
            VStack(spacing: 5){
                Spacer()
                CalenderView(flashLight: $flashLight, isValue: self.orientationInfo.isPortrait )
                ForEach(0..<4) { _ in Spacer()}
            }.frame(maxWidth: .infinity)
                .background(content: {
                    BackgroundView(flashLight: $flashLight)
                })
            .onTapGesture {
                flashLight.toggle()
            }
            .bold()
            .foregroundColor(Color(uiColor: .label).opacity(0.7))
            
            VStack{
                Spacer()
                QautoView(flashLight: $flashLight)
            }
        }.ignoresSafeArea()
           
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}



struct CalenderView: View {
    @Binding var flashLight:Bool
    let date: Date = Date.now
    var isValue:Bool
    var body: some View {
            VStack{
                if isValue{
                    VStack(alignment: .center, spacing: 0){
                        Text(String.randomEmoji())
                            .font(.system(size: 100))
                        Text(date.weekDayFormate)
                            .minimumScaleFactor(0.6)
                        
                        Text(date.formatted(.dateTime.day())).font(.system(size: 150,weight: .heavy))
                        Rectangle().frame(width: 300, height: 1)
                        
                    }
                }else{
                    HStack{
                        Text(String.randomEmoji())
                            .font(.system(size: 60))
                        Text(date.weekDayFormate)
                            .minimumScaleFactor(0.6)
                        Rectangle().frame(width: 1, height: 100).padding(.horizontal)
                        Text(date.formatted(.dateTime.day()))
                            .font(.system(size: 150,weight: .heavy))
                    }
                }
                
            
        }
        
        .font(.system(size: 80))
        .onChange(of: flashLight) { _ in
            
        }
        
    }
}





struct QautoView: View {
    @Binding var flashLight:Bool
    @State var qautoRandom:QautoRandom = QautoRandom(
        content:"Never bend your head. Always hold it high. Look the world right in the eye.",
        author: "Helen Keller"
    )
    var body: some View {
        VStack(){
            Rectangle()
                .foregroundColor(Color(uiColor: .systemBackground))
                .frame(width: 50,height: 1).padding(8)
            Text("\""+(qautoRandom.content ?? "")+"\"")
                .font(.system(size: 25,weight: .regular))
                .textSelection(.enabled)
                
            HStack{
                Spacer()
                Text("---")+Text(qautoRandom.author ?? "")
            }
            .padding(8).foregroundColor(.white.opacity(0.7)).bold()
            
            Rectangle().foregroundColor(.clear).frame(height: 20)
        }.padding(.horizontal)
        .padding().background{
            Color.clear
                .background(.ultraThinMaterial,in:RoundedRectangle(cornerRadius: 25))
                .shadow(color: .black.opacity(0.2),radius: 5)
            
        }
        .onAppear {getQote()}
        .onChange(of: flashLight) { _ in getQote()}
        
    }
    func getQote(){
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: Help.makeRequest()) { (data,_,_) in
                if data == nil {return}
                if let qauto =  Help.makeDecode(d: data!) {
                    DispatchQueue.main.async {withAnimation {self.qautoRandom = qauto}}
                }
            }.resume()
            
        }
        
        
    }
}

struct BackgroundView: View {
    @Binding var flashLight:Bool
    var body: some View {
        LinearGradient(
            gradient:Gradient(colors:[.randomColor(),.randomColor()]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
        .onChange(of: flashLight) { _ in}
    }
}
