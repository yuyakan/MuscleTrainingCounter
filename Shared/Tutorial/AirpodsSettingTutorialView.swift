//
//  Tutorial1View.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/09.
//

import SwiftUI

struct AirpodsSettingTutorialView: View {
    var body: some View {
        ZStack{
            Color("light_blue").edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Image(systemName: "airpods.gen3")
                        .resizable()
                        .frame(width: 100, height: 75)
                        .padding()
                    DotView()
                    DotView(delay: 0.2)
                    DotView(delay: 0.4)
                    Image(systemName: "iphone")
                        .resizable()
                        .frame(width: 100, height: 150)
                        .padding()
                }.padding()
                Text(LocalizedStringKey("Please connect to Airpods!"))
                    .font(.title)
                    .foregroundColor(Color.white)
                    .frame(width: 350)
                    .padding()
            }
        }
    }
}
