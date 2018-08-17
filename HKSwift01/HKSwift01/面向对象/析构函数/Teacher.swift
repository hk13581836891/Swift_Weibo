//
//  Teacher.swift
//  HKSwift01
//
//  Created by houke on 2018/8/6.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

@objcMembers class Teacher: NSObject {

    var name :String?
    
    //与 dealloc类似，主要是负责对象被销毁之前的内存释放工作
    /*
     1\没有 func
     2\没有（）->不允许重载，不允许带参数，不允许直接调用，在系统内部自动调用
     
     在实际开发中，哪些内容需要程序员销毁?
     - 通知 ,如果不注销，程序不会崩溃
     - KVO， 如果不注销，程序会崩溃
     - NSTimer ,会对 target(self)进行强引用
     */
    deinit {
         print("teacher 88")
    }
    
    init(dict: [String : Any]){
        
        super.init()
        setValuesForKeys(dict)
    }
}


















