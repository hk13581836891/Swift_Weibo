//
//  UserAccount.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/29.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

//用户账户模型
@objcMembers class UserAccount: NSObject {
    
    //用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
    var access_token:String?
    //access_token的生命周期，单位是秒数。
    var expires_in:TimeInterval = 0
    //授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
    var uid:String?

    init(dict:[String : Any]){
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//         print("-----\(key) \(String(describing: value))")
    }
    
    override var description: String {
        let keys = ["access_token", "expires_in", "uid"]
        
        return "\(dictionaryWithValues(forKeys: keys))\n"
        
    }
}
















