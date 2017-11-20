//
//  AppDelegate.swift
//  SmenaApp
//
//  Created by Andrei Valkovskii on 20/11/2017.
//  Copyright © 2017 Andrei Valkovskii. All rights reserved.
//

import UIKit
import Smena

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let controller = UIViewController()

        controller.view.backgroundColor = .white

        window.rootViewController = controller
        window.makeKeyAndVisible()

        self.window = window
        return true
    }
}

