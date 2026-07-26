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
        // 今日の日付キーへ回数を加算する（日・週・月は日次データから集計）。
        WorkoutLogStore.shared.addCount(backExtensionCounterModel.counter, to: .back)
        self.counter = "0"
        backExtensionCounterModel.counter = 0
    }
}



