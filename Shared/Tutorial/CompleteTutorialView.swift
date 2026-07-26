//
//  CompleteTutorialView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/09.
//

import SwiftUI

struct CompleteTutorialView: View {
    // 導入で見せる4種目の白シルエット
    private let icons = ["fukkin_white", "udetate_white", "h_white", "s_white"]

    var body: some View {
        ZStack {
            Theme.Colors.primary.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.xl) {
                // 4種目のシルエットを 2×2 で見せる
                VStack(spacing: Theme.Spacing.lg) {
                    HStack(spacing: Theme.Spacing.xl) {
                        exerciseIcon(icons[0])
                        exerciseIcon(icons[1])
                    }
                    HStack(spacing: Theme.Spacing.xl) {
                        exerciseIcon(icons[2])
                        exerciseIcon(icons[3])
                    }
                }

                Text(LocalizedStringKey("Start when you are ready!"))
                    .font(Theme.Typography.title(26))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.xl)
            }
        }
    }

    private func exerciseIcon(_ name: String) -> some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 110, height: 80)
    }
}
