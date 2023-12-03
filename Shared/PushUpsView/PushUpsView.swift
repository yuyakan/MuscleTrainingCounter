//
//  PushUpsView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/08.
//

import SwiftUI

struct PushUpsView: View {
    @ObservedObject var pushUpsControlller = PushUpsViewController()
    @State var saveFlag = false
    @State var revise = false
    @State var stopFlag = false
    @State var status = 0
    var body: some View {
        let bounds = UIScreen.main.bounds
        let height = bounds.height
        let width = bounds.width
        ZStack{
            Image("udetate_gray")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.3)
            VStack{
                Spacer()
                if status == 0 {
                    Text("Push-ups")
                        .font(.largeTitle)
                        .padding()
                }else if status == 1{
                    HStack {
                        Text("Measuring")
                            .font(.largeTitle)
                            .padding()
                        DotView() // 1.
                        DotView(delay: 0.2) // 2.
                        DotView(delay: 0.4) // 3.
                            }
                }else if status == 2{
                    Text("Stop measurement")
                        .font(.largeTitle)
                        .padding()
                }
                Spacer()
                Text("\(pushUpsControlller.counter)")
                    .font(.largeTitle)
                    .padding()
                Spacer()
                HStack{
                    Spacer()
                    if saveFlag {
                        Button(action: {
                            pushUpsControlller.startCalc()
                            saveFlag = false
                            stopFlag = true
                            status = 1
                        }, label: {
                            Text("▶︎")
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                                .frame(width: height * 0.13, height: height * 0.13)
                                .background(Color("restartColor"))
                                .clipShape(Circle())
                                .shadow(color: .gray, radius: 4, x: 0, y: 0)
                                .padding(.trailing)
                        })
                            .disabled(stopFlag)
                            .opacity(stopFlag ? 0.3:1)
                            .padding()
                    } else {
                        Button(action: {
                            pushUpsControlller.startCalc()
                            saveFlag = false
                            stopFlag = true
                            status = 1
                        }, label: {
                            Text("Start")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: height * 0.13, height: height * 0.13)
                                .background(Color("light_blue"))
                                .clipShape(Circle())
                                .shadow(color: .gray, radius: 4, x: 0, y: 0)
                                .padding(.trailing)
                        })
                            .disabled(stopFlag)
                            .opacity(stopFlag ? 0.1:1)
                            .padding()
                    }
                    Spacer()
                    if(saveFlag){
                        Button(action: {
                            Thread.sleep(forTimeInterval: 0.1)
                            pushUpsControlller.saveDate()
                            saveFlag = false
                            status = 0
                        }) {
                            Text("Save")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: height * 0.13, height: height * 0.13)
                                .background(Color("saveColor"))
                                .clipShape(Circle())
                                .shadow(color: .gray, radius: 4, x: 0, y: 0)
                                .padding(.leading)
                        }.padding()
                    }else{
                        Button(action: {
                            Thread.sleep(forTimeInterval: 0.1)
                            pushUpsControlller.stopCalc()
                            saveFlag = true
                            stopFlag = false
                            status = 2
                        }, label: {
                            Text("Stop")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: height * 0.13, height: height * 0.13)
                                .background(Color("restartColor"))
                                .clipShape(Circle())
                                .shadow(color: .gray, radius: 4, x: 0, y: 0)
                                .padding(.leading)
                        }).padding()
                        
                    }
                    Spacer()
                }.padding(.horizontal)
                HStack{
                    Toggle(isOn: $revise) {
                    }.labelsHidden()
                        .padding()
                    Spacer()
                    TextField("count", value: $pushUpsControlller.counter, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title2)
                        .frame(width: width * 0.3)
                        .padding(.horizontal)
                        .opacity(revise ? 1:0)
                        .disabled(!revise)
                }.padding(.leading)
                if revise {
                    HStack{
                        Button(action: {
                            pushUpsControlller.minus()
                        }, label: {
                            Text("ー")
                                .font(.title)
                                .padding(.leading)
                        }).padding([.leading, .bottom])
                        Spacer()
                        Button(action: {
                            pushUpsControlller.plus()
                        }, label: {
                            Text("＋")
                                .font(.title)
                        }).padding(.bottom)
                        Spacer()
                        Button(action: {
                            pushUpsControlller.reset()
                        }, label: {
                            Text("Reset")
                                .font(.title)
                                .padding(.trailing)
                        }).padding([.trailing, .bottom])
                    }.padding()
                }
                if !revise {
                    Text(" ").padding()
                }
            }
        }
    }
}
