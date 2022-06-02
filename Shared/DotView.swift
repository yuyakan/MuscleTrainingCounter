//
//  DotView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/06/02.
//

import SwiftUI

struct DotView: View {
    @State var delay: Double = 0
    @State var scale: CGFloat = 0.5
    var body: some View {
        Circle()
            .frame(width: 10, height: 10)
            .scaleEffect(scale)
            .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(delay), value: scale)
            .onAppear {
                withAnimation {
                    self.scale = 1
                }
            }
    }
}
