//
//  AppDelegate.swift
//  QuickNews
//
//  Created by Wayne Hsiao on 2019/4/7.
//  Copyright © 2019 Wayne Hsiao. All rights reserved.
//

import UIKit
#if MonkeyTest
import SwiftMonkeyPaws
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    #if MonkeyTest
    var paws: MonkeyPaws?
    #endif

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if MonkeyTest
        paws = MonkeyPaws(view: window!)
        #endif
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
