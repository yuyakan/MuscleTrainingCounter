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
}
