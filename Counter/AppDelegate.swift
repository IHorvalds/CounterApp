//
//  AppDelegate.swift
//  Counter
//
//  Created by Tudor Croitoru on 21/04/2019.
//  Copyright © 2019 Tudor Croitoru. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("wtf3")
        print(globalCounters)
        Counter.writeCounterArrayToDefaults(counters: globalCounters)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("wtf")
        Counter.writeCounterArrayToDefaults(counters: globalCounters)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("wtf1")
        Counter.writeCounterArrayToDefaults(counters: globalCounters)
    }


}

