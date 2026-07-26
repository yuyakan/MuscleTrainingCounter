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
        // 今日の日付キーへ回数を加算する（日・週・月は日次データから集計）。
        WorkoutLogStore.shared.addCount(pushUpsCounterModel.counter, to: .push)
        self.counter = "0"
        pushUpsCounterModel.counter = 0
    }
}
