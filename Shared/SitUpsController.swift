//
//  ViewController.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/06.
//

import UIKit
import CoreMotion
import SwiftUI
import AVFoundation

class SitUpsController: UIViewController, CMHeadphoneMotionManagerDelegate, ObservableObject{
    @Published var counter = 0
    @Published var daySumCount: [Double] = [0.0]
    @Published var weekSumCount: [Double] = [0.0]
    @Published var monthSumCount: [Double] = [0.0]
    
    let airpods = CMHeadphoneMotionManager()
    
    var sumPlusRotationRate : Double = 0.0
    var sumMinusRotationRate : Double = 0.0
    var sumPlusAcceleration : Double = 0.0
    var sumMinusAcceleration : Double = 0.0
    var plusCountFlag = false
    var minusCountFlag = true

    override func viewDidLoad() {
        super.viewDidLoad()
        airpods.delegate = self
    }

    override func viewWillAppear(_ plusCountFlag: Bool){
        super.viewWillAppear(plusCountFlag)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func startCalc(){
        print("start")
        airpods.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] motion, error  in
            guard let motion = motion else { return }
            self?.getDataRotate(motion)
        })
    }
    
    func getDataRotate(_ data: CMDeviceMotion){
        let x = data.rotationRate.x
        let y = data.userAcceleration.y
        if ((x > 0.0 || y > 0.0) && plusCountFlag == true){
            sumPlusRotationRate += x
            sumPlusAcceleration += y
            print(sumPlusRotationRate)
        }else if((x < 0.0 || y < 0.0) && minusCountFlag == true){
            sumMinusRotationRate += x
            sumMinusAcceleration += y
        }
        if (sumPlusRotationRate > 20.0 || sumPlusAcceleration > 0.7){
            minusCountFlag = true
            sumMinusRotationRate = 0.0
            sumPlusRotationRate = 0.0
        }
        if ((sumMinusRotationRate < -20 || sumMinusAcceleration < -2.0) && minusCountFlag == true){
            counter += 1
            plusCountFlag = true
            minusCountFlag = false
            sumPlusRotationRate = 0.0
            sumMinusRotationRate = 0.0
            sumPlusAcceleration = 0.0
            sumMinusAcceleration = 0.0
        }
    }
    
    func stopCalc(){
        print("stop")
        airpods.stopDeviceMotionUpdates()
    }
    
    func plus(){
        counter += 1
    }
    
    func minus(){
        counter -= 1
    }
    
    func reset(){
        counter = 0
    }
    
    let UD = UserDefaults.standard
    var valueToSave: [Double] = []
    var temp: Double = 0.0
    let dayFormatter = DateFormatter()
    let monthFormatter = DateFormatter()
    func saveDate(){
        dayFormatter.dateFormat = "yyyy/MM/dd"
        monthFormatter.dateFormat = "yyyy/MM"
        
        let date = Date()
        
        var dayCountFlag = Bool()
        var weekCountFlag = Bool()
        var monthCountFlag = Bool()
        
        var daySpan = 0
        var weekSpan = 0

        if UD.object(forKey: "today") != nil {
            let pastDay = UD.object(forKey: "today") as! Date
            let now = dayFormatter.string(from: date)
            let past = dayFormatter.string(from: pastDay)
            let span = date.timeIntervalSince(pastDay)
            daySpan = Int(span/60/60/24)
            
            let nowMonth = monthFormatter.string(from: date)
            let pastMonth = monthFormatter.string(from: pastDay)
            
            let thisWeekDay = Calendar.current.dateComponents([.weekday], from: date).weekday! - 1
            let now_ = Calendar.current.date(byAdding: .day, value: -thisWeekDay, to: date)!
            let thisWeek = dayFormatter.string(from: now_)
            let pastWeekDay = Calendar.current.dateComponents([.weekday], from: pastDay).weekday! - 1
            let past_ = Calendar.current.date(byAdding: .day, value: -pastWeekDay, to: pastDay)!
            let pastWeek = dayFormatter.string(from: past_)
            weekSpan = Int(now_.timeIntervalSince(past_)/60/60/24/7)

            if now != past {
                dayCountFlag = true
            }
            else {
                dayCountFlag = false
                print(now)
            }
            
            if thisWeek != pastWeek {
                weekCountFlag = true
                UD.set([0.0], forKey: "NumArray")
            }
            else {
                weekCountFlag = false
                print(thisWeek)
            }

            if nowMonth != pastMonth {
                monthCountFlag = true
                UD.set([0.0], forKey: "NumArray_w")
            }
            else {
                monthCountFlag = false
                print(nowMonth)
            }
            UD.set(date, forKey: "today")
         }
        
         else {
             dayCountFlag = true
             weekCountFlag = true
             monthCountFlag = true
             
             UD.set(date, forKey: "today")
             UD.set([0.0], forKey: "NumArray")
             UD.set([0.0], forKey: "NumArray_w")
             UD.set([0.0], forKey: "NumArray_m")
         }

         /* 日付が変わった場合はtrueの処理 */
         if dayCountFlag == true {
              dayCountFlag = false
             if UD.array(forKey: "NumArray") != nil {
                 valueToSave = UD.array(forKey: "NumArray")! as! [Double]
                 if daySpan > 1 {
                     for i in 2...daySpan{
                         print(i)
                         valueToSave.append(0.0)
                     }
                 }
             }else{
                 UD.set(valueToSave, forKey: "NumArray")
             }
             valueToSave.append(Double(counter))
             UserDefaults.standard.set(valueToSave, forKey: "NumArray")
             
         }
         else {
             if UD.array(forKey: "NumArray") != nil {
                 valueToSave = UD.array(forKey: "NumArray")! as! [Double]
                 temp = valueToSave.removeLast()
                 valueToSave.append(Double(counter) + temp)
             }else{
                 UD.set(valueToSave, forKey: "NumArray")
                 valueToSave.append(Double(counter))
             }
             UserDefaults.standard.set(valueToSave, forKey: "NumArray")
         }
        
        if weekCountFlag == true {
             weekCountFlag = false
            if UD.array(forKey: "NumArray_w") != nil {
                valueToSave = UD.array(forKey: "NumArray_w")! as! [Double]
                if weekSpan > 1 {
                    for i in 2...weekSpan{
                        print(i)
                        valueToSave.append(0.0)
                    }
                }
                print("a")
            }else{
                UD.set(valueToSave, forKey: "NumArray_w")
                print("b")
            }
            valueToSave.append(Double(counter))
            UserDefaults.standard.set(valueToSave, forKey: "NumArray_w")
            
        }
        else {
            if UD.array(forKey: "NumArray_w") != nil {
                valueToSave = UD.array(forKey: "NumArray_w")! as! [Double]
                temp = valueToSave.removeLast()
                valueToSave.append(Double(counter) + temp)
                print("c")
            }else{
                UD.set(valueToSave, forKey: "NumArray_w")
                valueToSave.append(Double(counter))
                print("d")
            }
            UserDefaults.standard.set(valueToSave, forKey: "NumArray_w")
        }
        
        if monthCountFlag == true {
             monthCountFlag = false
            if UD.array(forKey: "NumArray_m") != nil {
                valueToSave = UD.array(forKey: "NumArray_m")! as! [Double]
            }else{
                UD.set(valueToSave, forKey: "NumArray_m")
            }
            valueToSave.append(Double(counter))
            UserDefaults.standard.set(valueToSave, forKey: "NumArray_m")
            
        }
        else {
            if UD.array(forKey: "NumArray_m") != nil {
                valueToSave = UD.array(forKey: "NumArray_m")! as! [Double]
                temp = valueToSave.removeLast()
                valueToSave.append(Double(counter) + temp)
            }else{
                UD.set(valueToSave, forKey: "NumArray_m")
                valueToSave.append(Double(counter))
            }
            UserDefaults.standard.set(valueToSave, forKey: "NumArray_m")
        }
        
        counter = 0
        sumPlusRotationRate = 0
        sumMinusRotationRate = 0
        plusCountFlag = true
        minusCountFlag = false
    }
    
    func ArrayDisplay(){
        weekSumCount = (UD.array(forKey: "NumArray") ?? [0.0]) as! [Double]
    }
    
    func ArrayDisplayW(){
        weekSumCount = (UD.array(forKey: "NumArray_w") ?? [0.0]) as! [Double]
    }
    
    func ArrayDisplayM(){
        monthSumCount = (UD.array(forKey: "NumArray_m") ?? [0.0]) as! [Double]
    }
}



