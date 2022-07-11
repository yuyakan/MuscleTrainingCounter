//
//  TutorialView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/09.
//

import SwiftUI

struct TutorialView: View {
    @State var selection = 1
    @Binding var visit: Bool
    var body: some View {
        let bounds = UIScreen.main.bounds
        let height = bounds.height
        VStack{
            TabView(selection: $selection,
                content: {
                    AirpodsSettingTutorialView()
                        .tag(1)
                    CompleteTutorialView()
                        .tag(2)
            })
                .tabViewStyle(PageTabViewStyle())
                .frame(height: height * 0.5)
            .padding(.top, height * 0.1)
            .shadow(color: .gray, radius: 8, x: 0, y: 0)
            Button(action: {
                visit = false
                UserDefaults.standard.set(true, forKey: "visit")
            }, label: {
                Text("Start")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: height * 0.1, height: height * 0.1)
                    .background(Color("light_blue"))
                    .clipShape(Circle())
                    .shadow(color: .gray, radius: 6, x: 0, y: 0)
                    .padding()
            }).padding(.top, height * 0.05)
        }
    }
}
