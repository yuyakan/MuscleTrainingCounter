//
//  Tutorial2View.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/09.
//

import SwiftUI

struct Tutorial2View: View {
    var body: some View {
        let bounds = UIScreen.main.bounds
        let height = bounds.height

        ZStack{
            Color("startColor2").edgesIgnoringSafeArea(.all)
            VStack{
                Image("f_")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: height * 0.2)
                Text("Start when you are ready!")
                    .font(.title)
                Image("u_")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: height * 0.2)
            }
        }
    }
}

struct Tutorial2View_Previews: PreviewProvider {
    static var previews: some View {
        Tutorial2View()
    }
}
