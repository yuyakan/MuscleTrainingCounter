//
//  WorkoutScreen.swift
//  MuscleTrainingCounter
//
//  4種目画面で共有する共通レイアウトコンテナ。
//  背景シルエット + 縦向き/横向き両対応のレイアウトを一元化する。
//

import SwiftUI

struct WorkoutScreen<Header: View, Counter: View, Controls: View, Revise: View>: View {
    let backgroundImage: String
    @ViewBuilder let header: () -> Header
    @ViewBuilder let counter: () -> Counter
    @ViewBuilder let controls: () -> Controls
    @ViewBuilder let revise: () -> Revise

    // 縦の余白が狭いか（＝横向き）を判定
    @Environment(\.verticalSizeClass) private var vSizeClass

    private var isCompactHeight: Bool { vSizeClass == .compact }

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            // 背景シルエット（控えめに）
            Image(backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.12)
                .padding(Theme.Spacing.xl)

            if isCompactHeight {
                landscapeLayout
            } else {
                portraitLayout
            }
        }
    }

    // MARK: - 縦向き：ゆったり縦積み
    private var portraitLayout: some View {
        VStack(spacing: Theme.Spacing.lg) {
            // Spacer に上限を設け、iPad など大画面で余白が広がりすぎないようにする。
            // 上限が効くのは高さに余裕のある端末（iPad 等）だけで、iPhone では通常どおり伸縮する。
            Spacer().frame(maxHeight: 48)
            header()
            Spacer().frame(maxHeight: 100)
            counter()
            Spacer().frame(maxHeight: 120)
            controls()
            revise()
            Spacer().frame(maxHeight: 48)
        }
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.bottom, Theme.Spacing.lg)
    }

    // MARK: - 横向き：左に情報、右に操作の2カラム（潰れ防止）
    private var landscapeLayout: some View {
        HStack(spacing: Theme.Spacing.xl) {
            // 左カラム：見出し + カウンター
            VStack(spacing: Theme.Spacing.md) {
                header()
                counter()
            }
            .frame(maxWidth: .infinity)

            // 右カラム：操作ボタン + 補正
            VStack(spacing: Theme.Spacing.lg) {
                controls()
                revise()
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, Theme.Spacing.xl)
        .padding(.vertical, Theme.Spacing.md)
    }
}
