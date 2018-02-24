//
//  AppDelegate.swift
//  SmartPhone
//
//  Created by 王坤田 on 2017/11/7.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import UIKit
import MMDrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let str = "appid=\(APP_ID)"
        
        IFlySpeechUtility.createUtility(str)
        
        let userDefault = UserDefaults.standard
        
        let ip = userDefault.string(forKey: "ip")
        let port = userDefault.string(forKey: "port")
        
        if ip != nil && port != nil {
            
            RMQConfig.share.ip = ip!
            RMQConfig.share.port = port!
            
        }
        
        RMQTool.subscribe()
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        
        
        
        let mainVC = MainVC()
        let sideVC = SideMenuVC()
        let nav = UINavigationController.init(rootViewController: mainVC)
        nav.restorationIdentifier = "MainNavigationControllerRestorationKey"
        let sideNav = UINavigationController.init(rootViewController: sideVC)
        sideNav.restorationIdentifier = "SideNavigationControllerRestorationKey"
        
        let drawerController = MMDrawerController(center: nav, leftDrawerViewController: sideNav)
        
        drawerController?.restorationIdentifier = "MMDrawer"
        
        drawerController?.openDrawerGestureModeMask = .all
        drawerController?.closeDrawerGestureModeMask = .all
        drawerController?.showsShadow = false
        
        window = UIWindow(frame: ScreenSize)
        
        window?.rootViewController = drawerController
        window?.makeKeyAndVisible()
        
        
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

