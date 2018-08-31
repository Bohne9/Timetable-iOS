//
//  AppDelegate.swift
//  Timetable
//
//  Created by Jonah Schueller on 27.02.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseAuth
//import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        Database.database.configure {

        }
        
        MaterialManager.initMaterialManager()
        
        print("----------------------------------------------------------")
        print("REINIT FIREBASE CONFIGURATION! OTHERWISE THERE IS NO DATA!")
        print("----------------------------------------------------------")
        //testID -> ca-app-pub-3940256099942544/2934735716
        //GADMobileAds.configure(withApplicationID: "ca-app-pub-4090633946148380/1795910280")
//        GADMobileAds.configure(withApplicationID: "ca-app-pub-4090633946148380~1795910280")
        
        UIApplication.shared.statusBarStyle = .lightContent
        window?.rootViewController = TabController()
        
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

