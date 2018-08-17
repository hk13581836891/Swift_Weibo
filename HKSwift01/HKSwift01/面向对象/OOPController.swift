//
//  OOPController.swift
//  HKSwift01
//
//  Created by houke on 2018/8/2.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
// -- 面向对象
/*
 构造函数
    构造函数的基本概念
    :是一种特殊的函数，主要用来在创建对象时初始化对象，为对象成员变量设置初始值，在 oc中构造函数是 initWithXXX,在 swift 中由于支持函数重载，所有的构造函数都是 init
    构造函数的作用：
    分配空间 alloc
    设置初始值 init
 
 
    构造函数的执行顺序
    KVC在构造函数中的使用及原理
    便利构造函数
    析构函数
    区分 重载和重写
 懒加载
 只读属性（计算机属性）
 设置模型数据（didSet）
 
 */

class OOPController: UIViewController {
    //’懒‘加载 - 本质上是一个闭包 使用‘lazy’关键字，如果不使用‘lazy’关键字,则属性的创建会在 storyboard(XML解档)的时候创建，而不是真正在使用的时候创建
    /*
     第一次访问属性时，会执行后面的闭包代码，将闭包的‘结果’保存在 lazy 属性中,下次再访问，不会再执行闭包
     如果没有使用‘lazy’关键字，会在 initWithCoder方法中被调用，当二进制的 storyboard 被还原成视图控制器对象之后，就会被调用
     */
    lazy var lazy :LazyLoading = {
       print("懒加载")
        return LazyLoading()
    }()
    
    //懒加载的简单写法
    lazy var lazy2 :LazyLoading = LazyLoading()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let getterSetter = GetterSetter()
        getterSetter.name  = "zhanga"
        print(getterSetter.name!)
        print(getterSetter.title2!)
        
        let tea = Doctor(dict: ["name" : "miss ho"])
        print(tea.name!)
        return
        
        
        let cat = Cat(name: "mimi", age: 3);
        print("\(cat?.name) -- \(cat?.age) -- \(cat?.color)")
        return 
        
        
        let a = Animal(name: "xiaomao", age: 20)
        //解包时使用？ 表示如果对象为 nil,不继续调用后续的属性或方法
        print("\(a?.name)  \(a?.age)")
        
        return
        
//        let p = Person(name: "lisi", age: 29)
//        print(p.name)
        let p1 = Son(dic: ["tname": "ssee", "age": 19, "title": "undefined"])
        print("\(p1.tname!)  -- \(p1.age)")
        
//        let o = Son(name: "lala", age: 10)
//        print("\(o.name)  -- \(o.age) -- \(o.no)")
//        
//        let o1 = Son(name: "ss", age: 12, no: "009")
//        print("\(o1.name)  -- \(o1.age) -- \(o1.no)")
//        

        
        // Do any additional setup after loading the view.
    }

    

}

































