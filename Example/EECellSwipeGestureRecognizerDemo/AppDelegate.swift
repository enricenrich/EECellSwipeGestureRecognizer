//
//  AppDelegate.swift
//  EECellSwipeGestureRecognizerDemo
//
//  Created by Enric Enrich on 02/01/16.
//  Copyright © 2016 Enric Enrich. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController: UINavigationController = UINavigationController(rootViewController: MainViewController())
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

