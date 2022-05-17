//
//  SitUpsSumView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/06.
//

import SwiftUI
import SwiftUICharts

struct SumGraphView: View {
    @ObservedObject var sitUpsControlller = SitUpsController()
    @ObservedObject var pushUpsControlller = PushUpsController()
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
                    LineView(data: sitUpsControlller.daySumCount, title: "Sit-ups", legend: "Times / 1day")
                        .padding()
                        .padding(.vertical, height * 0.18)
                        .onAppear(perform: {
                            sitUpsControlller.displayDay()
                        })
                }else if pickerSelection2 == 1 {
                    LineView(data: sitUpsControlller.weekSumCount, title: "Sit-ups", legend: "Times / 1week")
                        .padding()
                        .padding(.vertical, height * 0.18)
                        .onAppear(perform: {
                            sitUpsControlller.displayWeek()
                        })
                }else {
                    LineView(data: sitUpsControlller.monthSumCount, title: "Sit-ups", legend: "Times / 1month")
                        .padding()
                        .padding(.vertical, height * 0.18)
                        .onAppear(perform: {
                            sitUpsControlller.displayMonth()
                        })
                }
            }else {
                if pickerSelection2 == 0{
                    LineView(data: pushUpsControlller.daySumCount, title: "Push-ups", legend: "Times / 1day")
                        .padding()
                        .padding(.vertical, height * 0.18)
                        .onAppear(perform: {
                            pushUpsControlller.displayDay()
                        })
                }else if pickerSelection2 == 1 {
                    LineView(data: pushUpsControlller.weekSumCount, title: "Push-ups", legend: "Times / 1week")
                        .padding()
                        .padding(.vertical, height * 0.18)
                        .onAppear(perform: {
                            pushUpsControlller.displayWeek()
                        })
                }else {
                    LineView(data: pushUpsControlller.monthSumCount, title: "Push-ups", legend: "Times / 1month")
                        .padding()
                        .padding(.vertical, height * 0.18)
                        .onAppear(perform: {
                            pushUpsControlller.displayMonth()
                        })
                }
            }
            VStack{
                Spacer()
                if pickerSelection == 0{
                    if pickerSelection2 == 0{
                        Text("Total　：　\(Int(sitUpsControlller.daySumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.05)
                    }else if pickerSelection2 == 1{
                        Text("Total　：　\(Int(sitUpsControlller.weekSumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.05)
                    }else{
                        Text("Total　：　\(Int(sitUpsControlller.monthSumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.05)
                    }
                }else{
                    if pickerSelection2 == 0{
                        Text("Total　：　\(Int(pushUpsControlller.daySumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.05)
                    }else if pickerSelection2 == 1{
                        Text("Total　：　\(Int(pushUpsControlller.weekSumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.05)
                    }else{
                        Text("Total　：　\(Int(pushUpsControlller.monthSumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.05)
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
