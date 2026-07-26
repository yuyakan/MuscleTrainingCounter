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
        // 今日の日付キーへ回数を加算する（日・週・月は日次データから集計）。
        WorkoutLogStore.shared.addCount(sitUpsCounterModel.counter, to: .sit)
        self.counter = "0"
        sitUpsCounterModel.counter = 0
    }
}



