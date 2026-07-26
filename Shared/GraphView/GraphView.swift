//
//  GraphView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2023/12/05.
//

import SwiftUI
import Charts

struct GraphView: View {
    @State var targetCount: Int
    let sumGraphViewModel: SumGraphViewModel
    let series: WorkoutSeries
    let spanType: SpanType

    init(sumGraghViewModel: SumGraphViewModel, spanType: SpanType, traingType: TrainingType) {
        self.sumGraphViewModel = sumGraghViewModel
        self.spanType = spanType
        // 集計結果と目標値を WorkoutLogStore 経由で取得する（種目×期間×ページ位置）。
        self.series = sumGraghViewModel.series(type: traingType, span: spanType)
        self.targetCount = sumGraghViewModel.target(type: traingType, span: spanType)
    }

    // 縦向き：グラフ + Target + Total を縦積みで返す。
    // グラフは画面の余白に応じて伸縮し、大きい端末（iPad 等）では上限まで広がる。
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            chart
                .frame(maxWidth: 720)
                .frame(minHeight: 240, maxHeight: 520)
                .padding(.horizontal, Theme.Spacing.lg)
            targetRow
            totalLabel
        }
    }

    // MARK: - 個別部品（横向きの2カラム配置で再利用）

    /// 棒グラフ本体。ラベルと値は 1対1 で対応（左が古く右が新しい）。
    var chart: some View {
        Chart {
            ForEach(Array(series.values.enumerated()), id: \.offset) { index, value in
                BarMark(
                    x: .value("label", index < series.labels.count ? series.labels[index] : "\(index)"),
                    y: .value("count", value)
                )
                .foregroundStyle(Theme.Colors.primary)
                .cornerRadius(6)

                RuleMark(y: .value("target", targetCount))
                    .foregroundStyle(.orange)
                    .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [5,5,5,5], dashPhase: 0))
            }
        }
    }

    /// 目標入力行。
    var targetRow: some View {
        HStack(spacing: Theme.Spacing.xs) {
            Text(String(localized: "Target") + ": ")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(Theme.Colors.textSecondary)
            TextField("10", value: $targetCount, format: .number)
                .textFieldStyle(.roundedBorder)
                .frame(width: 50)
            Text("/ " + targetUnitLabel)
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(Theme.Colors.textSecondary)
        }
    }

    /// 目標の単位ラベル（/日・/週・/月）。
    private var targetUnitLabel: String {
        switch spanType {
        case .day:   return String(localized: "1day")
        case .week:  return String(localized: "1week")
        case .month: return String(localized: "1month")
        }
    }

    /// 合計ラベル。
    var totalLabel: some View {
        Text(String(localized: "Total") + "：\(series.values.reduce(0, +))")
            .font(.system(.title, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(Theme.Colors.text)
    }
}
