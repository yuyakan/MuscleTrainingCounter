//
//  ActionButton.swift
//  MuscleTrainingCounter
//
//  全画面で共有する円形アクションボタン。
//  start / stop / save を統一トーンで表現する。
//

import SwiftUI

struct ActionButton: View {
    let systemName: String
    let tint: Color
    let isEnabled: Bool
    let action: () -> Void

    /// ボタン直径。真円を保つ。
    var diameter: CGFloat = 96

    init(systemName: String,
         tint: Color,
         isEnabled: Bool = true,
         diameter: CGFloat = 96,
         action: @escaping () -> Void) {
        self.systemName = systemName
        self.tint = tint
        self.isEnabled = isEnabled
        self.diameter = diameter
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(tint)
                Image(systemName: systemName)
                    .font(Theme.Typography.button)
                    .foregroundColor(.white)
            }
            .frame(width: diameter, height: diameter)
            .shadow(color: isEnabled ? tint.opacity(0.35) : .clear,
                    radius: 12, x: 0, y: 6)
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.35)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}

/// 押下時に軽く縮むフィードバックを与えるボタンスタイル。
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6),
                       value: configuration.isPressed)
    }
}
