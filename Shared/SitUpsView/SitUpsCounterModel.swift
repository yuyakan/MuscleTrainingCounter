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

    // 起き上がりを検出したか。カウント確定はこのフラグが立っている時のみ許可し、
    // 1回の腹筋（起き上がり→倒れる）で1カウントを保証する（2重カウント防止）。
    var didSitUp = false

    func countCalculation(data: CMDeviceMotion) {
        let x = data.rotationRate.x

        // 頭部の回転は、起き上がりが −方向 / 倒れが +方向。
        // didSitUp が false のとき（＝まだ倒れている）は起き上がりを、
        // true のとき（＝起き上がり済み）は倒れを検出する。
        if !didSitUp {
            if x < 0.0 {
                sumMinusRotationRate += x
            }
            // 起き上がりを検出 → ここで 1 回カウントする。戻る動作ではカウントしない。
            if sumMinusRotationRate < -15.0 {
                didSitUp = true
                sumPlusRotationRate = 0.0
                sumMinusRotationRate = 0.0
                counter += 1
            }
        } else {
            if x > 0.0 {
                sumPlusRotationRate += x
            }
            // 倒れを検出 → カウントせず、次の起き上がりを受け付けられる状態に戻す。
            if sumPlusRotationRate > 15.0 {
                didSitUp = false
                sumPlusRotationRate = 0.0
                sumMinusRotationRate = 0.0
            }
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
        didSitUp = false
    }
    
    
    
    // now と past の「日数差」を正しく求める（暦をまたいでも正確）。
    // 週の判定でも使うため、呼び出し側で必要に応じて 7 で割って週数に変換する。
    func comparePastNow(now: Date, past: Date, elapsedNumber: inout Int) -> Bool {
        let calendar = Calendar.current
        let startNow = calendar.startOfDay(for: now)
        let startPast = calendar.startOfDay(for: past)
        elapsedNumber = calendar.dateComponents([.day], from: startPast, to: startNow).day ?? 0
        return elapsedNumber > 0
    }
    
    func comparePastNowMonth(thisMonth: Int, pastMonth: Int, thisYear: Int, pastYear: Int, elapsedNumber: inout Int) -> Bool {
        // 経過月数 = 年差×12 + 月差。月または年が変わっていれば期間が変わったとみなす。
        elapsedNumber = (thisYear - pastYear) * 12 + (thisMonth - pastMonth)
        return elapsedNumber > 0
    }
    
    func getWeekStart(date: Date) -> Date {
        let thisWeekDay = Calendar.current.dateComponents([.weekday], from: date).weekday! - 1
        let now_ = Calendar.current.date(byAdding: .day, value: -thisWeekDay, to: date)!
        
        return now_
    }
    
    func graphCountSave(countFlag: inout Bool, numArray: String, elapsedNumber: Int, saveLength: Int) {
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
            } else if (elapsedNumber > 0) {
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
