//
//  MuscleTrainingCounterApp.swift
//  Shared
//
//  Created by 上別縄祐也 on 2022/03/05.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Your code here")
        setup()
        return true
    }
}

@main
struct MuscleTrainingCounterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init(){
#if os(iOS)
        // UMP（同意管理）→ ATT（トラッキング許可）→ AdMob 開始の統合フロー
        ConsentManager.shared.startConsentFlow()
#endif
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

