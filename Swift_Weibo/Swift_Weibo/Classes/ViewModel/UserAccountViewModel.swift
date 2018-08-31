//
//  UserAccountViewModel.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/30.
//  Copyright © 2018年 houke. All rights reserved.
//

import Foundation

///用户账号视图模型 - 没有父类
/*
 模型通常继承自 NSObject -> 可以使用 KVC 设置属性，简化对象构造
 如果没有父类，所有的内容，都需要从头创建，量级更轻
 
 视图模型的作用：封装业务逻辑，通常没有复杂的属性，所以通常没有父类
 */
class UserAccountViewModel {
    
    /// 单例 - 解决避免重复从沙盒加载归档文件，提高效率，让 accessToken便于被访问到
    static let sharedUserAccount = UserAccountViewModel()
    
    //用户模型
    var account:UserAccount?
    //用户登录标记
    var userLogon:Bool {
        //1、如果 token有值，说明登录成功
        //2、如果没有过期，说明登录有效
        return account?.access_token != nil && !isExpired
    }
    
    
    //归档保存的路径 - 计算型属性（类似于有返回值的函数, 可以让调用的时候语义会更清晰）
    private var accountPath:String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        return path.appending("/account.plist")
    }
    
    /* 以上计算型属性相对应的函数写法
     private func accountPath() -> String {
     let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
     return path.appending("/account.plist")
     }
     */

    //判断账户是否过期
    private var isExpired:Bool {
        
        //自己改写日期，测试逻辑是否正确，创建日期时，如果给定 负数，返回比当前时间早的日期
//        account?.expiresDate = Date(timeIntervalSinceNow: -3600)
//        print(account?.expiresDate)
        
        //判断用户账户过期日期与当前系统日期‘进行比较’
        //如果 account为 nil,不会调用后面的属性，后面的比较也不会继续
        if account?.expiresDate?.compare(Date()) == ComparisonResult.orderedDescending {
            //没过期 代码执行到此，一定进行过比较
            return false
        }
        //如果过期返回 true
        return true
    }

    //构造函数 - 私有化，会要求外部只能通过单例常量访问，而不能（）实例化
    private init() {
        //从沙盒解档数据,回复当前数据 - 磁盘读写速度最慢，不如内存读写效率高
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        
        //判断 accessToken是否过期
        if isExpired {
            print("已经过期")
            //如果过期，情况解档数据
            account = nil
        }
        print(account)
    }
    
}

// MARK: - 用户账户相关网络方法
/*
 代码重构的步骤
 1、新方法
 2、粘贴代码
 3、根据上下文调整参数和返回值
 4、移动其他‘子’方法
 */
extension UserAccountViewModel {
    
    /// 加载 token
    ///
    /// - Parameters:
    ///   - code: 授权码
    ///   - finish: 完成回调（是否成功）
    func loadAccessToken(code: String, finish:@escaping (Bool) -> ())  {
        //4、加载 accessToken
        NetworkTools.sharedTools.loadAccessToken(code: code) { (result, error) in
            //1>判断错误
            if error != nil {
                print("获取 AccessToken 失败")
                //失败回调
                finish(false)
                return
            }
            //2>输出结果 - 在 swift中任何 Any 在使用前，必须转换类型 -> as ?/类型
            //创建账户对象
            self.account = UserAccount(dict: result as! [String : Any])
            //获取头像昵称
            self.loadUserInfo(account:self.account!, finish: finish)
            
        }
    }
    
    /// 加载用户信息
    ///
    /// - Parameter account: 用户账户对象
    private func loadUserInfo(account:UserAccount , finish:@escaping (Bool) -> ())  {
        
        NetworkTools.sharedTools.loadUserInfo(uid: account.uid!, accessToken: account.access_token!) { (result, error) in
            if error != nil {
                print("加载用户信息出错了")
                finish(false)
                return
            }
            //提示：如果使用 if let / guard let 统统使用‘？’
            //做了两个判断 1、一定有内容 2、一定是字典
            guard let dict = result as? [String : Any]  else {
                print("格式错误")
                finish(false)
                return
            }
            
            //经过 guard守护后 dict一定是一个有值的字典
            //将用户信息保存
            account.screen_name = dict["screen_name"] as? String
            account.avatar_large = dict["avatar_large"] as? String
            
            //保存对象
            account.saveUserAccount()
            
            //需要完成回调！！！
            finish(true)
        }
    }
}




































