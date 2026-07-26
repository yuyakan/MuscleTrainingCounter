//
//  TrainingType.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2023/12/05.
//

import Foundation

enum TrainingType {
    case push
    case sit
    case back
    case squat

    static let allCases: [TrainingType] = [.sit, .push, .back, .squat]

    /// 新方式（日付キー辞書）の保存キー。
    var dailyLogKey: String {
        switch self {
        case .sit:   return "dailyLog_sit"
        case .push:  return "dailyLog_push"
        case .back:  return "dailyLog_back"
        case .squat: return "dailyLog_squat"
        }
    }

    /// 旧方式の日次配列キー（移行の入力に使う）。
    var legacyDayKey: String {
        switch self {
        case .sit:   return "NumArray"
        case .push:  return "NumArray_p"
        case .back:  return "NumArray_b"
        case .squat: return "NumArray_s"
        }
    }

    /// 旧方式の最終保存日キー（移行の日付逆算の基準）。
    var legacyTodayKey: String {
        switch self {
        case .sit:   return "today"
        case .push:  return "today_p"
        case .back:  return "today_b"
        case .squat: return "today_s"
        }
    }
}
