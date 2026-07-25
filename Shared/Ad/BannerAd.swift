//
//  BannerAd.swift
//  MuscleTrainingCounter
//
//  Created by 上別縄祐也 on 2022/04/02.
//

import SwiftUI
import GoogleMobileAds

struct AdBannerView: UIViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> UIViewController {
        let viewController = BannerAdViewController()
        return viewController
    }

    func updateUIViewController(_: UIViewController, context _: Context) {}
}

class BannerAdViewController: UIViewController, BannerViewDelegate {
    var bannerView: BannerView!
    let adUnitID = "ca-app-pub-3940256099942544/2934735716" //テスト

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBanner()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            guard let self else { return }
            self.loadBanner()
        }
    }

    private func loadBanner() {
        let bannerWidth = view.frame.size.width
        bannerView = BannerView(adSize: currentOrientationAnchoredAdaptiveBanner(width: bannerWidth))
        bannerView.adUnitID = adUnitID

        bannerView.delegate = self
        bannerView.rootViewController = self

        bannerView.load(Request())

        setAdView(bannerView)
    }

    func setAdView(_ view: BannerView) {
        bannerView = view
        self.view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        let viewDictionary = ["_bannerView": bannerView!]
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[_bannerView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary
            )
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_bannerView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary
            )
        )
    }
}
