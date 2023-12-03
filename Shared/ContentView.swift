//
//  ContentView.swift
//  Shared
//
//  Created by 上別縄祐也 on 2022/03/05.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @State var tabIndex:Int = 0
    @State var isVisit = !(UserDefaults.standard.bool(forKey: "visit"))
    var body: some View {
        VStack{
            TabView(selection: $tabIndex){
                SitUpsView().tabItem{
                    Group{
                        Image("small_fukkin_gray")
                        Text(LocalizedStringKey("Sit-ups"))
                    }
                }.tag(0)
                SumGraphView()
                    .tabItem{
                    Group{
                        Image(systemName: "chart.bar")
                        Text(LocalizedStringKey("Charts"))
                    }
                }.tag(1)
                PushUpsView().tabItem{
                    Group{
                        Image("small_udetate_gray")
                        Text(LocalizedStringKey("Push-ups"))
                    }
                }
            }.padding(.bottom)
                .fullScreenCover(isPresented: $isVisit, content: {
                    TutorialView(visit: $isVisit)
                })
//            BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716")//テスト
//                .frame(height: 50)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
