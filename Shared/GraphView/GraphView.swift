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
        }
    }
    
    var body:some View {
        let bounds = UIScreen.main.bounds
        let height = bounds.height
        let width = bounds.width
        
        Chart {
            ForEach(1...spansNum, id: \.self) { index in
                BarMark(
                    x: .value("day", span[index-1]),
                    y: .value("count", spanSumCount[index])
                )
                .foregroundStyle(Color("startColor"))
                .cornerRadius(6)
                
                RuleMark(y: .value("target", targetCount))
                    .foregroundStyle(.orange)
                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [5,5,5,5], dashPhase: 0))
            }
        }
        .frame(width: width * 0.8, height: height * 0.33)
        .onAppear(perform: {
            displaySpan()
        })
        HStack(spacing: 0) {
            Spacer()
            Text(String(localized: "Target") + ": ")
                .font(.system(.subheadline, design: .monospaced))
            TextField("10", value: $targetCount, format: .number)
                .textFieldStyle(.roundedBorder)
                .frame(width: 50)
            Text("/ " + String(localized: "1day"))
                .font(.system(.subheadline, design: .monospaced))
                .padding(.trailing, width * 0.11)
        }
        .padding(.top, 2)
        Text(String(localized: "Total") + "：\(Int(spanSumCount.reduce(0, +)))")
            .font(.system(.title, design: .monospaced))
            .fontWeight(.bold)
            .padding(.top, 20)
    }
}
