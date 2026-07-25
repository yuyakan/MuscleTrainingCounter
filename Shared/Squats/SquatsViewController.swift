//
//  PushController.swift
//  MuscleTrainingCounter2
//
//  Created by 上別縄祐也 on 2022/03/09.
//

import UIKit
import CoreMotion
import SwiftUI
import AVFoundation
import Combine

class SquatsViewController: UIViewController, CMHeadphoneMotionManagerDelegate, ObservableObject{
    private let squatsCounterModel = SquatsCounterModel()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var counter = "0"

    let airpods = CMHeadphoneMotionManager()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        squatsCounterModel.$counter.map{ counter in
            "\(counter)"
        }.assign(to: \.counter, on: self)
            .store(in: &subscriptions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startCalc(){
        print("start")
        airpods.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {[weak self] motion, error  in
            guard let motion = motion else { return }
            self?.squatsCounterModel.countCalculation(data: motion)
        })
    }
    
    func stopCalc(){
        print("stop")
        squatsCounterModel.stopCaluculation()
        airpods.stopDeviceMotionUpdates()
    }
    
    func plus(){
        squatsCounterModel.counter += 1
    }
    
    func minus(){
        squatsCounterModel.counter -= 1
    }
    
    func reset(){
        squatsCounterModel.counter = 0
    }
    
    func saveDate(){
        let UD = UserDefaults.standard
        self.counter = "0"
        
        let date = Date()
        
        var dayCountFlag = Bool()
        var weekCountFlag = Bool()
        var monthCountFlag = Bool()
        
        var elapsedDays = 0
        var elapsedWeeks = 0
        var elapsedMonthes = 0

        if UD.object(forKey: "today_s") == nil {
            dayCountFlag = true
            weekCountFlag = true
            monthCountFlag = true
            
            UD.set(date, forKey: "today_s")
         }
         else {
             
             
             let now = Date()
             let past = UD.object(forKey: "today_s") as! Date
             
             let thisWeek = squatsCounterModel.getWeekStart(date: date)
             let pastWeek = squatsCounterModel.getWeekStart(date: past)
             
             let thisMonth = Calendar.current.component(.month, from: now)
             let pastMonth = Calendar.current.component(.month, from: past)
             
             let thisYear = Calendar.current.component(.year, from: now)
             let pastYear = Calendar.current.component(.year, from: past)
             
             dayCountFlag = squatsCounterModel.comparePastNow(now: now, past: past, elapsedNumber: &elapsedDays)
             weekCountFlag = squatsCounterModel.comparePastNow(now: thisWeek, past: pastWeek, elapsedNumber: &elapsedWeeks)
             monthCountFlag = squatsCounterModel.comparePastNowMonth(thisMonth: thisMonth, pastMonth: pastMonth, thisYear: thisYear, pastYear: pastYear, elapsedNumber: &elapsedMonthes)
     
             UD.set(date, forKey: "today_s")
         }
        

        squatsCounterModel.graphCountSave(countFlag: &dayCountFlag, numArray: "NumArray_s", elapsedNumber: elapsedDays, saveLength: 7)

        squatsCounterModel.graphCountSave(countFlag: &weekCountFlag, numArray: "NumArray_w_s", elapsedNumber: elapsedWeeks, saveLength: 4)

        squatsCounterModel.graphCountSave(countFlag: &monthCountFlag, numArray: "NumArray_m_s", elapsedNumber: elapsedMonthes, saveLength: 6)
        
        squatsCounterModel.counter = 0
    }
}
