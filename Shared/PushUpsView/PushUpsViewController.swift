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
    
    func getDataAccel(_ data: CMDeviceMotion){
        
    }
    
    func stopCalc(){
        print("stop")
        airpods.stopDeviceMotionUpdates()
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
        let dayFormatter = DateFormatter()
        let monthFormatter = DateFormatter()
        self.counter = "0"
        
        dayFormatter.dateFormat = "yyyy/MM/dd"
        monthFormatter.dateFormat = "yyyy/MM"
        
        let date = Date()
        
        var dayCountFlag = Bool()
        var weekCountFlag = Bool()
        var monthCountFlag = Bool()

        if UD.object(forKey: "today_p") == nil {
            dayCountFlag = true
            weekCountFlag = true
            monthCountFlag = true
            
            UD.set(date, forKey: "today_p")
         }
         else {
             
             let pastDate = UD.object(forKey: "today_p") as! Date
             
             let now = dayFormatter.string(from: date)
             let past = dayFormatter.string(from: pastDate)

             let thisWeekStart = pushUpsCounterModel.getWeekStart(date: date)
             let thisWeek = dayFormatter.string(from: thisWeekStart)
             
             let pastWeekStart = pushUpsCounterModel.getWeekStart(date: pastDate)
             let pastWeek = dayFormatter.string(from: pastWeekStart)
             
             
             let thisMonth = monthFormatter.string(from: date)
             let pastMonth = monthFormatter.string(from: pastDate)
             
             dayCountFlag = pushUpsCounterModel.comparePastNow(now: now, past: past)
             weekCountFlag = pushUpsCounterModel.comparePastNow(now: thisWeek, past: pastWeek)
             monthCountFlag = pushUpsCounterModel.comparePastNow(now: thisMonth, past: pastMonth)
     
             UD.set(date, forKey: "today_p")
         }
        

        pushUpsCounterModel.graphCountSave(countFlag: &dayCountFlag, numArray: "NumArray_p")
        
        pushUpsCounterModel.graphCountSave(countFlag: &weekCountFlag, numArray: "NumArray_w_p")
        
        pushUpsCounterModel.graphCountSave(countFlag: &monthCountFlag, numArray: "NumArray_m_p")
        
        pushUpsCounterModel.counter = 0
    }
}
