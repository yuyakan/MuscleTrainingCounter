//
//  InterstitialAd.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2023/12/05.
//

import Foundation
import GoogleMobileAds

class Interstitial: NSObject, FullScreenContentDelegate, ObservableObject {
    @Published var interstitialAdLoaded: Bool = false

    var interstitialAd: InterstitialAd?

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
            return
        } else {
            UserDefaults.standard.set(0, forKey: "saveCount")
        }
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let root = windowScenes?.keyWindow?.rootViewController
        if let ad = interstitialAd {
            ad.present(from: root!)
            self.interstitialAdLoaded = false
        } else {
            print("😭: 広告の準備ができていませんでした")
            self.interstitialAdLoaded = false
            self.loadInterstitial()
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
