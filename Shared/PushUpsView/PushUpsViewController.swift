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
import Combine

class PushUpsViewController: UIViewController, CMHeadphoneMotionManagerDelegate, ObservableObject{
    private var pushUpsCounterModel = PushUpsCounterModel()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var counter = "0"
    
    let airpods = CMHeadphoneMotionManager()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        pushUpsCounterModel.$counter.map{ counter in
            "\(counter)"
        }.assign(to: \.counter, on: self)
            .store(in: &subscriptions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            self?.pushUpsCounterModel.countCalculation(data: motion)
        })
    }
    
    func stopCalc(){
        print("stop")
        airpods.stopDeviceMotionUpdates()
        pushUpsCounterModel.stopCaluculation()
    }
    
    func plus(){
        pushUpsCounterModel.counter += 1
    }
    
    func minus(){
        pushUpsCounterModel.counter -= 1
    }
    
    func reset(){
        pushUpsCounterModel.counter = 0
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

        if UD.object(forKey: "today_p") == nil {
            dayCountFlag = true
            weekCountFlag = true
            monthCountFlag = true
            
            UD.set(date, forKey: "today_p")
         }
         else {
             
             
             let now = Date()
             let past = UD.object(forKey: "today_p") as! Date
             
             let thisWeek = pushUpsCounterModel.getWeekStart(date: date)
             let pastWeek = pushUpsCounterModel.getWeekStart(date: past)
             
             let thisMonth = Calendar.current.component(.month, from: now)
             let pastMonth = Calendar.current.component(.month, from: past)
             
             let thisYear = Calendar.current.component(.year, from: now)
             let pastYear = Calendar.current.component(.year, from: past)
             
             dayCountFlag = pushUpsCounterModel.comparePastNow(now: now, past: past, elapsedNumber: &elapsedDays)
             weekCountFlag = pushUpsCounterModel.comparePastNow(now: thisWeek, past: pastWeek, elapsedNumber: &elapsedWeeks)
             monthCountFlag = pushUpsCounterModel.comparePastNowMonth(thisMonth: thisMonth, pastMonth: pastMonth, thisYear: thisYear, pastYear: pastYear, elapsedNumber: &elapsedMonthes)
             
             UD.set(date, forKey: "today_p")
         }
        
        pushUpsCounterModel.graphCountSave(countFlag: &dayCountFlag, numArray: "NumArray_p", elapsedNumber: elapsedDays, saveLength: 7)
        
        pushUpsCounterModel.graphCountSave(countFlag: &weekCountFlag, numArray: "NumArray_w_p", elapsedNumber: elapsedWeeks, saveLength: 4)
        
        pushUpsCounterModel.graphCountSave(countFlag: &monthCountFlag, numArray: "NumArray_m_p", elapsedNumber: elapsedMonthes, saveLength: 6)
        
        pushUpsCounterModel.counter = 0
    }
}
