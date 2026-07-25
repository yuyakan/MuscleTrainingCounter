//
//  PushUpsView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/08.
//

import SwiftUI

struct PushUpsView: View {
    @ObservedObject var interstitial = Interstitial()
    @ObservedObject var pushUpsControlller = PushUpsViewController()
    @State var saveFlag = false
    @State var stopFlag = false
    @State var status = 0

    // 保存ボタンを出す条件（計測停止後 & カウントあり）
    private var canSave: Bool { saveFlag && pushUpsControlller.counter != "0" }

    var body: some View {
        WorkoutScreen(
            backgroundImage: "udetate_gray",
            header: { statusHeader },
            counter: { counterDisplay },
            controls: { controlButtons },
            revise: { reviseSection }
        )
        .onAppear {
            interstitial.loadInterstitial()
        }
    }

    // MARK: - 見出し（状態に応じて変化）
    private var statusHeader: some View {
        Group {
            if status == 1 {
                HStack(spacing: Theme.Spacing.xs) {
                    Text(LocalizedStringKey("Measuring"))
                        .font(Theme.Typography.title())
                        .foregroundColor(Theme.Colors.text)
                    DotView()
                    DotView(delay: 0.2)
                    DotView(delay: 0.4)
                }
            } else if status == 2 {
                Text(LocalizedStringKey("Stop measurement"))
                    .font(Theme.Typography.title())
                    .foregroundColor(Theme.Colors.text)
            } else {
                Text(LocalizedStringKey("Push-ups"))
                    .font(Theme.Typography.title())
                    .foregroundColor(Theme.Colors.text)
            }
        }
    }

    // MARK: - カウンター表示
    private var counterDisplay: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Text(pushUpsControlller.counter)
                .font(Theme.Typography.counter())
                .foregroundColor(Theme.Colors.text)
                .contentTransition(.numericText())
                .animation(.snappy, value: pushUpsControlller.counter)
            Text(LocalizedStringKey("Times"))
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
    }

    // MARK: - 操作ボタン（start / stop・save）
    private var controlButtons: some View {
        HStack(spacing: 72) {
            // Start
            ActionButton(
                systemName: "play.fill",
                tint: Theme.Colors.primary,
                isEnabled: !stopFlag
            ) {
                pushUpsControlller.startCalc()
                saveFlag = false
                stopFlag = true
                status = 1
            }

            // Stop / Save（状態で切り替え）
            if canSave {
                ActionButton(
                    systemName: "list.bullet.clipboard.fill",
                    tint: Theme.Colors.save
                ) {
                    Thread.sleep(forTimeInterval: 0.1)
                    pushUpsControlller.saveDate()
                    saveFlag = false
                    status = 0
                    interstitial.presentInterstitial()
                }
            } else {
                ActionButton(
                    systemName: "stop.fill",
                    tint: Theme.Colors.stop,
                    isEnabled: status == 1
                ) {
                    if pushUpsControlller.counter == "0" {
                        saveFlag = false
                        stopFlag = false
                        status = 0
                    } else {
                        Thread.sleep(forTimeInterval: 0.1)
                        pushUpsControlller.stopCalc()
                        saveFlag = true
                        status = 2
                        stopFlag = false
                    }
                }
            }
        }
    }

    // MARK: - 補正セクション（− / ＋ / リセットを常時表示）
    private var reviseSection: some View {
        HStack(spacing: Theme.Spacing.lg) {
            reviseButton(system: "minus") { pushUpsControlller.minus() }
            reviseButton(system: "plus") {
                saveFlag = true
                pushUpsControlller.plus()
            }
            reviseButton(system: "gobackward") { pushUpsControlller.reset() }
        }
    }

    private func reviseButton(system: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.Colors.text)
                .frame(width: 52, height: 52)
                .background(Theme.Colors.surface)
                .clipShape(Circle())
        }
        .buttonStyle(PressableButtonStyle())
    }
}
