//
//  PushUpsCounterModel.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/06/01.
//

import SwiftUI
import CoreMotion

final class PushUpsCounterModel {
    @Published var counter = 0
    
    var sumPlusAcceleration : Double = 0
    var sumMinusAcceleration : Double = 0
    var plusCountFlag = true
    var minusCountFlag = false
    
    func countCalculation(data: CMDeviceMotion) {
        let y = data.userAcceleration.y
        if (y > 0.0 && plusCountFlag == true){
            sumPlusAcceleration += y
        }else if(y < 0.0 && minusCountFlag == true){
            sumMinusAcceleration += y
        }
        if (sumPlusAcceleration  > 1.2){
            minusCountFlag = true
            sumPlusAcceleration = 0.0
            sumMinusAcceleration = 0.0
        }
        if (sumMinusAcceleration < -0.8 && minusCountFlag == true){
            counter += 1
            plusCountFlag = true
            minusCountFlag = false
            sumPlusAcceleration = 0.0
            sumMinusAcceleration = 0.0
            print(counter)
        }
    }
    
    func stopCaluculation() {
        sumPlusAcceleration = 0
        sumMinusAcceleration = 0
        plusCountFlag = true
        minusCountFlag = false
    }
    
    func comparePastNow(now: Date, past: Date, elapsedNumber: inout Int) -> Bool {
        var countFlag = false
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        
        let pastYear = calendar.component(.year, from: past)
        let pastMonth = calendar.component(.month, from: past)
        let pastDay = calendar.component(.day, from: past)
        
        elapsedNumber = (year * 365 + month * 30 + day) - (pastYear * 365 + pastMonth * 30 + pastDay)
        
        if elapsedNumber > 0 {
            countFlag = true
        }
        else {
            countFlag = false
        }
        return countFlag
    }
    
    func comparePastNowMonth(thisMonth: Int, pastMonth: Int, thisYear: Int, pastYear: Int, elapsedNumber: inout Int) -> Bool {
        var countFlag = false
        
        if thisMonth != pastMonth || thisYear != pastYear {
            countFlag = true
            elapsedNumber = (thisMonth - pastYear) + (thisYear - thisMonth) * 12
        }
        else {
            countFlag = false
        }
        return countFlag
    }
    
    func getWeekStart(date: Date) -> Date {
        let thisWeekDay = Calendar.current.dateComponents([.weekday], from: date).weekday! - 1
        let now_ = Calendar.current.date(byAdding: .day, value: -thisWeekDay, to: date)!
        
        return now_
    }
    
    func graphCountSave(countFlag: inout Bool, numArray: String, elapsedNumber: Int, saveLength: Int) {
        print(elapsedNumber)
        var valueToSave: [Double] = []
        valueToSave = UserDefaults.standard.array(forKey: "\(numArray)")! as! [Double]
        if countFlag == true {
            countFlag = false
            
            if elapsedNumber >= saveLength {
                for i in 0 ..< saveLength {
                    print(i)
                    valueToSave.remove(at: 1)
                    valueToSave.insert(0, at: saveLength)
                }
            } else if (elapsedNumber > 1) {
                for i in 1 ..< elapsedNumber {
                    print(i)
                    valueToSave.remove(at: 1)
                    valueToSave.insert(0, at: saveLength)
                }
            }
            valueToSave.remove(at: 1)
            valueToSave.insert(Double(counter), at: saveLength)
        }
        else {
            let temp = valueToSave.remove(at: saveLength)
            valueToSave.insert(Double(counter) + temp, at: saveLength)
        }
        UserDefaults.standard.set(valueToSave, forKey: "\(numArray)")
    }
}
