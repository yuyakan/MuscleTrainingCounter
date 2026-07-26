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
        // 種目・期間を切り替えたらページ位置を最新に戻す。
        .onChange(of: pickerSelection) { _ in sumGraphViewModel.pageOffset = 0 }
        .onChange(of: pickerSelection2) { _ in sumGraphViewModel.pageOffset = 0 }
    }

    // MARK: - 縦向き：全体を統一間隔で並べ、上下の余白は上限付き（iPad で中央に凝縮しすぎないように）
    private var portraitLayout: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer().frame(maxHeight: 40)
            trainingTitle
            spanPicker
            graph
            pageNavigationBar
            trainingIconBar
            Spacer().frame(maxHeight: 40)
        }
        .padding(.top, Theme.Spacing.md)
        .padding(.bottom, Theme.Spacing.lg)
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
                    .id("\(pickerSelection)-\(pickerSelection2)-\(sumGraphViewModel.pageOffset)")
                    .gesture(
                        DragGesture(minimumDistance: 30)
                            .onEnded { value in
                                if value.translation.width < -40 { goOlder() }
                                else if value.translation.width > 40 { goNewer() }
                            }
                    )

                // 下部バー：ページナビ + 期間切替 + 目標
                HStack(spacing: Theme.Spacing.lg) {
                    pageNavigationBar
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
                trainingIconButton(index)
            }
        }
        .padding(.vertical, Theme.Spacing.sm)
    }

    // 縦向き下部の種目アイコン横バー
    private var trainingIconBar: some View {
        HStack(spacing: Theme.Spacing.lg) {
            ForEach(0..<trainingTitles.count, id: \.self) { index in
                trainingIconButton(index)
            }
        }
    }

    // 種目アイコンの丸ボタン（選択中はブランドカラーで強調）
    private func trainingIconButton(_ index: Int) -> some View {
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
        // 種目・期間・ページ位置の組み合わせごとに GraphView を作り直す（init で値を確定させるため id を付与）
        GraphView(sumGraghViewModel: sumGraphViewModel, spanType: selectedSpanType, traingType: selectedTrainingType)
            .id("\(pickerSelection)-\(pickerSelection2)-\(sumGraphViewModel.pageOffset)")
            .gesture(
                DragGesture(minimumDistance: 30)
                    .onEnded { value in
                        if value.translation.width < -40 {
                            goOlder()          // 右→左スワイプで過去へ
                        } else if value.translation.width > 40 {
                            goNewer()          // 左→右スワイプで最新へ
                        }
                    }
            )
    }

    // 現在表示中の集計（ページナビの状態判定・期間タイトルに使う）
    private var currentSeries: WorkoutSeries {
        sumGraphViewModel.series(type: selectedTrainingType, span: selectedSpanType)
    }

    private func goOlder() {
        if currentSeries.hasOlderData {
            sumGraphViewModel.pageOffset -= 1
        }
    }

    private func goNewer() {
        if sumGraphViewModel.pageOffset < 0 {
            sumGraphViewModel.pageOffset += 1
        }
    }

    // ページ送りナビ（‹ 期間ラベル ›）
    private var pageNavigationBar: some View {
        HStack(spacing: Theme.Spacing.lg) {
            Button(action: goOlder) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
            }
            .disabled(!currentSeries.hasOlderData)
            .opacity(currentSeries.hasOlderData ? 1 : 0.3)

            Text(currentSeries.rangeTitle)
                .font(Theme.Typography.caption)
                .foregroundColor(Theme.Colors.textSecondary)
                .frame(minWidth: 140)

            Button(action: goNewer) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
            }
            .disabled(sumGraphViewModel.pageOffset >= 0)
            .opacity(sumGraphViewModel.pageOffset < 0 ? 1 : 0.3)
        }
        .foregroundColor(Theme.Colors.primary)
    }
}

struct SitUpsSumView_Previews: PreviewProvider {
    static var previews: some View {
        SumGraphView()
    }
}
