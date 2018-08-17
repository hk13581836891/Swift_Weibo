//
//  Person.swift
//  HKSwift01
//
//  Created by houke on 2018/8/2.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
/*
 构造函数 - 建立一个对象
 给属性分配空间
 设置初始数值
 
 Swift中构造函数都是 init
 
 重载:OC中没有重载的概念
 函数名相同，参数的个数及类型不同，叫做重载，是面向对象设计语言必备标志！
 OC中使用 initwithXXX的方式的替代
 */
//@objcMembers Swift 4.0后,必须写@objcMembers,运行时才能获取属性,才能使用 KVC 给属性赋值
@objcMembers class Person: NSObject {
    
    //对象的属性就应该是可变的
    //可选项，允许变量为空，var 默认值就是 nil
    //在 ios开发中，所有的属性是延迟加载的(在需要的时候才会创建)
    var tname:String? //super.init 结束后，name 并不会被分配空间
    var age:Int = 0 //对于基本数据类型 KVC 不会主动调动‘构造函数’，(oc的基本数据类型不被认为存在构造函数)，因此如果对基本数据类型使用 KVC 设置数值，必须指定初始值，然后空间即被分配完成
    
    //MARK:- KVC构造函数
    //KVC 的构造函数, 用字典设置模型
    init(dic: [String : Any]) {
        //KVC 是 OC 特有的，本质是在运行时，动态的给对象发送‘setVaulesforKey:’消息(给对象发送消息即要求该对象已经存在)
        //设置数值 - 调用 super.init() 是保证对象已经被创建完成
        super.init()
        //KVC 的设置数值
        setValuesForKeys(dic)//当给对象发送 setValuesforKeys消息时,首先判断属性是否被‘实例化’，如果没有被实例化，则调用属性对象的构造函数去实例化该属性，然后设置数值；如果已经分配了空间，则直接设置数值
    }
    override func setValue(_ value: Any?, forKey key: String) {
        print("\(key) \(String(describing: value))")
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("-----\(key) \(String(describing: value))")
    }
    
    //MARK:- 重载 重写
    
    /*
     1、重载:init(name:String, age:Int)
     函数名相同，参数名／参数类型／参数个数不同
     重载函数并不仅仅局限于构造函数
     函数重载是面相对象程序设计语言的重要标志
     OC 不支持函数重载，OC 的替代方式是 withXXX…
     2、重写：override init()
     override关键字
     也叫覆盖，指在子类中定义一个与父类中方法同名同参数列表的方法。
     重写是子类的方法覆盖父类的方法，要求方法名和参数都相同
     因为子类会继承父类的方法，而重写就是将从父类继承过来的方法重新定义一次，重新填写方法中的代码。
     重写必须继承，重载不用

     */
    
    //'重写'默认的构造函数
    //父类提供了这个函数，而子类需要对父类的函数进行扩展，就叫做'重写'- override
    //特点：可以 supper.xxx 调用父类本身的方法
    //(重要：只要是构造函数，就需要给属性设置初始值，和分配空间）
//    override init() {
//        name = "张三"
//        age = 18
//        super.init()
//
//    }
    
    //重载的 ‘构造函数’，(重要：只要是构造函数，就需要给属性设置初始值，和分配空间）
    //注意：如果重载了构造函数，系统默认提供的构造函数 init(),就不能再被访问
//   init(name:String, age:Int)  {
//        self.name = name
//        self.age = age
//    }
}



























