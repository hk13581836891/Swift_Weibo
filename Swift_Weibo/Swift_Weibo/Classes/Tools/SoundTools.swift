//
//  SoundTools.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/24.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit

class SoundTools: NSObject {
    
    var test:String = "qqq"
    

    //静态区的对象只能设置一次数值
    //swift中的单例写法和懒加载几乎一样 'static let'
    //跟懒加载一样同样是在第一次使用时，才会创建对象
    static let sharedTools = SoundTools()
    
    static let sharedToos1:SoundTools = {
       return SoundTools()
    }()
    
    func testFun() {
        print("testFun")
    }
    
    
//    //在 swift中不允许在函数中定义静态成员,所以定义在函数外部
    static var instance : SoundTools?
    //1、提供全局访问点
    @objc class func sharedTools2() -> SoundTools {
        return SoundTools()
    }
    
    @objc func testClassFun()  {
        print("------")
    }
}
