//
//  UserAccount.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/29.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
//单纯 as在 swift 中使用只有一下三种情况 “桥接”,其他时候都是使用 as! 或者 as?
//1> String as NSString
//2> NSArray as [array]
//3> NSDictionary as [String : Any]
//            (path as NSString).strings(byAppendingPaths: [""])

//用户账户模型
@objcMembers class UserAccount: NSObject, NSCoding {
    
    //用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
    var access_token:String?
    //access_token的生命周期，单位是秒数。
    var expires_in:TimeInterval = 0 {
        didSet{
            //计算过期日期
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
   //过期日期
    var expiresDate:Date? //一旦从服务器获得过期的时间，立刻计算准确日期
    //用户昵称
    var screen_name:String?
    // 用户头像地址（大图），180×180像素
    var avatar_large:String?
    
    //授权用户的UID
    var uid:String?//，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。

    init(dict:[String : Any]){
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//         print("-----\(key) \(String(describing: value))")
    }
    
    override var description: String {
        let keys = ["access_token", "expires_in", "expiresDate","uid", "screen_name", "avatar_large"]
        
        return "\(dictionaryWithValues(forKeys: keys))\n"
        
    }
    
    //MARK: - '键值'归档和解档
    
    /// 归档 - 在把当前对象保存到磁盘前，将对象编码城二进制数据 - 跟网络的序列化概念很像
    ///
    /// - Parameter aCoder: 编码器
    func encode(with aCoder: NSCoder) {
         aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expiresDate, forKey: "expiresDate")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        
    }
    
    /// 解档 - 从磁盘加载二进制文件，转换成对象调用-  跟网络的反序列化很像
    ///
    /// - Parameter aDecoder: 解码器
    /// - returns:当前对象
    /// 'required'- 没有继承性，所有的对象只能解档出当前的类对象
    required init?(coder aDecoder: NSCoder) {
        access_token =  aDecoder.decodeObject(forKey: "access_token") as? String
        expiresDate = aDecoder.decodeObject(forKey: "expiresDate") as? Date
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
}
//在 extension中，只允许写遍历构造函数，而不能写指定构造函数
//不能定义存储型属性，定义存储型属性，会破坏类本身的结构
extension UserAccount {
    
}




















































