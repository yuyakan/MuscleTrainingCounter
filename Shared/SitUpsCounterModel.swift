//
//  SitUpsCounterModel.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/05/30.
//

import CoreMotion

final class SitUpsCounterModel {
    @Published var counter = 0
    
    var sumPlusRotationRate : Double = 0.0
    var sumMinusRotationRate : Double = 0.0
    var sumPlusAcceleration : Double = 0.0
    var sumMinusAcceleration : Double = 0.0
    
    var accelPlusCountFlag = false
    var accelMinusCountFlag = true
    
    var rotatePlusCountFlag = true
    var rotateMinusCountFlag = false
    
    
    func countCalculation(data: CMDeviceMotion) {
        let x = data.rotationRate.x
        let y = data.userAcceleration.y
        
        if ( x > 0.0 && rotatePlusCountFlag == true){
            sumPlusRotationRate += x
        }else if(x < 0.0 && rotateMinusCountFlag == true){
            sumMinusRotationRate += x
        }
        
        if (y > 0.0 && accelPlusCountFlag == true){
            sumPlusAcceleration += y
        }else if(y < 0.0 && accelMinusCountFlag == true){
            sumMinusAcceleration += y
        }
        
        
        if ((sumPlusRotationRate > 15.0)){
            rotateMinusCountFlag = true
            rotatePlusCountFlag = false
            
            sumMinusRotationRate = 0.0
            sumPlusRotationRate = 0.0
        }
        if (sumMinusAcceleration < -1.5){
            accelMinusCountFlag = false
            accelPlusCountFlag = true
            
            sumMinusAcceleration = 0.0
            sumPlusAcceleration = 0.0
        }
        
        if ((sumMinusRotationRate < -15) || (sumPlusAcceleration > 0.7)){
            accelPlusCountFlag = false
            accelMinusCountFlag = true
            rotatePlusCountFlag = true
            rotateMinusCountFlag = false
            
            sumPlusRotationRate = 0.0
            sumMinusRotationRate = 0.0
            sumPlusAcceleration = 0.0
            sumMinusAcceleration = 0.0
            
            counter += 1
        }
    }
    
    func stopCaluculation(){
        sumPlusRotationRate = 0.0
        sumMinusRotationRate = 0.0
        sumPlusAcceleration = 0.0
        sumMinusAcceleration = 0.0
        accelPlusCountFlag = false
        accelMinusCountFlag = true
        rotatePlusCountFlag = true
        rotateMinusCountFlag = false
    }
    
    
    
    func comparePastNow(now: Date, past: Date, elapsedNumber: inout Int) -> Bool {
        var countFlag = false
        let calendar = Calendar(identifier: .gregorian)
        
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
    
    func graphCountSave(countFlag: inout Bool, numArray: String, elapsedNumber: Int) {
        var valueToSave: [Double] = []
        valueToSave = UserDefaults.standard.array(forKey: "\(numArray)")! as! [Double]
        if countFlag == true {
            countFlag = false
            
            if elapsedNumber > 8 {
                for i in 0 ..< 7 {
                    print(i)
                    valueToSave.remove(at: 1)
                    valueToSave.append(0)
                }
            } else if (elapsedNumber > 1) {
                for i in 1 ..< elapsedNumber {
                    print(i)
                    valueToSave.remove(at: 1)
                    valueToSave.append(0)
                }
            }
            
            valueToSave.remove(at: 1)
            valueToSave.append(Double(counter))
        }
        else {
            let temp = valueToSave.removeLast()
            valueToSave.append(Double(counter) + temp)
        }
        UserDefaults.standard.set(valueToSave, forKey: "\(numArray)")
    }
}
