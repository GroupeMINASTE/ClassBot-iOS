//
//  AppDelegate.swift
//  ClassBot
//
//  Created by Nathan FALLET on 04/04/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Create view
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: HomeTableViewController(style: .grouped))
        window?.makeKeyAndVisible()
        
        return true
    }

}

