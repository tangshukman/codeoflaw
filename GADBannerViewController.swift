//
//  AdmobView.swift
//  SuitUp
//
//  Created by 이지원 on 2022/07/20.
//

import SwiftUI
import GoogleMobileAds
import UIKit

struct GADBannerViewController: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
//        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" //test app id
        view.adUnitID = "ca-app-pub-7807731958409371/5356205550" //real adunit id
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
    
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
