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
        let width = bounds.width
        ZStack{
            VStack{
                Picker(selection: $pickerSelection, label: Text("Stats")){
                    Text(LocalizedStringKey("Sit-ups")).tag(0)
                    Text(LocalizedStringKey("Push-ups")).tag(1)
                }.pickerStyle(SegmentedPickerStyle()).padding([.top, .horizontal]).padding(.vertical)
                Picker(selection: $pickerSelection2, label: Text("Stats")){
                    Text(LocalizedStringKey("1day")).tag(0)
                    Text(LocalizedStringKey("1week")).tag(1)
                    Text(LocalizedStringKey("1month")).tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                Spacer()
            }.onAppear{
                pickerSelection2 = 0
            }
            if pickerSelection == 0{
                if pickerSelection2 == 0{
                    LineView(data: sumGraphViewModel.sitUpsDaySumCount, title: String(localized: "Sit-ups"), legend: String(localized:"Times") + "/" + String(localized: "1day"))
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .padding(.top, height * 0.18)
                        .onAppear(perform: {
                            sumGraphViewModel.displaySitUpsDay()
                        })
                    VStack {
                        Text("").frame(height: width * 0.8)
                        HStack {
                            Spacer()
                            ForEach(0..<7, id: \.self) { index in
                                Text(sumGraphViewModel.day[index])
                                    .frame(width: width * 0.087)
                                Spacer()
                            }
                        }
                        .padding(.leading, width * 0.15)
                        .padding(.trailing, width * 0.09)
                    }
                }else if pickerSelection2 == 1 {
                    LineView(data: sumGraphViewModel.sitUpsWeekSumCount, title: String(localized: "Sit-ups"), legend: String(localized:"Times") + "/" + String(localized: "1week"))
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .padding(.top, height * 0.18)
                        .onAppear(perform: {
                            sumGraphViewModel.displaySitUpsWeek()
                        })
                    VStack {
                        Text("").frame(height: width * 0.8)
                        HStack {
                            Spacer()
                            ForEach(0..<4, id: \.self) { index in
                                Text(sumGraphViewModel.week[index])
                                    .frame(width: width * 0.15,alignment: .center)
                                Spacer()
                            }
                        }
                        .padding(.leading, width * 0.11)
                        .padding(.trailing, width * 0.11)
                    }
                }else {
                    LineView(data: sumGraphViewModel.sitUpsMonthSumCount, title: String(localized: "Sit-ups"), legend: String(localized:"Times") + "/" + String(localized: "1month"))
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .padding(.top, height * 0.18)
                        .onAppear(perform: {
                            sumGraphViewModel.displaySitUpsMonth()
                        })
                    VStack {
                        Text("").frame(height: width * 0.8)
                        HStack {
                            Spacer()
                            ForEach(0..<6, id: \.self) { index in
                                Text(sumGraphViewModel.month[index])
                                    .frame(width: width * 0.1)
                                Spacer()
                            }
                        }
                        .padding(.leading, width * 0.12)
                        .padding(.trailing, width * 0.10)
                    }
                }
            }else {
                if pickerSelection2 == 0{
                    LineView(data: sumGraphViewModel.pushUpsDaySumCount, title: String(localized: "Push-ups"), legend: String(localized:"Times") + "/" + String(localized: "1day"))
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .padding(.top, height * 0.18)
                        .onAppear(perform: {
                            sumGraphViewModel.displayPushUpsDay()
                        })
                    VStack {
                        Text("").frame(height: width * 0.8)
                        HStack {
                            Spacer()
                            ForEach(0..<7, id: \.self) { index in
                                Text(sumGraphViewModel.day[index])
                                    .frame(width: width * 0.087)
                                Spacer()
                            }
                        }
                        .padding(.leading, width * 0.15)
                        .padding(.trailing, width * 0.09)
                    }
                }else if pickerSelection2 == 1 {
                    LineView(data: sumGraphViewModel.pushUpsWeekSumCount, title: String(localized: "Push-ups"), legend: String(localized:"Times") + "/" + String(localized: "1week"))
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .padding(.top, height * 0.18)
                        .onAppear(perform: {
                            sumGraphViewModel.displayPushUpsWeek()
                        })
                    VStack {
                        Text("").frame(height: width * 0.8)
                        HStack {
                            Spacer()
                            ForEach(0..<4, id: \.self) { index in
                                Text(sumGraphViewModel.week[index])
                                    .frame(width: width * 0.15,alignment: .center)
                                Spacer()
                            }
                        }
                        .padding(.leading, width * 0.11)
                        .padding(.trailing, width * 0.11)
                    }
                }else {
                    LineView(data: sumGraphViewModel.pushUpsMonthSumCount, title: String(localized: "Push-ups"), legend: String(localized:"Times") + "/" + String(localized: "1month"))
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .padding(.top, height * 0.18)
                        .onAppear(perform: {
                            sumGraphViewModel.displayPushUpsMonth()
                        })
                    VStack {
                        Text("").frame(height: width * 0.8)
                        HStack {
                            Spacer()
                            ForEach(0..<6, id: \.self) { index in
                                Text(sumGraphViewModel.month[index])
                                    .frame(width: width * 0.1)
                                Spacer()
                            }
                        }
                        .padding(.leading, width * 0.12)
                        .padding(.trailing, width * 0.10)
                    }
                }
            }
            VStack{
                Spacer()
                if pickerSelection == 0{
                    if pickerSelection2 == 0{
                        Text(String(localized: "Total") + "　：　\(Int(sumGraphViewModel.sitUpsDaySumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.022)
                    }else if pickerSelection2 == 1{
                        Text(String(localized: "Total") + "　：　\(Int(sumGraphViewModel.sitUpsWeekSumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.022)
                    }else{
                        Text(String(localized: "Total") + "　：　\(Int(sumGraphViewModel.sitUpsMonthSumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.022)
                    }
                }else{
                    if pickerSelection2 == 0{
                        Text(String(localized: "Total") + "　：　\(Int(sumGraphViewModel.pushUpsDaySumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.022)
                    }else if pickerSelection2 == 1{
                        Text(String(localized: "Total") + "　：　\(Int(sumGraphViewModel.pushUpsWeekSumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.022)
                    }else{
                        Text(String(localized: "Total") + "　：　\(Int(sumGraphViewModel.pushUpsMonthSumCount.reduce(0, +)))")
                            .font(.largeTitle)
                            .padding(.bottom, height * 0.022)
                    }
                }
            }
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
