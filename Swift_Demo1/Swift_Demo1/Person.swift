//
//  Person.swift
//  Swift_Demo1
//
//  Created by houke on 2018/8/13.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

//个人信息
@objcMembers class Person: NSObject {
    var name:String?
    var age:Int = 0
    
    init(dict :[String: Any]) {
        super.init()
        //字典转模型
        setValuesForKeys(dict)
    }
    //对象描述信息, 有利于开发调试
    override var description: String{
        let keys = ["name", "age"]
        
        //模型转字典
        return "\(dictionaryWithValues(forKeys: keys))\n"
    }
    
    
}



















