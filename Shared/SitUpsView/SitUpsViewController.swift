//
//  ViewController.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/03/06.
//

import UIKit
import CoreMotion
import SwiftUI
import AVFoundation
import Combine

class SitUpsViewController: UIViewController, CMHeadphoneMotionManagerDelegate, ObservableObject{
    private let sitUpsCounterModel = SitUpsCounterModel()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var counter = "0"
    
    let airpods = CMHeadphoneMotionManager()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        sitUpsCounterModel.$counter.map{ counter in
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
            self?.sitUpsCounterModel.countCalculation(data: motion)
        })
    }
    
    func stopCalc(){
        print("stop")
        airpods.stopDeviceMotionUpdates()
        sitUpsCounterModel.stopCaluculation()
    }
    
    func plus(){
        sitUpsCounterModel.counter += 1
    }
    
    func minus(){
        sitUpsCounterModel.counter -= 1
    }
    
    func reset(){
        sitUpsCounterModel.counter = 0
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
        
        if UD.object(forKey: "today") == nil {
            dayCountFlag = true
            weekCountFlag = true
            monthCountFlag = true
            
            UD.set(date, forKey: "today")
         }
         else {
             
             let now = Date()
             let past = UD.object(forKey: "today") as! Date
             
             let thisWeek = sitUpsCounterModel.getWeekStart(date: date)
             let pastWeek = sitUpsCounterModel.getWeekStart(date: past)
             
             let thisMonth = Calendar.current.component(.month, from: now)
             let pastMonth = Calendar.current.component(.month, from: past)
             
             let thisYear = Calendar.current.component(.year, from: now)
             let pastYear = Calendar.current.component(.year, from: past)
             
             dayCountFlag = sitUpsCounterModel.comparePastNow(now: now, past: past, elapsedNumber: &elapsedDays)
             weekCountFlag = sitUpsCounterModel.comparePastNow(now: thisWeek, past: pastWeek, elapsedNumber: &elapsedWeeks)
             monthCountFlag = sitUpsCounterModel.comparePastNowMonth(thisMonth: thisMonth, pastMonth: pastMonth, thisYear: thisYear, pastYear: pastYear, elapsedNumber: &elapsedMonthes)
     
             UD.set(date, forKey: "today")
         }
        
        sitUpsCounterModel.graphCountSave(countFlag: &dayCountFlag, numArray: "NumArray", elapsedNumber: elapsedDays, saveLength: 7)
        
        sitUpsCounterModel.graphCountSave(countFlag: &weekCountFlag, numArray: "NumArray_w", elapsedNumber: elapsedWeeks, saveLength: 4)
        
        sitUpsCounterModel.graphCountSave(countFlag: &monthCountFlag, numArray: "NumArray_m", elapsedNumber: elapsedMonthes, saveLength: 6)
        
        sitUpsCounterModel.counter = 0
    }
}



