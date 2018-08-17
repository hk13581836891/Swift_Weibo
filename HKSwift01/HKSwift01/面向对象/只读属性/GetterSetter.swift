//
//  GetterSetter.swift
//  HKSwift01
//
//  Created by houke on 2018/8/8.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

@objcMembers class GetterSetter: NSObject {
//
    //getter setter 在 Swift中极少用，仅供参考
    //oc 中利用 getter编写懒加载，而 swift 中提供了 lazy
   private var _name :String? //如果不希望暴露的方法或属性 都需要用 private保护起来，private 在 swift中很重要
    
    var name :String?{
        get{
            //返回 _成员变量的值
            return _name
        }
        set{
            //使用 _成员变量记录新的数值
            _name = newValue
        }
    }
    
    //readonly 属性，只写 getter 方法
    //在 swift中以下叫 get only 属性
    var title : String?{
        get{
            return "Mr" + (name ?? "")
        }
    }
    
    //以下是计算型属性和懒加载的对比
    
    //只读属性的简写方法 - 如果属性的 ‘修饰’方法，只提供 getter,那么 get和花括号可以省略
    //另外一种叫法：计算型属性
    //每一次调用的时候，都会执行 {}中的代码 ，结果取决于其他属性或原因
    // *每次都要计算，浪费性能
    // *不需要开辟额外的空间(每次都是从计算获取的结果)
    var title2:String? {
        return "Mr222" + (name ?? "")
    }
    
    //懒加载 -- 第一调用的时候执行闭包，并在 title3中保存闭包执行结果
    //再次调用，不再执行闭包，而是直接返回之前计算的结果
    // *只需要计算一次
    // *需要开辟单独的控件保存计算结果
    // *闭包的代码再也不会被调用
    lazy var title3 : String? = {
       //闭包：是一个提前准备好的代码，在 需要的时候执行
        //使用 self. 用于闭包在执行时，准确的绑定对象
        //闭包中的 self.不能省
        return "Mr 333" + (self.name ?? "")
    }()
    
}

















