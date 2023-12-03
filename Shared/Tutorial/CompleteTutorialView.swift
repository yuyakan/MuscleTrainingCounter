//
//  Tutorial2View.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/09.
//

import SwiftUI

struct CompleteTutorialView: View {
    var body: some View {
        let bounds = UIScreen.main.bounds
        let height = bounds.height

        ZStack{
            Color("light_blue").edgesIgnoringSafeArea(.all)
            VStack{
                Image("fukkin_white")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: height * 0.2)
                Text(LocalizedStringKey("Start when you are ready!"))
                    .font(.title)
                Image("udetate_white")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: height * 0.2)
            }
        }
    }
}

