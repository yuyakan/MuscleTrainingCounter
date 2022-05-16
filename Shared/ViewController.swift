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

class ViewController: UIViewController, CMHeadphoneMotionManagerDelegate, ObservableObject{
    @Published var counter = 0
    @Published var array: [Double] = [0.0]
    @Published var arrayW: [Double] = [0.0]
    @Published var arrayM: [Double] = [0.0]
    
    let Airpods = CMHeadphoneMotionManager()
    
    var number = 0
    var alls : Double = 0.0
    var alls_m : Double = 0.0
    var alls2 : Double = 0.0
    var alls_m2 : Double = 0.0
    var flag = false
    var flag_m = true

    override func viewDidLoad() {
        super.viewDidLoad()
        Airpods.delegate = self
    }

    override func viewWillAppear(_ flag: Bool){
        super.viewWillAppear(flag)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func startCalc(){
        print("start")
        Airpods.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] motion, error  in
            guard let motion = motion else { return }
            self?.getDataRotate(motion)
        })
    }
    
    func getDataRotate(_ data: CMDeviceMotion){
        let x = data.rotationRate.x
        let y = data.userAcceleration.y
        if ((x > 0.0 || y > 0.0) && flag == true){
            alls += x
            alls2 += y
            print(alls)
        }else if((x < 0.0 || y < 0.0) && flag_m == true){
            alls_m += x
            alls_m += y
        }
        if (alls > 20.0 || alls2 > 0.7){
            flag_m = true
            alls_m = 0.0
            alls = 0.0
        }
        if ((alls_m < -20 || alls_m2 < -2.0) && flag_m == true){
            counter += 1
            flag = true
            flag_m = false
            alls = 0.0
            alls_m = 0.0
            alls2 = 0.0
            alls_m2 = 0.0
            number += 1
        }
    }
    
    func stopCalc(){
        print("stop")
        Airpods.stopDeviceMotionUpdates()
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
    let formatter = DateFormatter()
    let formatter_m = DateFormatter()
    func saveDate(){
        formatter.dateFormat = "yyyy/MM/dd"
        formatter_m.dateFormat = "yyyy/MM"
        
        let now_day = Date()
        
        var judge = Bool()
        var judge_w = Bool()
        var judge_m = Bool()
        
        var daySpan = 0
        var weekSpan = 0

        if UD.object(forKey: "today") != nil {
            let past_day = UD.object(forKey: "today") as! Date
            let now = formatter.string(from: now_day)
            let past = formatter.string(from: past_day)
            let span = now_day.timeIntervalSince(past_day)
            daySpan = Int(span/60/60/24)
            
            let now_m = formatter_m.string(from: now_day)
            let past_m = formatter_m.string(from: past_day)
            
            let thisWeekDay = Calendar.current.dateComponents([.weekday], from: now_day).weekday!
            let n = thisWeekDay - 1
            let now_ = Calendar.current.date(byAdding: .day, value: -n, to: now_day)!
            let now_w = formatter.string(from: now_)
            let thisWeekDay_p = Calendar.current.dateComponents([.weekday], from: past_day).weekday!
            let n_p = thisWeekDay_p - 1
            let past_ = Calendar.current.date(byAdding: .day, value: -n_p, to: past_day)!
            let past_w = formatter.string(from: past_)
            let span_w = now_.timeIntervalSince(past_)
            weekSpan = Int(span_w/60/60/24/7)

            if now != past {
                judge = true
            }
            else {
                judge = false
                print(now)
            }
            
            if now_w != past_w {
                judge_w = true
                UD.set([0.0], forKey: "NumArray")
            }
            else {
                judge_w = false
                print(now_w)
            }

            if now_m != past_m {
                judge_m = true
                UD.set([0.0], forKey: "NumArray_w")
            }
            else {
                judge_m = false
                print(now_m)
            }
            UD.set(now_day, forKey: "today")
         }
        
         else {
             judge = true
             judge_w = true
             judge_m = true
             
             UD.set(now_day, forKey: "today")
             UD.set([0.0], forKey: "NumArray")
             UD.set([0.0], forKey: "NumArray_w")
             UD.set([0.0], forKey: "NumArray_m")
         }

         /* 日付が変わった場合はtrueの処理 */
         if judge == true {
              judge = false
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
        
        if judge_w == true {
             judge_w = false
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
        
        if judge_m == true {
             judge_m = false
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
        
        number = 0
        counter = 0
        alls = 0
        alls_m = 0
        flag = true
        flag_m = false
    }
    
    func ArrayDisplay(){
        array = (UD.array(forKey: "NumArray") ?? [0.0]) as! [Double]
    }
    
    func ArrayDisplayW(){
        arrayW = (UD.array(forKey: "NumArray_w") ?? [0.0]) as! [Double]
    }
    
    func ArrayDisplayM(){
        arrayM = (UD.array(forKey: "NumArray_m") ?? [0.0]) as! [Double]
    }
}



