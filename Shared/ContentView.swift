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
    var body: some View {
        VStack{
            TabView(selection: $tabIndex){
                SitUpsView().tabItem{
                    Group{
                        Image("f3")
                        Text("Sit-ups")
                    }
                }.tag(0)
                SitUpsSumView()
                    .tabItem{
                    Group{
                        Image(systemName: "chart.bar")
                        Text("Charts")
                    }
                }.tag(1)
                PushUpsView().tabItem{
                    Group{
                        Image("u2")
                        Text("Push-ups")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
