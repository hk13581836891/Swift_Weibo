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
        window?.rootViewController = defaultRootViewController
        window?.makeKeyAndVisible()
        
        //监听通知
        
        NotificationCenter.default.addObserver(forName:
            NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification),
            object: nil, //发送通知的对象，如果为nil,则监听任何对象
            queue: nil)
            { (notifaction) in
            
            }
        return true
    }
    
    deinit {
        //注销通知- 注销指定的通知
        NotificationCenter.default.removeObserver(self, //监听者
                                                  name: NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification), //监听的通知
                                                  object: nil) //发送通知的对象
    }
    //全局外观设置 - 在很多应用程序中，都会在 AppDelegate 中设置所有需要控件的全局外观
    func setupAppearance()  {
        //修改导航栏的全局外观 - 要在控件创建之前设置，一经设置全局有效
        UINavigationBar.appearance().tintColor = WBAppearanceTintColor
        UITabBar.appearance().tintColor = WBAppearanceTintColor
    }
}


// MARK: - 界面切换代码
extension AppDelegate {
    
    //启动的根视图控制器
    private var defaultRootViewController : UIViewController {
       
        //1、判断是否登录
        if UserAccountViewModel.sharedUserAccount.userLogon {
            
            return isNewVersion ? NewFeatureViewController() : WelcomViewController()
        }
        //2、没有登录返回主控制器
        return MainViewController()
    }
    
    //判断是否新版本 - 计算型属性
    private var isNewVersion:Bool {
        //1、当前的版本 - info.plist
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let version = Double(currentVersion)!
        
        //2、‘之前版本’，把当前版本保存在用户偏好
        //double(forKey:的好处 - 如果 key不存在，返回0，这样更方便比较
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = UserDefaults.standard.double(forKey: sandboxVersionKey)
        
        //3、保存当前版本
        UserDefaults.standard.set(version, forKey: sandboxVersionKey)
        
        return version > sandboxVersion
    }
}





















































