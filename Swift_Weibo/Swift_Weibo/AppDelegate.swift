//
//  AppDelegate.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/20.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //测试归档的用户账户
        print(UserAccountViewModel.sharedUserAccount.userLogon)
        setupAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    //全局外观设置 - 在很多应用程序中，都会在 AppDelegate 中设置所有需要控件的全局外观
    func setupAppearance()  {
        //修改导航栏的全局外观 - 要在控件创建之前设置，一经设置全局有效
        UINavigationBar.appearance().tintColor = AppearanceTintColor
        UITabBar.appearance().tintColor = AppearanceTintColor
    }
}
















