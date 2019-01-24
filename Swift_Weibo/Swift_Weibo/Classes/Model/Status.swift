//
//  Status.swift
//  Swift_Weibo
//
//  Created by houke on 2018/9/5.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

/// 微博数据模型
@objcMembers class Status: NSObject {
    
    /// 微博ID
    var id:Int = 0
    /// 微博信息内容
    var text:String?
    /// 微博创建时间
    var created_at:String?
    /// 微博来源
    var source:String?{
        didSet {
            //过滤出文本，并且重新设置 source
            source = source?.href()?.text
        }
    }
    /// 缩略图配图数组 key:thumbnail_pic
    var pic_urls:[[String: String]]?
    
    /// 用户模型 - 嵌套模型需重写KVC方法,重写setValue(_ value: Any?, forKey key: String)
    var user:User?
    
    /// 被转发的原微博信息字段
    var retweeted_status:Status?
    
    
    init(dict:[String: Any]){
        super.init()
        //如果使用 KVC 时，value 是一个字典，会直接给属性转换成字典
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forKey key: String) {
        //判断 key是否是 user
        if key == "user" {
            if let dict = value as? [String: Any] {
                user = User(dict: dict)
            }
            return
        }
        //判断 key是否是 retweeted_status
        if key == "retweeted_status" {
            if let dict = value as? [String: AnyObject] {
                retweeted_status = Status(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    override var description: String {
        let keys = ["id","text","created_at","source","pic_urls", "user", "retweeted_status"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
}



























