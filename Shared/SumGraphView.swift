//
//  SitUpsSumView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/06.
//

import SwiftUI
import SwiftUICharts

struct SumGraphView: View {
    @ObservedObject var sumGraphViewModel = SumGraphViewModel()
    @State var pickerSelection = 0
    @State var pickerSelection2 = 0
    var body: some View {
        let bounds = UIScreen.main.bounds
        let height = bounds.height
        ZStack{
            VStack{
                Picker(selection: $pickerSelection, label: Text("Stats")){
                    Text("Sit-ups").tag(0)
                    Text("Push-ups").tag(1)
                }.pickerStyle(SegmentedPickerStyle()).padding([.top, .horizontal]).padding(.vertical)
                Picker(selection: $pickerSelection2, label: Text("Stats")){
                    Text("1day").tag(0)
                    Text("1week").tag(1)
                    Text("1month").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                Spacer()
            }.onAppear{
                pickerSelection2 = 0
            }
            if pickerSelection == 0{
                if pickerSelection2 == 0{
                    LineView(data: sumGraphViewModel.sitUpsDaySumCount, title: "Sit-ups", legend: "Times / 1day")
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .padding(.top, height * 0.18)
                        .onAppear(perform: {
                            sumGraphViewModel.displaySitUpsDay()
                        })
                }else if pickerSelection2 == 1 {
                    LineView(data: sumGraphViewModel.sitUpsWeekSumCount, title: "Sit-ups", legend: "Times / 1week")
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .padding(.top, height * 0.18)
                        .onAppear(perform: {
                            sumGraphViewModel.displaySitUpsWeek()
                        })
                }else {
                    LineView(data: sumGraphViewModel.sitUpsMonthSumCount, title: "Sit-ups", legend: "Times / 1month")
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .padding(.top, height * 0.18)
                        .onAppear(perform: {
                            sumGraphViewModel.displaySitUpsMonth()
                        })
                }
            }else {
                if pickerSelection2 == 0{
                    LineView(data: sumGraphViewModel.pushUpsDaySumCount, title: "Push-ups", legend: "Times / 1day")
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .padding(.top, height * 0.18)
                        .onAppear(perform: {
                            sumGraphViewModel.displayPushUpsDay()
                        })
                }else if pickerSelection2 == 1 {
                    LineView(data: sumGraphViewModel.pushUpsWeekSumCount, title: "Push-ups", legend: "Times / 1week")
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .padding(.top, height * 0.18)
                        .onAppear(perform: {
                            sumGraphViewModel.displayPushUpsWeek()
                        })
                }else {
                    LineView(data: sumGraphViewModel.pushUpsMonthSumCount, title: "Push-ups", legend: "Times / 1month")
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .padding(.top, height * 0.18)
                        .onAppear(perform: {
                            sumGraphViewModel.displayPushUpsMonth()
                        })
                }
            }
            VStack{
                Spacer()
                if pickerSelection == 0{
                    if pickerSelection2 == 0{
                        Text("Total　：　\(Int(sumGraphViewModel.sitUpsDaySumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.022)
                    }else if pickerSelection2 == 1{
                        Text("Total　：　\(Int(sumGraphViewModel.sitUpsWeekSumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.022)
                    }else{
                        Text("Total　：　\(Int(sumGraphViewModel.sitUpsMonthSumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.022)
                    }
                }else{
                    if pickerSelection2 == 0{
                        Text("Total　：　\(Int(sumGraphViewModel.pushUpsDaySumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.022)
                    }else if pickerSelection2 == 1{
                        Text("Total　：　\(Int(sumGraphViewModel.pushUpsWeekSumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.022)
                    }else{
                        Text("Total　：　\(Int(sumGraphViewModel.pushUpsMonthSumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.022)
                    }
                }
            }
        }
    }
}

struct SitUpsSumView_Previews: PreviewProvider {
    static var previews: some View {
        SumGraphView()
    }
}
