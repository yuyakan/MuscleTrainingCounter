//
//  Theme.swift
//  MuscleTrainingCounter
//
//  クリーン・ミニマルな統一UIのためのデザイントークン。
//  色・余白・角丸・タイポをここに集約し、全画面で共有する。
//

import SwiftUI

enum Theme {

    // MARK: - Colors
    enum Colors {
        static let primary = Color("BrandPrimary")      // start (青系ブランド主色)
        static let stop = Color("BrandStop")            // stop (コーラル)
        static let save = Color("BrandSave")            // save (グリーン)
        static let text = Color("BrandText")            // 主テキスト
        static let textSecondary = Color("BrandTextSecondary")
        static let background = Color("BrandBackground")
        static let surface = Color("BrandSurface")      // カード面
    }

    // MARK: - Spacing (8pt グリッド)
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: - Radius
    enum Radius {
        static let sm: CGFloat = 10
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
    }

    // MARK: - Typography
    enum Typography {
        /// 画面上部の種目名など。細めで上品な大見出し。
        static func title(_ size: CGFloat = 34) -> Font {
            .system(size: size, weight: .semibold, design: .rounded)
        }
        /// 巨大なカウンター数字。
        static func counter(_ size: CGFloat = 88) -> Font {
            .system(size: size, weight: .bold, design: .rounded)
        }
        static let caption = Font.system(size: 15, weight: .medium, design: .rounded)
        static let button = Font.system(size: 26, weight: .semibold, design: .rounded)
    }

    // MARK: - Shadow
    enum Shadow {
        static let soft = (color: Color.black.opacity(0.08), radius: CGFloat(14), y: CGFloat(6))
    }
}
