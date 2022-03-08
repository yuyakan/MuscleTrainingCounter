//
//  SitUpsView.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/06.
//

import SwiftUI

struct SitUpsView: View {
    @ObservedObject var calc = ViewController()
    @State var saveFlag = false
    @State var revise = false
    @State var status = 0
    var body: some View {
        let bounds = UIScreen.main.bounds
        let height = bounds.height
        ZStack{
            Image("f")
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
                    Text("During measurement ...")
                        .font(.largeTitle)
                        .padding()
                }else if status == 2{
                    Text("Stop measurement")
                        .font(.largeTitle)
                        .padding()
                }
                Spacer()
                Text("\(calc.counter)")
                    .font(.largeTitle)
                    .padding()
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        calc.startCalc()
                        saveFlag = false
                        status = 1
                    }, label: {
                        Text("Start")
                            .font(.title)
                            .foregroundColor(Color.white)
                            .frame(width: height * 0.13, height: height * 0.13)
                            .background(Color("startColor"))
                            .clipShape(Circle())
                            .padding(.trailing)
                    }).padding()
                    Spacer()
                    if(saveFlag){
                        Button(action: {
                            calc.saveDate()
                            calc.counter = 0
                            saveFlag = false
                            status = 0
                        }) {
                            Text("Save")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: height * 0.13, height: height * 0.13)
                                .background(Color("saveColor"))
                                .clipShape(Circle())
                                .padding(.leading)
                        }.padding()
                    }else{
                        Button(action: {
                            calc.stopCalc()
                            saveFlag = true
                            status = 2
                        }, label: {
                            Text("Stop")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: height * 0.13, height: height * 0.13)
                                .background(Color("startColor"))
                                .clipShape(Circle())
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
                }.padding(.leading)
                if revise {
                    HStack{
                        Button(action: {
                            calc.minus()
                        }, label: {
                            Text("ー")
                                .font(.title)
                                .padding(.leading)
                        }).padding([.leading, .bottom])
                        Spacer()
                        Button(action: {
                            calc.plus()
                        }, label: {
                            Text("＋")
                                .font(.title)
                        }).padding(.bottom)
                        Spacer()
                        Button(action: {
                            calc.reset()
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

