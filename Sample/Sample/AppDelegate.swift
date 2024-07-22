//
//  AppDelegate.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var allowLandscapeOrientation: Bool = true
    var orientations: UIInterfaceOrientationMask = [.portrait]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

extension AppDelegate {

    func setStatusBarColor(_ color: UIColor?) {
        if let keyWindow = UIApplication.shared.windows.first, let color = color {
            var frame = keyWindow.frame
            frame.size.height = 20
            let view = UIView(frame: frame)
            view.backgroundColor = color
            keyWindow.addSubview(view)
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientations
//        if (allowLandscapeOrientation) {
//            return .landscape
//        } else {
//            return .portrait
//        }
    }
}
