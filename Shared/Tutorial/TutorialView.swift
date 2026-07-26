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
        ZStack {
            // 背景をブランドカラーで統一し、ページと開始ボタンを同じ面に載せる。
            Theme.Colors.primary.ignoresSafeArea()

            VStack(spacing: Theme.Spacing.xl) {
                TabView(selection: $selection) {
                    AirpodsSettingTutorialView()
                        .tag(1)
                    CompleteTutorialView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                // 開始ボタン（青背景に映える白い円 + ブランドカラーのアイコン）
                Button {
                    visit = false
                    UserDefaults.standard.set(true, forKey: "visit")
                } label: {
                    ZStack {
                        Circle().fill(Color.white)
                        Image(systemName: "play.fill")
                            .font(Theme.Typography.button)
                            .foregroundColor(Theme.Colors.primary)
                    }
                    .frame(width: 88, height: 88)
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(PressableButtonStyle())
                .padding(.bottom, Theme.Spacing.xxl)
            }
        }
    }
}
