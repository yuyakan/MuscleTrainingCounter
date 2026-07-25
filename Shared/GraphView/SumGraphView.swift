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

    var body: some View {
        let bounds = UIScreen.main.bounds
        let width = bounds.width
        VStack{
            Spacer()
            Text(LocalizedStringKey(trainingTitles[pickerSelection]))
                .font(.system(.largeTitle, design: .monospaced))
                .fontWeight(.bold)
                .frame(alignment: .leading)
                .padding(.leading, 20)
                .padding(.top, 20)
            Spacer()
            Picker(selection: $pickerSelection2, label: Text("Stats")){
                Text(LocalizedStringKey("1day")).tag(0)
                Text(LocalizedStringKey("1week")).tag(1)
                Text(LocalizedStringKey("1month")).tag(2)
            }.pickerStyle(SegmentedPickerStyle())
                .frame(width: width * 0.8)
                .padding(.bottom, 2)
            // 種目・期間の組み合わせごとに GraphView を作り直す（init で値を確定させるため id を付与）
            GraphView(sumGraghViewModel: sumGraphViewModel, spanType: selectedSpanType, traingType: selectedTrainingType)
                .id("\(pickerSelection)-\(pickerSelection2)")
            Spacer()
            Picker(selection: $pickerSelection, label: Text("Stats")){
                Text(LocalizedStringKey("Sit-ups")).tag(0)
                Text(LocalizedStringKey("Push-ups")).tag(1)
                Text(LocalizedStringKey("BackExtension")).tag(2)
                Text(LocalizedStringKey("Squats")).tag(3)
            }.pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 30)
                .padding(.horizontal)
        }.onAppear() {
            sumGraphViewModel.calcDay()
            sumGraphViewModel.calcWeek()
            sumGraphViewModel.calcMonth()
        }
    }
}

struct SitUpsSumView_Previews: PreviewProvider {
    static var previews: some View {
        SumGraphView()
    }
}
