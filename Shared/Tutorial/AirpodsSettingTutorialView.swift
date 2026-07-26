//
//  AirpodsSettingTutorialView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/09.
//

import SwiftUI

struct AirpodsSettingTutorialView: View {
    var body: some View {
        ZStack {
            Theme.Colors.primary.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.xl) {
                HStack(spacing: Theme.Spacing.md) {
                    Image(systemName: "airpods.gen3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                    DotView()
                    DotView(delay: 0.2)
                    DotView(delay: 0.4)
                    Image(systemName: "iphone")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 100)
                        .foregroundColor(.white)
                }

                Text(LocalizedStringKey("Please connect to Airpods!"))
                    .font(Theme.Typography.title(26))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.xl)
            }
        }
    }
}
