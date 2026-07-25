//
//  SitUpsSumView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/06.
//

import SwiftUI
import SwiftUICharts
import Charts

struct SumGraphView: View {
    @ObservedObject var sumGraphViewModel = SumGraphViewModel()
    @State var pickerSelection = 0
    @State var pickerSelection2 = 0

    // 種目タブの並び順（ContentView のタブ順と対応）
    private let trainingTypes: [TrainingType] = [.sit, .push, .back, .squat]
    private let trainingTitles = ["Sit-ups", "Push-ups", "BackExtension", "Squats"]
    // 横向きサイドバー用の種目アイコン（タブと同じ画像を流用）
    private let trainingIcons = ["tab_sit", "tab_push", "tab_back", "tab_squat"]

    private var selectedTrainingType: TrainingType {
        trainingTypes[pickerSelection]
    }

    private var selectedSpanType: SpanType {
        switch pickerSelection2 {
        case 0: return .day
        case 1: return .week
        default: return .month
        }
    }

    @Environment(\.verticalSizeClass) private var vSizeClass
    private var isCompactHeight: Bool { vSizeClass == .compact }

    var body: some View {
        ZStack {
            Theme.Colors.background.ignoresSafeArea()

            if isCompactHeight {
                landscapeLayout
            } else {
                portraitLayout
            }
        }
        .tint(Theme.Colors.primary)
        .onAppear() {
            sumGraphViewModel.calcDay()
            sumGraphViewModel.calcWeek()
            sumGraphViewModel.calcMonth()
        }
    }

    // MARK: - 縦向き：ゆったり縦積み
    private var portraitLayout: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()
            trainingTitle
            spanPicker
            graph
            Spacer()
            trainingPicker
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.lg)
        }
    }

    // MARK: - 横向き：左に種目サイドバー、中央にグラフのダッシュボード風
    private var landscapeLayout: some View {
        let graphView = GraphView(sumGraghViewModel: sumGraphViewModel,
                                  spanType: selectedSpanType,
                                  traingType: selectedTrainingType)

        return HStack(spacing: Theme.Spacing.lg) {
            // 左：種目アイコンの縦サイドバー
            trainingSidebar

            // 中央：ヘッダー + グラフ + 下部バー
            VStack(spacing: Theme.Spacing.sm) {
                // ヘッダー：種目名 + 合計
                HStack(alignment: .firstTextBaseline) {
                    Text(LocalizedStringKey(trainingTitles[pickerSelection]))
                        .font(Theme.Typography.title(28))
                        .foregroundColor(Theme.Colors.text)
                    Spacer()
                    graphView.totalLabel
                }

                // グラフ（主役・縦いっぱい）
                graphView.chart
                    .frame(maxHeight: .infinity)
                    .id("\(pickerSelection)-\(pickerSelection2)")

                // 下部バー：期間切替 + 目標
                HStack(spacing: Theme.Spacing.lg) {
                    spanPicker
                    Spacer()
                    graphView.targetRow
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.Spacing.md)
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }

    // 横向き左の種目アイコン縦サイドバー
    private var trainingSidebar: some View {
        VStack(spacing: Theme.Spacing.md) {
            ForEach(0..<trainingTitles.count, id: \.self) { index in
                Button {
                    pickerSelection = index
                } label: {
                    Image(trainingIcons[index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                        .padding(Theme.Spacing.sm)
                        .background(
                            Circle().fill(pickerSelection == index
                                          ? Theme.Colors.primary.opacity(0.15)
                                          : Color.clear)
                        )
                        .opacity(pickerSelection == index ? 1 : 0.4)
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
        .padding(.vertical, Theme.Spacing.sm)
    }

    // MARK: - 部品
    private var trainingTitle: some View {
        Text(LocalizedStringKey(trainingTitles[pickerSelection]))
            .font(Theme.Typography.title())
            .foregroundColor(Theme.Colors.text)
            .padding(.top, Theme.Spacing.md)
    }

    private var spanPicker: some View {
        Picker(selection: $pickerSelection2, label: Text("Stats")){
            Text(LocalizedStringKey("1day")).tag(0)
            Text(LocalizedStringKey("1week")).tag(1)
            Text(LocalizedStringKey("1month")).tag(2)
        }.pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 320)
    }

    private var graph: some View {
        // 種目・期間の組み合わせごとに GraphView を作り直す（init で値を確定させるため id を付与）
        GraphView(sumGraghViewModel: sumGraphViewModel, spanType: selectedSpanType, traingType: selectedTrainingType)
            .id("\(pickerSelection)-\(pickerSelection2)")
    }

    private var trainingPicker: some View {
        Picker(selection: $pickerSelection, label: Text("Stats")){
            Text(LocalizedStringKey("Sit-ups")).tag(0)
            Text(LocalizedStringKey("Push-ups")).tag(1)
            Text(LocalizedStringKey("BackExtension")).tag(2)
            Text(LocalizedStringKey("Squats")).tag(3)
        }.pickerStyle(SegmentedPickerStyle())
    }
}

struct SitUpsSumView_Previews: PreviewProvider {
    static var previews: some View {
        SumGraphView()
    }
}
