//
//  AppDelegate.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let appDependencyContainer = AppDependencyContainer()
    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupSVProgressHUD()
        //Create and hold the appCoordinator
        appCoordinator = appDependencyContainer.makeAppCoordinator()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        window?.rootViewController = appCoordinator.toPresentable()
        window?.makeKeyAndVisible()
        appCoordinator.start()
        return true
    }
    
    private func setupSVProgressHUD() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setMaximumDismissTimeInterval(2)
    }
    
}
