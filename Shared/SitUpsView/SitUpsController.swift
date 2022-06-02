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

class SitUpsController: UIViewController, CMHeadphoneMotionManagerDelegate, ObservableObject{
    private let sitUpsCounterModel = SitUpsCounterModel()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var counter = "0"
    @Published var daySumCount: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    @Published var weekSumCount: [Double] = [0.0, 0.0, 0.0, 0.0]
    @Published var monthSumCount: [Double] = [0.0, 0.0, 0.0, 0.0]
    
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
    }
    
    func plus(){
        sitUpsCounterModel.counter += 1
        print(sitUpsCounterModel.counter)
        print(self.counter)
    }
    
    func minus(){
        sitUpsCounterModel.counter -= 1
    }
    
    func reset(){
        sitUpsCounterModel.counter = 0
    }
    
    let UD = UserDefaults.standard
    func saveDate(){
        let dayFormatter = DateFormatter()
        let monthFormatter = DateFormatter()
        self.counter = "0"
        
        dayFormatter.dateFormat = "yyyy/MM/dd"
        monthFormatter.dateFormat = "yyyy/MM"
        
        let date = Date()
        
        var dayCountFlag = Bool()
        var weekCountFlag = Bool()
        var monthCountFlag = Bool()
        
        var daySpan = 0
        var weekSpan = 0

        if UD.object(forKey: "today") == nil {
            dayCountFlag = true
            weekCountFlag = true
            monthCountFlag = true
            
            UD.set(date, forKey: "today")
         }
         else {
             
             let pastDate = UD.object(forKey: "today") as! Date
             
             let now = dayFormatter.string(from: date)
             let past = dayFormatter.string(from: pastDate)
             
             let span = date.timeIntervalSince(pastDate)
             daySpan = Int(span/60/60/24)

             let thisWeekStart = sitUpsCounterModel.getWeekStart(date: date)
             let thisWeek = dayFormatter.string(from: thisWeekStart)
             
             let pastWeekStart = sitUpsCounterModel.getWeekStart(date: pastDate)
             let pastWeek = dayFormatter.string(from: pastWeekStart)
             
             weekSpan = Int(thisWeekStart.timeIntervalSince(pastWeekStart)/60/60/24/7)
             
             let thisMonth = monthFormatter.string(from: date)
             let pastMonth = monthFormatter.string(from: pastDate)
             
             dayCountFlag = sitUpsCounterModel.comparePastNow(now: now, past: past)
             weekCountFlag = sitUpsCounterModel.comparePastNow(now: thisWeek, past: pastWeek)
             monthCountFlag = sitUpsCounterModel.comparePastNow(now: thisMonth, past: pastMonth)
     
             UD.set(date, forKey: "today")
         }
        
         /* 日付が変わった場合はtrueの処理 */
        sitUpsCounterModel.graphCountSave(countFlag: &dayCountFlag, numArray: "NumArray", span: daySpan, type: spanType.day.rawValue)
        
        sitUpsCounterModel.graphCountSave(countFlag: &weekCountFlag, numArray: "NumArray_w", span: weekSpan, type: spanType.week.rawValue)
        
        sitUpsCounterModel.graphCountSave(countFlag: &monthCountFlag, numArray: "NumArray_m", span: 0, type: spanType.month.rawValue)
        
        sitUpsCounterModel.counter = 0
    }
    
    func displayDay(){
        daySumCount = (UD.array(forKey: "NumArray") ?? [0.0]) as! [Double]
    }
    
    func displayWeek(){
        weekSumCount = (UD.array(forKey: "NumArray_w") ?? [0.0]) as! [Double]
    }
    
    func displayMonth(){
        monthSumCount = (UD.array(forKey: "NumArray_m") ?? [0.0]) as! [Double]
    }
}



