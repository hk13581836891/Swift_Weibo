//
//  Animal.swift
//  HKSwift01
//
//  Created by houke on 2018/8/3.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

@objcMembers class Animal: NSObject {

    var name :String?
    var age = 0
    
    
    //便利构造函数
    //如果构造函数中出现 ？，表示这个构造函数不一定会创建出对象
    //convenience - 便利构造函数
    /*作用
     1\能够提供条件检测
     2、允许返回 nil,而默认（指定）的构造函数则必须要创建对象
     3\便利构造函数必须调用其他的构造函数去创建对象
     4、便利构造函数必须在条件检测完成之后，以 self.的方式调用其他构造函数，创建对象
     5、便利构造函数本身没有做构造函数该做的事（分配空间、设置初始值），而是依靠其他的构造函数去实现
     6\便利构造函数使用场景非常广
     7\能简化对象的创建方法
     */
    convenience init?(name: String, age:Int){
        if age<0 || age>100 {
            return nil
        }
        //调用其他构造函数，初始化属性 - 在一个构造函数中调用了另外一个构造函数
        self.init(dict: ["name":name, "age": age])
        
    }
    
    //重载构造函数
    init(dict: [String: Any]){
        
        super.init()
        
        setValuesForKeys(dict)
    }
}




















