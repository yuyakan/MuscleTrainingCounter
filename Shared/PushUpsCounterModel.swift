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
    
    func countCalculation(data: CMDeviceMotion) {
        var sumPlusAcceleration : Double = 0
        var sumMinusAcceleration : Double = 0
        var plusCountFlag = true
        var minusCountFlag = false
        
        let y = data.userAcceleration.y
        if (y > 0.0 && plusCountFlag == true){
            sumPlusAcceleration += y
        }else if(y < 0.0 && minusCountFlag == true){
            sumMinusAcceleration += y
        }
        if (sumPlusAcceleration  > 1.0){
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
        }
    }
}
