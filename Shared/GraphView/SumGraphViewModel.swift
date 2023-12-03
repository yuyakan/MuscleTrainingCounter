//
//  SumGraphViewModel.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/06/02.
//

import Foundation

class SumGraphViewModel: ObservableObject{
    @Published var sitUpsDaySumCount: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    @Published var sitUpsWeekSumCount: [Double] = [0.0, 0.0, 0.0, 0.0]
    @Published var sitUpsMonthSumCount: [Double] = [0.0, 0.0, 0.0, 0.0]
    
    @Published var pushUpsDaySumCount: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    @Published var pushUpsWeekSumCount: [Double] = [0.0, 0.0, 0.0, 0.0]
    @Published var pushUpsMonthSumCount: [Double] = [0.0, 0.0, 0.0, 0.0]
    
    let UD = UserDefaults.standard
    
    func displaySitUpsDay(){
        sitUpsDaySumCount = (UD.array(forKey: "NumArray") ?? [0.0]) as! [Double]
    }
    
    func displaySitUpsWeek(){
        sitUpsWeekSumCount = (UD.array(forKey: "NumArray_w") ?? [0.0]) as! [Double]
    }
    
    func displaySitUpsMonth(){
        sitUpsMonthSumCount = (UD.array(forKey: "NumArray_m") ?? [0.0]) as! [Double]
    }
    
    func displayPushUpsDay(){
        pushUpsDaySumCount = (UD.array(forKey: "NumArray_p") ?? [0.0]) as! [Double]
    }
    
    func displayPushUpsWeek(){
        pushUpsWeekSumCount = (UD.array(forKey: "NumArray_w_p") ?? [0.0]) as! [Double]
    }
    
    func displayPushUpsMonth(){
        pushUpsMonthSumCount = (UD.array(forKey: "NumArray_m_p") ?? [0.0]) as! [Double]
    }
}
