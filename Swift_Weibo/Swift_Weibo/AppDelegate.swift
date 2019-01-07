//
//  AppDelegate.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/20.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire

/**
 面试题：如何学习第三方框架的？
 1、阅读官方文档
 2、下载官方示例，阅读示例代码 则可以找到框架使用的第一线索
 3、按照线索，编写测试程序，演练功能
 4、根据需求，可以适量的阅读部分框架代码，并且整理笔记,定向模仿，以及测试
 5、根据笔记整理博客
 6、如果有不明白的地方可以看官方文档、谷歌、百度
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func alamfireDemo() {
//        Alamofire.request(URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?)
        
//        let request = NSMutableURLRequest(url: URL(string: "http://resource.ttplus.cn/init.json")!)
        //所有要告诉服务器的额外信息，都通过 forHTTPHeaderField设置
//        request.setValue(String?, forHTTPHeaderField: String)
//
        //1、request只是建立一个网络请求，如果没有后续方法，就什么都不做 //http://resource.ttplus.cn/init.json
        //2、所有要告诉服务器的额外信息，可以通过 header字典参数设置，可以设置User-Agent/Authorization/Cokkie...
        //3、如果服务器支持的编码格式不是 UTF8，可以通过 encoding指定
        //4、'链式'响应
        UIApplication.shared.isNetworkActivityIndicatorVisible = true //显示网络指示器
        Alamofire.request("http://www.httpbin.org/get",
                          method:.get,
                          parameters:["name":"test"],
                          headers: ["User-Agent": "iPhone"]//HTTPHeaders.init()
            ).responseJSON { (response) in
                //隐藏网络指示器
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                print(response)
//            print(response.result)
            //.result.value 就是反序列化完成的 字典/ 数组
            print(response.result.value as Any)
            //输出错误
            print(response.result.error as Any)
            //是否成功
            print(response.result.isSuccess)
            //是否失败
            print(response.result.isFailure)
            }.response { (response) in
//                print(response)
                // 请求头文件
                print(response.request?.allHTTPHeaderFields as Any)
                // TODO: 输出请求对象
                let requestSwf = response.request
                print(requestSwf!)
                /*通过请求对象，我们可以获取请求的一系列信息*/
                // 请求头文件
                print(requestSwf?.allHTTPHeaderFields as Any)
                // 获取请求的缓存规则
                print(requestSwf?.cachePolicy as Any)
                // 获取请求体（body）
                print(requestSwf?.httpBody as Any)
                // 获取请求的方法
                print(requestSwf?.httpMethod as Any)
            }.responseString { (response) in
                //输出字符串的响应结果
                print(response.result.value)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        printLogDebug(message: "test")
        //测试归档的用户账户
        print(UserAccountViewModel.sharedUserAccount.userLogon)
        
        //设置AFN - 当通过 AFN 发起网络请求时(在网络状态不太好情况下)， 会在状态栏显示菊花
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        //Alamfire调试
        alamfireDemo()
        
        setupAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = defaultRootViewController
        window?.makeKeyAndVisible()
        
        //监听通知
        
        NotificationCenter.default.addObserver(forName:
            NSNotification.Name(rawValue: WBSwitchRootViewControllerNotification),
            object: nil, //发送通知的对象，如果为nil,则监听任何对象
            queue: nil) //nil,是在主线程发通知,如果监听到通知后，需要异步处理，此处指定一个队列即可
            {[weak self] (notifaction) in //通知中心和 AppDelegate都是常驻的，易出现循环引用，但结合到生命周期考虑，所以这个闭包也可以不用weakself
                
                let vc = notifaction.object != nil ? WelcomViewController() : MainViewController()
                self?.window?.rootViewController = vc
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





















































