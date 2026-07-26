//
//  InterstitialAd.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2023/12/05.
//

import Foundation
import GoogleMobileAds
import StoreKit

class Interstitial: NSObject, FullScreenContentDelegate, ObservableObject {
    @Published var interstitialAdLoaded: Bool = false

    var interstitialAd: InterstitialAd?

    // 広告のクールダウン。前回表示から this 秒間は再表示しない。
    private let adCooldown: TimeInterval = 60
    private let lastAdShownKey = "lastInterstitialShownAt"

    override init() {
        super.init()
    }

    // リワード広告の読み込み
    func loadInterstitial() {
        InterstitialAd.load(with: "ca-app-pub-3940256099942544/4411468910", request: Request()) { (ad, error) in
            if let _ = error {
                print("😭: 読み込みに失敗しました")
                self.interstitialAdLoaded = false
                return
            }
            print("😍: 読み込みに成功しました")
            self.interstitialAdLoaded = true
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
        }
    }

    // インタースティシャル広告の表示
    func presentInterstitial() {
        let saveCount = UserDefaults.standard.integer(forKey: "saveCount")
        if saveCount < 1 {
            UserDefaults.standard.set(saveCount+1, forKey: "saveCount")
            // 広告を出さない回（奇数回目の保存）はレビューをリクエスト。ただし初回はスキップ。
            requestReviewIfNeeded()
            return
        } else {
            UserDefaults.standard.set(0, forKey: "saveCount")
        }

        // 前回の広告表示から adCooldown 秒以内なら、この回は見送る（次の対象回まで待つ）。
        let lastShown = UserDefaults.standard.double(forKey: lastAdShownKey)
        if lastShown > 0, Date().timeIntervalSince1970 - lastShown < adCooldown {
            print("⏳: クールダウン中のため広告をスキップしました")
            return
        }

        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let root = windowScenes?.keyWindow?.rootViewController
        if let ad = interstitialAd {
            ad.present(from: root!)
            self.interstitialAdLoaded = false
            // 表示できたので時刻を記録する。
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastAdShownKey)
        } else {
            print("😭: 広告の準備ができていませんでした")
            self.interstitialAdLoaded = false
            self.loadInterstitial()
        }
    }
    // レビューダイアログのリクエスト（初回の保存はスキップし、以降の奇数回でリクエスト。実際の表示頻度はOSが制御）
    private func requestReviewIfNeeded() {
        let didFirstSave = UserDefaults.standard.bool(forKey: "didFirstSave")
        if !didFirstSave {
            UserDefaults.standard.set(true, forKey: "didFirstSave")
            return
        }
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    // 失敗通知
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("インタースティシャル広告の表示に失敗しました")
        self.interstitialAdLoaded = false
        self.loadInterstitial()
    }

    // 表示通知
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("インタースティシャル広告を表示しました")
        self.interstitialAdLoaded = false
    }

    // クローズ通知
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("インタースティシャル広告を閉じました")
        self.interstitialAdLoaded = false
    }
}
