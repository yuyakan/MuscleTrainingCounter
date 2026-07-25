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
    @Environment(\.verticalSizeClass) private var vSizeClass
    var body: some View {
        TabView(selection: $tabIndex){
            SitUpsView().tabItem{
                Group{
                    Image("tab_sit")
                    Text(LocalizedStringKey("Sit-ups"))
                }
            }.tag(0)
            PushUpsView().tabItem{
                Group{
                    Image("tab_push")
                    Text(LocalizedStringKey("Push-ups"))
                }
            }.tag(1)
            SumGraphView()
                .tabItem{
                Group{
                    Image(systemName: "chart.bar")
                    Text(LocalizedStringKey("Charts"))
                }
            }.tag(2)
            BackExtensionView().tabItem{
                Group{
                    Image("tab_back")
                    Text(LocalizedStringKey("BackExtension"))
                }
            }.tag(3)
            SquatsView().tabItem{
                Group{
                    Image("tab_squat")
                    Text(LocalizedStringKey("Squats"))
                }
            }.tag(4)
        }
        // 縦向きはタブバーを少し浮かせ、横向き（画面が低い）は下げて余白を詰める
        .padding(.bottom, vSizeClass == .compact ? 0 : Theme.Spacing.sm)
        .fullScreenCover(isPresented: $isVisit, content: {
            TutorialView(visit: $isVisit)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
