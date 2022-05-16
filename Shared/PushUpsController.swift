//
//  PushController.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/08.
//

import UIKit
import CoreMotion
import SwiftUI
import AVFoundation

class PushUpsController: UIViewController, CMHeadphoneMotionManagerDelegate, ObservableObject{
    @Published var counter = 0
    @Published var daySumCount: [Double] = [0.0]
    @Published var weekSumCount: [Double] = [0.0]
    @Published var monthSumCount: [Double] = [0.0]
    
    let Airpods = CMHeadphoneMotionManager()
    
    var number = 0
    var alls : Double = 0
    var alls_m : Double = 0
    var flag = true
    var flag_m = false
    
    func startCalc(){
        print("start")
        Airpods.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] motion, error  in
            guard let motion = motion else { return }
            self?.getDataAccel(motion)
        })
    }
    
    func getDataAccel(_ data: CMDeviceMotion){
        let y = data.userAcceleration.y
        if (y > 0.0 && flag == true){
            alls += y
        }else if(y < 0.0 && flag_m == true){
            alls_m += y
        }
        if (alls  > 1.0){
            flag_m = true
            alls = 0.0
            alls_m = 0.0
        }
        if (alls_m < -0.8 && flag_m == true){
            counter += 1
            flag = true
            flag_m = false
            alls = 0.0
            alls_m = 0.0
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
        
        let now_day = Date(timeIntervalSinceNow: 60 * 60 * 9)
        
        var judge = Bool()
        var judge_w = Bool()
        var judge_m = Bool()
        
        var daySpan = 0
        var weekSpan = 0

        if UD.object(forKey: "today_p") != nil {
            let past_day = UD.object(forKey: "today_p") as! Date
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

             //日にちが変わっていた場合
            if now != past {
                judge = true
            }
            else {
                judge = false
            }
            
            if now_w != past_w {
                judge_w = true
                UD.set([0.0], forKey: "NumArray_p")
            }
            else {
                judge_w = false
            }

            if now_m != past_m {
               judge_m = true
                UD.set([0.0], forKey: "NumArray_w_p")
            }
            else {
               judge_m = false
            }
            UD.set(now_day, forKey: "today_p")
         }
         //初回実行のみelse
         else {
             judge = true
             judge_w = true
             judge_m = true
             
             UD.set(now_day, forKey: "today_p")
             UD.set([0.0], forKey: "NumArray_p")
             UD.set([0.0], forKey: "NumArray_w_p")
             UD.set([0.0], forKey: "NumArray_m_p")
         }

         /* 日付が変わった場合はtrueの処理 */
         if judge == true {
              judge = false
             if UD.array(forKey: "NumArray_p") != nil {
                 valueToSave = UD.array(forKey: "NumArray_p")! as! [Double]
                 if daySpan > 1 {
                     for i in 2...daySpan{
                         print(i)
                         valueToSave.append(0.0)
                     }
                 }
             }else{
                 UD.set(valueToSave, forKey: "NumArray_p")
             }
             valueToSave.append(Double(counter))
             UserDefaults.standard.set(valueToSave, forKey: "NumArray_p")
             
         }
         else {
             if UD.array(forKey: "NumArray_p") != nil {
                 valueToSave = UD.array(forKey: "NumArray_p")! as! [Double]
                 temp = valueToSave.removeLast()
                 valueToSave.append(Double(counter) + temp)
             }else{
                 UD.set(valueToSave, forKey: "NumArray_p")
                 valueToSave.append(Double(counter))
             }
             UserDefaults.standard.set(valueToSave, forKey: "NumArray_p")
         }
        
        if judge_w == true {
             judge_w = false
            if UD.array(forKey: "NumArray_w_p") != nil {
                valueToSave = UD.array(forKey: "NumArray_w_p")! as! [Double]
                if weekSpan > 1 {
                    for i in 2...weekSpan{
                        print(i)
                        valueToSave.append(0.0)
                    }
                }
            }else{
                UD.set(valueToSave, forKey: "NumArray_w_p")
            }
            valueToSave.append(Double(counter))
            UserDefaults.standard.set(valueToSave, forKey: "NumArray_w_p")
            
        }
        else {
            if UD.array(forKey: "NumArray_w_p") != nil {
                valueToSave = UD.array(forKey: "NumArray_w_p")! as! [Double]
                temp = valueToSave.removeLast()
                valueToSave.append(Double(counter) + temp)
            }else{
                UD.set(valueToSave, forKey: "NumArray_w_p")
                valueToSave.append(Double(counter))
            }
            UserDefaults.standard.set(valueToSave, forKey: "NumArray_w_p")
        }
        
        if judge_m == true {
             judge_m = false
            if UD.array(forKey: "NumArray_m_p") != nil {
                valueToSave = UD.array(forKey: "NumArray_m_p")! as! [Double]
            }else{
                UD.set(valueToSave, forKey: "NumArray_m_p")
            }
            valueToSave.append(Double(counter))
            UserDefaults.standard.set(valueToSave, forKey: "NumArray_m_p")
            
        }
        else {
            if UD.array(forKey: "NumArray_m_p") != nil {
                valueToSave = UD.array(forKey: "NumArray_m_p")! as! [Double]
                temp = valueToSave.removeLast()
                valueToSave.append(Double(counter) + temp)
            }else{
                UD.set(valueToSave, forKey: "NumArray_m_p")
                valueToSave.append(Double(counter))
            }
            UserDefaults.standard.set(valueToSave, forKey: "NumArray_m_p")
        }
        number = 0
        counter = 0
        alls = 0
        alls_m = 0
        flag = true
        flag_m = false
    }
    
    func ArrayDisplay(){
        daySumCount = (UD.array(forKey: "NumArray_p") ?? [0.0]) as! [Double]
    }
    
    func ArrayDisplayW(){
        weekSumCount = (UD.array(forKey: "NumArray_w_p") ?? [0.0]) as! [Double]
    }
    
    func ArrayDisplayM(){
        monthSumCount = (UD.array(forKey: "NumArray_m_p") ?? [0.0]) as! [Double]
    }
}
