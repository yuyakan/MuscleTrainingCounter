//
//  SitUpsCounterModel.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/05/30.
//

import CoreMotion

final class SitUpsCounterModel {
    @Published var counter = 0
    
    func countCalculation(data: CMDeviceMotion) {
        let x = data.rotationRate.x
        let y = data.userAcceleration.y
        var sumPlusRotationRate : Double = 0.0
        var sumMinusRotationRate : Double = 0.0
        var sumPlusAcceleration : Double = 0.0
        var sumMinusAcceleration : Double = 0.0
        var plusCountFlag = false
        var minusCountFlag = true
        
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
            plusCountFlag = true
            minusCountFlag = false
            sumPlusRotationRate = 0.0
            sumMinusRotationRate = 0.0
            sumPlusAcceleration = 0.0
            sumMinusAcceleration = 0.0
            
            counter += 1
        }
    }
    
    
    
    
    let UD = UserDefaults.standard
    let dayFormatter = DateFormatter()
    
    init(){
        dayFormatter.dateFormat = "yyyy/MM/dd"
    }
    
    
    func comparePastNow(now: String, past: String) -> Bool {
        var countFlag = false
        if now != past {
            countFlag = true
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
    
    
    func graphCountSave(countFlag: inout Bool, numArray: String, span: Int, type: Int) {
        var valueToSave: [Double] = []
        valueToSave = UD.array(forKey: "\(numArray)")! as! [Double]
        if countFlag == true {
            countFlag = false
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
