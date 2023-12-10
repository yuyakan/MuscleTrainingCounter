//
//  SitUpsCounterModelTest.swift
//  Tests iOS
//
//  Created by 上別縄祐也 on 2022/06/22.
//

import XCTest
@testable import MuscleTrainingCounter

class SitUpsCounterModelTest: XCTestCase {
    var sitUpsCounterModel = SitUpsCounterModel()
    
    func comparePastNowTest() {
        XCTContext.runActivity(named: "nowとpastが同じ"){_ in
            XCTAssertTrue(sitUpsCounterModel.comparePastNow(now: "12/34/56", past: "12/34/56"))
        }
        
        XCTContext.runActivity(named: "nowとpastが異なる"){_ in
            XCTAssertFalse(sitUpsCounterModel.comparePastNow(now: "12/34/56", past: "12/34/78"))
        }
    }

}
