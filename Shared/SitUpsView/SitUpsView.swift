//
//  SitUpsView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/06.
//

import SwiftUI

struct SitUpsView: View {
    @ObservedObject var sitUpsControlller = SitUpsViewController()
    @State var saveFlag = false
    @State var revise = false
    @State var stopFlag = false
    @State var status = 0
    var body: some View {
        let bounds = UIScreen.main.bounds
        let height = bounds.height
        let width = bounds.width
        ZStack{
            Image("fukkin_gray")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.5)
            VStack{
                Spacer()
                if status == 0 {
                    Text("Sit-ups")
                        .font(.largeTitle)
                        .padding()
                }else if status == 1{
                    HStack {
                        Text("Measuring")
                            .font(.largeTitle)
                            .padding()
                        DotView()
                        DotView(delay: 0.2)
                        DotView(delay: 0.4)
                            }
                }else if status == 2{
                    Text("Stop measurement")
                        .font(.largeTitle)
                        .padding()
                }
                Spacer()
                Text(sitUpsControlller.counter)
                    .font(.largeTitle)
                    .padding()
                Spacer()
                HStack{
                    Spacer()
                    if saveFlag {
                        Button(action: {
                            sitUpsControlller.startCalc()
                            saveFlag = false
                            status = 1
                            stopFlag = true
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
                            .padding()
                    }else {
                        Button(action: {
                            sitUpsControlller.startCalc()
                            saveFlag = false
                            status = 1
                            stopFlag = true
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
                            sitUpsControlller.saveDate()
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
                            sitUpsControlller.stopCalc()
                            saveFlag = true
                            status = 2
                            stopFlag = false
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
                    TextField("count", value: $sitUpsControlller.counter, formatter: NumberFormatter())
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
                            sitUpsControlller.minus()
                        }, label: {
                            Text("ー")
                                .font(.title)
                                .padding(.leading)
                        }).padding([.leading, .bottom])
                        Spacer()
                        Button(action: {
                            sitUpsControlller.plus()
                        }, label: {
                            Text("＋")
                                .font(.title)
                        }).padding(.bottom)
                        Spacer()
                        Button(action: {
                            sitUpsControlller.reset()
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
