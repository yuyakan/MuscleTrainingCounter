//
//  ConsentManager.swift
//  MuscleTrainingCounter
//
//  UMP（Google の同意管理）と ATT（Apple のトラッキング許可）を統合し、
//  パーソナライズ広告のための同意フローを実行する。
//

import Foundation
import UserMessagingPlatform
import AppTrackingTransparency
import GoogleMobileAds

final class ConsentManager {
    static let shared = ConsentManager()
    private init() {}

    /// アプリ起動時に呼ぶ。UMP 同意 → ATT リクエスト → AdMob 開始 の順に実行する。
    func startConsentFlow() {
        let parameters = RequestParameters()
        // 本番では未成年向けタグ等を必要に応じて設定する。
#if DEBUG
        // デバッグ時に同意フォームを強制表示したい場合は DebugSettings を使う（デバイスIDは実機ログから取得）。
        // let debugSettings = DebugSettings()
        // debugSettings.geography = .EEA
        // parameters.debugSettings = debugSettings
#endif

        ConsentInformation.shared.requestConsentInfoUpdate(with: parameters) { [weak self] error in
            guard let self else { return }
            if error != nil {
                // 更新に失敗しても、非パーソナライズ広告のため AdMob は開始する。
                self.requestATTThenStartAds()
                return
            }

            // 必要であれば同意フォームを表示する。
            ConsentForm.loadAndPresentIfRequired(from: nil) { _ in
                // UMP 完了後に ATT を要求し、AdMob を開始する。
                self.requestATTThenStartAds()
            }
        }
    }

    /// ATT のトラッキング許可を要求してから AdMob を開始する。
    private func requestATTThenStartAds() {
        // ATT ダイアログはフォアグラウンドで表示する必要があるため少し待つ。
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ATTrackingManager.requestTrackingAuthorization { _ in
                // 許可・非許可にかかわらず AdMob を開始する（非許可時は非パーソナライズ広告）。
                DispatchQueue.main.async {
                    MobileAds.shared.start(completionHandler: nil)
                }
            }
        }
    }
}
