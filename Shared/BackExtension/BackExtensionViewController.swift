//
//  ViewController.swift
//  MuscleTrainingCounter2
//
//  Created by 上別縄祐也 on 2022/03/09.
//

import UIKit
import CoreMotion
import SwiftUI
import AVFoundation
import Combine

class BackExtensionViewController: UIViewController, CMHeadphoneMotionManagerDelegate, ObservableObject{
    private let backExtensionCounterModel = BackExtensionCounterModel()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var counter = "0"

    let airpods = CMHeadphoneMotionManager()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        backExtensionCounterModel.$counter.map{ counter in
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
            self?.backExtensionCounterModel.countCalculation(data: motion)
        })
    }
    
    
    func stopCalc(){
        print("stop")
        airpods.stopDeviceMotionUpdates()
        backExtensionCounterModel.stopCaluculation()
    }
    
    func plus(){
        backExtensionCounterModel.counter += 1
    }
    
    func minus(){
        backExtensionCounterModel.counter -= 1
    }
    
    func reset(){
        backExtensionCounterModel.counter = 0
    }
    
    let UD = UserDefaults.standard
    func saveDate(){
        self.counter = "0"
        
        let date = Date()
        
        var dayCountFlag = Bool()
        var weekCountFlag = Bool()
        var monthCountFlag = Bool()
        
        var elapsedDays = 0
        var elapsedWeeks = 0
        var elapsedMonthes = 0
        
        if UD.object(forKey: "today_b") == nil {
            dayCountFlag = true
            weekCountFlag = true
            monthCountFlag = true
            
            UD.set(date, forKey: "today_b")
         }
         else {
             
             let now = Date()
             let past = UD.object(forKey: "today_b") as! Date
             
             let thisWeek = backExtensionCounterModel.getWeekStart(date: date)
             let pastWeek = backExtensionCounterModel.getWeekStart(date: past)
             
             let thisMonth = Calendar.current.component(.month, from: now)
             let pastMonth = Calendar.current.component(.month, from: past)
             
             let thisYear = Calendar.current.component(.year, from: now)
             let pastYear = Calendar.current.component(.year, from: past)
             
             dayCountFlag = backExtensionCounterModel.comparePastNow(now: now, past: past, elapsedNumber: &elapsedDays)
             weekCountFlag = backExtensionCounterModel.comparePastNow(now: thisWeek, past: pastWeek, elapsedNumber: &elapsedWeeks)
             monthCountFlag = backExtensionCounterModel.comparePastNowMonth(thisMonth: thisMonth, pastMonth: pastMonth, thisYear: thisYear, pastYear: pastYear, elapsedNumber: &elapsedMonthes)
     
             UD.set(date, forKey: "today_b")
         }
        
        backExtensionCounterModel.graphCountSave(countFlag: &dayCountFlag, numArray: "NumArray_b", elapsedNumber: elapsedDays, saveLength: 7)

        backExtensionCounterModel.graphCountSave(countFlag: &weekCountFlag, numArray: "NumArray_w_b", elapsedNumber: elapsedWeeks, saveLength: 4)

        backExtensionCounterModel.graphCountSave(countFlag: &monthCountFlag, numArray: "NumArray_m_b", elapsedNumber: elapsedMonthes, saveLength: 6)
        
        backExtensionCounterModel.counter = 0
    }
}



