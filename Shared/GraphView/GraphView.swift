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
    let span: [String]
    let spansNum: Int
    let dayCount: Int
    let spanSumCount: [Double]
    let displaySpan: () -> ()

    init(sumGraghViewModel: SumGraphViewModel, spanType: SpanType, traingType: TrainingType) {
        self.sumGraphViewModel = sumGraghViewModel
        switch traingType {
        case .sit:
            switch spanType {
            case .day:
                span = sumGraghViewModel.day
                spanSumCount = sumGraghViewModel.sitUpsDaySumCount
                displaySpan = sumGraghViewModel.displaySitUpsDay
                spansNum = 7
                dayCount = 1
                targetCount = sumGraghViewModel.displaySitUpsDayTarget()
                break
            case .week:
                span = sumGraghViewModel.week
                spanSumCount = sumGraghViewModel.sitUpsWeekSumCount
                displaySpan = sumGraghViewModel.displaySitUpsWeek
                spansNum = 4
                dayCount = 7
                targetCount = sumGraghViewModel.displaySitUpsWeekTarget()
                break
            case .month:
                span = sumGraghViewModel.month
                spanSumCount = sumGraghViewModel.sitUpsMonthSumCount
                displaySpan = sumGraghViewModel.displaySitUpsMonth
                spansNum = 6
                dayCount = 30
                targetCount = sumGraghViewModel.displaySitUpsMonthTarget()
                break
            }
            break
            
        case .push:
            switch spanType {
            case .day:
                span = sumGraghViewModel.day
                spanSumCount = sumGraghViewModel.pushUpsDaySumCount
                displaySpan = sumGraghViewModel.displayPushUpsDay
                spansNum = 7
                dayCount = 1
                targetCount = sumGraghViewModel.displayPushUpsDayTarget()
                break
            case .week:
                span = sumGraghViewModel.week
                spanSumCount = sumGraghViewModel.pushUpsWeekSumCount
                displaySpan = sumGraghViewModel.displayPushUpsWeek
                spansNum = 4
                dayCount = 7
                targetCount = sumGraghViewModel.displayPushUpsWeekTarget()
                break
            case .month:
                span = sumGraghViewModel.month
                spanSumCount = sumGraghViewModel.pushUpsMonthSumCount
                displaySpan = sumGraghViewModel.displayPushUpsMonth
                spansNum = 6
                dayCount = 30
                targetCount = sumGraghViewModel.displayPushUpsMonthTarget()
                break
            }
            break

        case .back:
            switch spanType {
            case .day:
                span = sumGraghViewModel.day
                spanSumCount = sumGraghViewModel.backExtensionDaySumCount
                displaySpan = sumGraghViewModel.displayBackExtensionDay
                spansNum = 7
                dayCount = 1
                targetCount = sumGraghViewModel.displayBackExtensionDayTarget()
                break
            case .week:
                span = sumGraghViewModel.week
                spanSumCount = sumGraghViewModel.backExtensionWeekSumCount
                displaySpan = sumGraghViewModel.displayBackExtensionWeek
                spansNum = 4
                dayCount = 7
                targetCount = sumGraghViewModel.displayBackExtensionWeekTarget()
                break
            case .month:
                span = sumGraghViewModel.month
                spanSumCount = sumGraghViewModel.backExtensionMonthSumCount
                displaySpan = sumGraghViewModel.displayBackExtensionMonth
                spansNum = 6
                dayCount = 30
                targetCount = sumGraghViewModel.displayBackExtensionMonthTarget()
                break
            }
            break

        case .squat:
            switch spanType {
            case .day:
                span = sumGraghViewModel.day
                spanSumCount = sumGraghViewModel.squatsDaySumCount
                displaySpan = sumGraghViewModel.displaySquatsDay
                spansNum = 7
                dayCount = 1
                targetCount = sumGraghViewModel.displaySquatsDayTarget()
                break
            case .week:
                span = sumGraghViewModel.week
                spanSumCount = sumGraghViewModel.squatsWeekSumCount
                displaySpan = sumGraghViewModel.displaySquatsWeek
                spansNum = 4
                dayCount = 7
                targetCount = sumGraghViewModel.displaySquatsWeekTarget()
                break
            case .month:
                span = sumGraghViewModel.month
                spanSumCount = sumGraghViewModel.squatsMonthSumCount
                displaySpan = sumGraghViewModel.displaySquatsMonth
                spansNum = 6
                dayCount = 30
                targetCount = sumGraghViewModel.displaySquatsMonthTarget()
                break
            }
            break
        }
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
        .onAppear { displaySpan() }
    }

    // MARK: - 個別部品（横向きの2カラム配置で再利用）

    /// 棒グラフ本体。高さは呼び出し側の frame に追従する。
    var chart: some View {
        Chart {
            ForEach(1...spansNum, id: \.self) { index in
                BarMark(
                    x: .value("day", index-1 < span.count ? span[index-1] : ""),
                    y: .value("count", index < spanSumCount.count ? spanSumCount[index] : 0.0)
                )
                .foregroundStyle(Theme.Colors.primary)
                .cornerRadius(6)

                RuleMark(y: .value("target", targetCount))
                    .foregroundStyle(.orange)
                    .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [5,5,5,5], dashPhase: 0))
            }
        }
        .onAppear { displaySpan() }
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
            Text("/ " + String(localized: "1day"))
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(Theme.Colors.textSecondary)
        }
    }

    /// 合計ラベル。
    var totalLabel: some View {
        Text(String(localized: "Total") + "：\(Int(spanSumCount.reduce(0, +)))")
            .font(.system(.title, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(Theme.Colors.text)
    }
}
