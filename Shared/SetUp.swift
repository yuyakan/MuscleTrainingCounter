//
//  SetUp.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/06/02.
//

import Foundation

func setup(){
    let isVisit = UserDefaults.standard.bool(forKey: "visit")
    if isVisit {
        print("二回目以降")
    } else {
        print("初回起動")
    }

    // visit フラグに関係なく、未設定のキーだけ初期化する（マイグレーション対応）。
    // 既存ユーザーが種目追加後のアップデートをしても、腹筋・腕立てのデータは保持され、
    // 新種目（背筋・スクワット）のキーだけが初期化される。
    ensureArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], forKey: "NumArray")
    ensureArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0], forKey: "NumArray_w")
    ensureArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], forKey: "NumArray_m")

    ensureArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], forKey: "NumArray_p")
    ensureArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0], forKey: "NumArray_w_p")
    ensureArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], forKey: "NumArray_m_p")

    ensureArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], forKey: "NumArray_b")
    ensureArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0], forKey: "NumArray_w_b")
    ensureArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], forKey: "NumArray_m_b")

    ensureArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], forKey: "NumArray_s")
    ensureArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0], forKey: "NumArray_w_s")
    ensureArray([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], forKey: "NumArray_m_s")

    ensureInt(30, forKey: "targetSitDayCount")
    ensureInt(30, forKey: "targetPushDayCount")
    ensureInt(100, forKey: "targetSitWeekCount")
    ensureInt(100, forKey: "targetPushWeekCount")
    ensureInt(300, forKey: "targetSitMonthCount")
    ensureInt(300, forKey: "targetPushMonthCount")

    ensureInt(30, forKey: "targetBackDayCount")
    ensureInt(30, forKey: "targetSquatDayCount")
    ensureInt(100, forKey: "targetBackWeekCount")
    ensureInt(100, forKey: "targetSquatWeekCount")
    ensureInt(300, forKey: "targetBackMonthCount")
    ensureInt(300, forKey: "targetSquatMonthCount")

    // 旧配列データを日付キー辞書へ一度だけ移行する（既存ユーザーの直近データを引き継ぐ）。
    WorkoutLogStore.shared.migrateLegacyArraysIfNeeded()
}

/// キーが未設定のときだけ配列の初期値を設定する。
private func ensureArray(_ value: [Double], forKey key: String) {
    if UserDefaults.standard.array(forKey: key) == nil {
        UserDefaults.standard.set(value, forKey: key)
    }
}

/// キーが未設定のときだけ整数の初期値を設定する。
private func ensureInt(_ value: Int, forKey key: String) {
    if UserDefaults.standard.object(forKey: key) == nil {
        UserDefaults.standard.set(value, forKey: key)
    }
}
