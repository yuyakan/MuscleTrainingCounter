//
//  SumGraphViewModel.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/06/02.
//

import Foundation

class SumGraphViewModel: ObservableObject {
    // ページ送り位置。0=最新、-1=1つ前の期間、…
    @Published var pageOffset: Int = 0

    private let store = WorkoutLogStore.shared
    private let ud = UserDefaults.standard

    /// 指定種目・期間・現在の pageOffset の集計結果を返す。
    func series(type: TrainingType, span: SpanType) -> WorkoutSeries {
        store.series(type: type, span: span, pageOffset: pageOffset)
    }

    /// 目標値（種目×期間で固定）。
    func target(type: TrainingType, span: SpanType) -> Int {
        ud.integer(forKey: targetKey(type: type, span: span))
    }

    private func targetKey(type: TrainingType, span: SpanType) -> String {
        let t: String
        switch type {
        case .sit:   t = "Sit"
        case .push:  t = "Push"
        case .back:  t = "Back"
        case .squat: t = "Squat"
        }
        let s: String
        switch span {
        case .day:   s = "Day"
        case .week:  s = "Week"
        case .month: s = "Month"
        }
        return "target\(t)\(s)Count"
    }
}
