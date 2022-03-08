//
//  SitUpsSumView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/06.
//

import SwiftUI
import SwiftUICharts

struct SitUpsSumView: View {
    @ObservedObject var calc = ViewController()
    @ObservedObject var calc2 = PushController()
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
            }
            if pickerSelection == 0{
                if pickerSelection2 == 0{
                    LineView(data: calc.array, title: "Sit-ups", legend: "Times / 1day")
                        .padding()
                        .padding(.vertical, height * 0.18)
                        .onAppear(perform: {
                            calc.ArrayDisplay()
                        })
                }else if pickerSelection2 == 1 {
                    LineView(data: calc.arrayW, title: "Sit-ups", legend: "Times / 1week")
                        .padding()
                        .padding(.vertical, height * 0.18)
                        .onAppear(perform: {
                            calc.ArrayDisplayW()
                        })
                }else {
                    LineView(data: calc.arrayM, title: "Sit-ups", legend: "Times / 1month")
                        .padding()
                        .padding(.vertical, height * 0.18)
                        .onAppear(perform: {
                            calc.ArrayDisplayM()
                        })
                }
            }else {
                if pickerSelection2 == 0{
                    LineView(data: calc2.array, title: "Push-ups", legend: "Times / 1day")
                        .padding()
                        .padding(.vertical, height * 0.18)
                        .onAppear(perform: {
                            calc2.ArrayDisplay()
                        })
                }else if pickerSelection2 == 1 {
                    LineView(data: calc2.arrayW, title: "Push-ups", legend: "Times / 1week")
                        .padding()
                        .padding(.vertical, height * 0.18)
                        .onAppear(perform: {
                            calc2.ArrayDisplayW()
                        })
                }else {
                    LineView(data: calc2.arrayM, title: "Push-ups", legend: "Times / 1month")
                        .padding()
                        .padding(.vertical, height * 0.18)
                        .onAppear(perform: {
                            calc2.ArrayDisplayM()
                        })
                }
            }
            VStack{
                Spacer()
                if pickerSelection == 0{
                    Text("Total　：　\(Int(calc.array.reduce(0, +)))")
                        .font(.largeTitle)
                        .padding(.bottom, height * 0.05)
                }else{
                    Text("Total　：　\(Int(calc2.array.reduce(0, +)))")
                        .font(.largeTitle)
                        .padding(.bottom, height * 0.05)
                }
            }
        }
    }
}

struct SitUpsSumView_Previews: PreviewProvider {
    static var previews: some View {
        SitUpsSumView()
    }
}
