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
        // 今日の日付キーへ回数を加算する（日・週・月は日次データから集計）。
        WorkoutLogStore.shared.addCount(squatsCounterModel.counter, to: .squat)
        self.counter = "0"
        squatsCounterModel.counter = 0
    }
}
